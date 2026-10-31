export NVM_DIR="$HOME/.nvm"

# HOMEBREW_PREFIX comes from `brew shellenv` (Apple silicon or Intel).
if [[ -n $HOMEBREW_PREFIX && -s $HOMEBREW_PREFIX/opt/nvm/nvm.sh ]]; then
  setopt no_aliases
  source $HOMEBREW_PREFIX/opt/nvm/nvm.sh
  setopt aliases
fi
