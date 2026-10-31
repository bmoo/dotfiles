# Every zsh, including non-interactive ones (ssh commands, MCP servers,
# scripts). Keep it fast and quiet. ~/.zshenv links here.

# Homebrew on PATH even when .zshrc isn't read, so `ssh host mosh-server`
# and similar find their tools. Apple silicon first, then Intel.
for _brew in /opt/homebrew /usr/local; do
  if [[ -x $_brew/bin/brew ]]; then
    path=($_brew/bin $_brew/sbin $path)
    break
  fi
done
unset _brew

# Secrets and machine-only settings. Never tracked.
[[ -r ~/.zshenv.local ]] && source ~/.zshenv.local
