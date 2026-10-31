export BUN_INSTALL="$HOME/.bun"
[[ -d $BUN_INSTALL/bin ]] && path=($BUN_INSTALL/bin $path)
[[ -s $BUN_INSTALL/_bun ]] && source $BUN_INSTALL/_bun
