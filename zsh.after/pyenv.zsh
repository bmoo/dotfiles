# Setup virtualenv home


export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# Load pyenv into the shell by adding
# the following to ~/.zshrc:

# Set the pyenv shims to initialize
if command -v pyenv 1>/dev/null 2>&1; then
 eval "$(pyenv init -)"
fi

export WORKON_HOME=$HOME/.virtualenvs
pyenv virtualenvwrapper

# Tell pyenv-virtualenvwrapper to use pyenv when creating new Python environments
export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"

