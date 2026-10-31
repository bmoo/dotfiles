# Interactive zsh. ~/.zshrc links here (see install.conf.yaml).
# Secrets live in ~/.zshenv.local; per-machine tweaks in ~/.zshrc.local.
# Neither file is tracked.

# This repo's location, found by resolving the ~/.zshrc symlink.
DOTFILES=${${(%):-%x}:A:h}

command -v brew >/dev/null && eval "$(brew shellenv)"

autoload -Uz compinit && compinit -i

# Load every module except the untracked secret files. secrets.zsh exports
# ANTHROPIC_API_KEY, which would switch Claude Code to pay-per-token billing.
for _f in $DOTFILES/zsh.after/*.zsh(N); do
  case ${_f:t} in
    secrets.zsh|tokens.zsh|gh.zsh) continue ;;
  esac
  source $_f
done
unset _f

[[ -r ~/.zshrc.local ]] && source ~/.zshrc.local

typeset -U path

# Prompt (keep last)
command -v starship >/dev/null && eval "$(starship init zsh)"
