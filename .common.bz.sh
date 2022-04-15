
if [ -e "$HOME/.common.sh" ]; then
    source $HOME/.common.sh
fi

### PYENV ###
export PYENV_HOME="$HOME/.pyenv"
export PATH="$PYENV_HOME/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"
### END OF PYENV ###
