#!/Users/brad/.venv/bin/python

import os

os.environ.setdefault("PYTORCH_ENABLE_MPS_FALLBACK", "1")
import sys
import torch
import whisperx
from faster_whisper import WhisperModel
from pyannote.audio import Pipeline
import ffmpeg
from pathlib import Path
from typing import cast
import json
import soundfile as sf


# Removes noise from the audio input with gentler, more speaker-friendly processing
# Tunables via env vars:
#   NR_MODE   = off | light | moderate   (default: moderate)
#   NR_BLEND  = float mix ratio for denoised branch in wet/dry mix (default: 0.6 for moderate, 0.4 for light)
#   ARNNDN_MODEL = path to .rnnn model (default: /Users/brad/bin/arnndn-models/std.rnnn)
#   HPF       = high-pass cutoff Hz (default: 60)
#   LPF       = low-pass cutoff Hz (default: 12000)
#   LUFS_I    = loudness target (default: -24)
#   LUFS_LRA  = loudness range (default: 13)
#   LUFS_TP   = true peak (default: -1)


# ------- CLI -------
args = sys.argv[1:]
FLAGS = {a for a in args if a.startswith("--")}
RAW = "--raw" in FLAGS
FORCE = "--force" in FLAGS
POSITIONAL = [a for a in args if not a.startswith("--")]
MIN_SPEAKERS = MAX_SPEAKERS = 5

if len(POSITIONAL) < 1:
    print("Usage: diarize.py [--raw] <audiofile>")
    sys.exit(1)
AUDIO = POSITIONAL[0]

base_name = Path(AUDIO).stem
work_dir = Path(AUDIO).resolve().parent / base_name
work_dir.mkdir(parents=True, exist_ok=True)

if RAW:
    print("Mode: RAW output (no cleanup post-processing)")
else:
    print("Mode: CLEAN output (prefix/duplicate merge enabled)")
print(f"Artifacts folder: {work_dir}  |  Resume: {'yes' if not FORCE else 'no (force)'}")


def _json_dump(obj, path: Path):
    path.parent.mkdir(parents=True, exist_ok=True)
    with open(path, "w") as f:
        json.dump(obj, f, ensure_ascii=False, indent=2)

def _json_load(path: Path):
    with open(path) as f:
        return json.load(f)


def _preprocess_audio(in_path: str, out_path: Path) -> str:

    # --- Defaults & env overrides ---
    nr_mode = os.getenv("NR_MODE", "moderate").strip().lower()  # off|light|moderate
    arnndn_model = os.getenv("ARNNDN_MODEL", "/Users/brad/bin/arnndn-models/std.rnnn")
    try:
        # If NR_BLEND is provided, use it; otherwise choose from mode
        nr_blend = float(os.getenv("NR_BLEND", "nan"))
    except ValueError:
        nr_blend = float("nan")

    if nr_mode not in {"off", "light", "moderate"}:
        nr_mode = "moderate"

    if nr_mode == "light" and (nr_blend != nr_blend):  # NaN check
        nr_blend = 0.4  # lighter NR contribution
    if nr_mode == "moderate" and (nr_blend != nr_blend):
        nr_blend = 0.6  # balanced NR contribution

    # Basic EQ and loudness targets
    HPF = int(os.getenv("HPF", "60"))
    LPF = int(os.getenv("LPF", "12000"))
    LUFS_I = os.getenv("LUFS_I", "-24")
    LUFS_LRA = os.getenv("LUFS_LRA", "13")
    LUFS_TP = os.getenv("LUFS_TP", "-1")

    # --- Build filter graph ---
    # We use an "af" filter graph so we can do a wet/dry arnndn blend when enabled.
    if nr_mode == "off":
        # No denoise; gentle EQ + loudness only
        af_graph = (
            f"highpass=f={HPF}, "
            f"lowpass=f={LPF}, "
            f"loudnorm=I={LUFS_I}:TP={LUFS_TP}:LRA={LUFS_LRA}"
        )
        mode_desc = f"NR=off | HPF={HPF}Hz, LPF={LPF}Hz, loudnorm I={LUFS_I} LRA={LUFS_LRA} TP={LUFS_TP}"
    else:
        # Denoise on split branch, then mix back with original at a controlled ratio
        # asplit=2[a][b]; [a]arnndn=... [den]; [b][den]amix=inputs=2:weights=1 {nr_blend}:normalize=0[mix]; [mix]loudnorm=...
        af_graph = (
            f"highpass=f={HPF}, lowpass=f={LPF}, "
            f"asplit=2[a][b]; "
            f"[a]arnndn=m={arnndn_model}[den]; "
            f"[b][den]amix=inputs=2:weights=1 {nr_blend}:normalize=0[mix]; "
            f"[mix]loudnorm=I={LUFS_I}:TP={LUFS_TP}:LRA={LUFS_LRA}"
        )
        mode_desc = (
            f"NR={nr_mode} (blend={nr_blend}) | model={arnndn_model} | "
            f"HPF={HPF}Hz, LPF={LPF}Hz, loudnorm I={LUFS_I} LRA={LUFS_LRA} TP={LUFS_TP}"
        )

    try:
        (
            ffmpeg.input(in_path)
            .output(
                str(out_path),
                ac=1,
                ar=16000,
                y=None,
                af=af_graph,
            )
            .global_args("-hide_banner")
            .run()
        )
        print(f"Preprocess: {mode_desc}")
    except ffmpeg.Error as e:
        # If arnndn fails (e.g., missing model), fall back to NR off pipeline
        if nr_mode != "off":
            print(
                "arnndn failed; falling back to NR=off. Error was:\n"
                + e.stderr.decode(errors="ignore")
            )
            af_graph_fallback = (
                f"highpass=f={HPF}, lowpass=f={LPF}, "
                f"loudnorm=I={LUFS_I}:TP={LUFS_TP}:LRA={LUFS_LRA}"
            )
            (
                ffmpeg.input(in_path)
                .output(
                    str(out_path),
                    ac=1,
                    ar=16000,
                    y=None,
                    af=af_graph_fallback,
                )
                .global_args("-hide_banner")
                .run()
            )
            print(
                f"Preprocess: NR=off fallback | HPF={HPF}Hz, LPF={LPF}Hz, loudnorm I={LUFS_I} LRA={LUFS_LRA} TP={LUFS_TP}"
            )
        else:
            raise

    print(f"Wrote temporary file {str(out_path)}")
    return str(out_path)


