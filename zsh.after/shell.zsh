# Codex and its skill loader can need more than macOS's default 256 file descriptors.
ulimit -n 65536 2>/dev/null
