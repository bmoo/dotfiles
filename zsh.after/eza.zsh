command -v eza >/dev/null || return

# Tree listing via eza (from simonbs/dotfiles)
alias lt='eza --tree --icons'
alias lt2='lt --level=2'

# ls runs eza; -t (sort by time) is translated since eza's -t means --time
ls() {
  # Real ls when piped or without a terminal: eza reads names from a non-tty stdin
  if [[ ! -t 0 || ! -t 1 ]]; then command ls "$@"; return; fi
  local a args=() sort=0 rev=0
  for a in "$@"; do
    if [[ $a == -[^-]* && $a == *t* ]]; then
      sort=1; a=${a//t/}
      if [[ $a == *r* ]]; then rev=1; a=${a//r/}; fi
      [[ $a == - ]] || args+=("$a")
    else
      args+=("$a")
    fi
  done
  # ls -t is newest first; eza's modified sort is oldest first
  if (( sort && ! rev )); then args+=(--sort=modified --reverse)
  elif (( sort )); then args+=(--sort=modified)
  fi
  eza --icons "${args[@]}"
}