# >>> PREPROCESS with caching <<<
orig_audio = AUDIO
preproc_wav = work_dir / "preprocessed.wav"
if preproc_wav.exists() and not FORCE:
    print(f"Reusing preprocessed audio: {preproc_wav}")
else:
    AUDIO = _preprocess_audio(orig_audio, preproc_wav)
    print(f"Cached preprocessed audio → {preproc_wav}")
AUDIO = str(preproc_wav)

# ------- Devices -------
# CTranslate2 (faster-whisper) has no Metal/MPS on macOS, so ASR runs on CPU.
# Alignment & diarization can use MPS if available.
ASR_DEVICE = "cpu"
ALIGN_DEVICE = "mps" if torch.backends.mps.is_available() else "cpu"
DIA_DEVICE = "mps" if torch.backends.mps.is_available() else "cpu"

if torch.backends.mps.is_available():
    print("Using MPS for alignment/diarization; ASR via faster-whisper on CPU")
else:
    print("Running fully on CPU")

# Optional threading for CTranslate2 speed
os.environ.setdefault("CTRANSLATE2_NUM_THREADS", "18")

# ------- ASR (faster-whisper / CTranslate2) with caching -------
seg_json_path = work_dir / "whisper_segments.json"
lang_json_path = work_dir / "language.json"

if seg_json_path.exists() and not FORCE:
    print(f"Reusing Whisper segments: {seg_json_path}")
    data = _json_load(seg_json_path)
    segments_list = data["segments"]
    info_language = data.get("language")
else:
    asr = WhisperModel(
        "medium",  # model size: tiny/base/small/medium/large-v3
        device=ASR_DEVICE,  # CPU on macOS
        compute_type="int8",  # int8 is fast & accurate enough; try int8_float16 if you prefer
    )

    segments_iter, info = asr.transcribe(
        AUDIO,
        beam_size=1,
        best_of=1,
        temperature=0.0,
        vad_filter=True,
        language="en",
        word_timestamps=True,
    )

    segments_list = [
        {"start": s.start, "end": s.end, "text": s.text} for s in segments_iter
    ]
    if not segments_list:
        print("No speech detected.")
        sys.exit(2)
    info_language = getattr(info, "language", None) or "en"
    _json_dump({"segments": segments_list, "language": info_language}, seg_json_path)
    print(f"Cached Whisper segments → {seg_json_path}")

# ------- Alignment (word-level) via WhisperX with caching -------
align_json_path = work_dir / "aligned.json"
if align_json_path.exists() and not FORCE:
    print(f"Reusing alignment: {align_json_path}")
    result_aligned = _json_load(align_json_path)
else:
    lang = info_language or "en"
    align_model, metadata = whisperx.load_align_model(
        language_code=lang, device=ALIGN_DEVICE
    )
    audio_wav = whisperx.load_audio(AUDIO)
    try:
        result_aligned = whisperx.align(
            segments_list, align_model, metadata, audio_wav, ALIGN_DEVICE
        )
    except NotImplementedError:
        print(
            "Alignment on MPS hit unsupported op; falling back to CPU (PYTORCH_ENABLE_MPS_FALLBACK=1)."
        )
        ALIGN_DEVICE = "cpu"
        align_model, metadata = whisperx.load_align_model(
            language_code=lang, device=ALIGN_DEVICE
        )
        result_aligned = whisperx.align(
            segments_list, align_model, metadata, audio_wav, ALIGN_DEVICE
        )
    _json_dump(result_aligned, align_json_path)
    print(f"Cached alignment → {align_json_path}")

