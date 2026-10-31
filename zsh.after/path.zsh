path=($HOME/bin $HOME/.local/bin $HOME/go/bin $path)

# rootshell-herdr, only on machines that have it
[[ -d $HOME/.local/opt/herdr-rootshell/bin ]] && path=($HOME/.local/opt/herdr-rootshell/bin $path)
