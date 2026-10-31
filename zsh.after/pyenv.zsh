export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && path=($PYENV_ROOT/bin $path)
command -v pyenv >/dev/null && eval "$(pyenv init -)"