# ------- Diarization (speaker labels) with caching -------
rttm_path = work_dir / "diarization.rttm"
excl_json_path = work_dir / "exclusive_segments.json"

exclusive_segments = None
if rttm_path.exists() and excl_json_path.exists() and not FORCE:
    print(f"Reusing diarization: {rttm_path} and {excl_json_path}")
    exclusive_segments = _json_load(excl_json_path)
else:
    # Load preprocessed WAV in-memory to bypass torchcodec/ffmpeg
    wave, sr = sf.read(AUDIO, dtype="float32")  # AUDIO points to preprocessed.wav
    if wave.ndim > 1:
        wave = wave.mean(axis=1)  # ensure mono
    import numpy as _np  # local import in case numpy isn't top-level imported
    if not isinstance(wave, _np.ndarray):
        wave = _np.asarray(wave, dtype=_np.float32)
    wave_t = torch.from_numpy(wave).unsqueeze(0)  # (1, T)

    # v4-style: no token/use_auth_token kwarg; auth via HF CLI or HF_TOKEN env
    pipeline = cast(Pipeline, Pipeline.from_pretrained(
        'pyannote/speaker-diarization-community-1',
    ))
    dia_segments = pipeline(
        {"waveform": wave_t, "sample_rate": int(sr)},
        min_speakers=MIN_SPEAKERS,
        max_speakers=MAX_SPEAKERS,
    )

    # Save full diarization in RTTM
    with open(rttm_path, "w") as f:
        try:
            dia_segments.write_rttm(f)
        except Exception:
            # Some versions expose .charts or .to_rttm(); fall back to itertracks.
            for turn, _, speaker in dia_segments.itertracks(yield_label=True):
                start = float(turn.start)
                dur = float(turn.end - turn.start)
                f.write(f"SPEAKER session 1 {start:.3f} {dur:.3f} <NA> <NA> {speaker} <NA> <NA>\n")

    # Exclusive diarization → list of dicts
    if hasattr(dia_segments, "exclusive_speaker_diarization"):
        excl = dia_segments.exclusive_speaker_diarization
        print("Using exclusive speaker diarization from pipeline output.")
    else:
        excl = dia_segments

    exclusive_segments = []
    try:
        for seg, spk in excl.itertracks(yield_label=True):
            exclusive_segments.append(
                {"start": float(seg.start), "end": float(seg.end), "speaker": str(spk)}
            )
    except AttributeError:
        exclusive_segments = excl

    _json_dump(exclusive_segments, excl_json_path)
    print(f"Cached exclusive segments → {excl_json_path}")

# ------- Merge speakers into aligned transcript -------
# Use exclusive, non-overlapping speaker segments for cleaner script-style output
result_diarized = whisperx.assign_word_speakers(exclusive_segments, result_aligned)

result_diarized_path = work_dir / "result_diarized.json"
try:
    _json_dump(result_diarized, result_diarized_path)
    print(f"Cached diarized alignment → {result_diarized_path}")
except Exception:
    pass

# ------- Output -------
base_name = Path(orig_audio).stem
out_path = f"{base_name}_raw.txt" if RAW else f"{base_name}.txt"

# ------- Build script lines (Speaker: text) from WhisperX result -------
lines = []
cur_spk, cur_words = None, []

for seg in result_diarized.get("segments", []):
    words = seg.get("words") or []
    if words:
        for w in words:
            spk = w.get("speaker") or seg.get("speaker") or "UNKNOWN"
            word = (w.get("word") or "").strip()
            if not word:
                continue
            if spk != cur_spk and cur_words:
                lines.append((cur_spk, " ".join(cur_words)))
                cur_words = []
            cur_spk = spk
            cur_words.append(word)
    else:
        # Fallback to segment-level if no word timing present
        text = (seg.get("text") or "").strip()
        if not text:
            continue
        spk = seg.get("speaker") or "UNKNOWN"
        if spk != cur_spk and cur_words:
            lines.append((cur_spk, " ".join(cur_words)))
            cur_words = []
        cur_spk = spk
        cur_words.append(text)

if cur_words:
    lines.append((cur_spk, " ".join(cur_words)))

# ------- Write transcript (no timestamps) -------
with open(out_path, "w") as f:
    for spk, text in lines:
        if not text:
            continue
        f.write(f"{spk}: {text}\n")


print(f"Output mode: {'RAW' if RAW else 'CLEAN'} → wrote {out_path}")
