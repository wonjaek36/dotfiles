
if [ -e "$HOME/.common.sh" ]; then
    source $HOME/.common.sh
fi

ZSH_COMPLETION_PATH=$HOME/.local/share/zsh/vendor-completions
BASH_COMPLETION_PATH=$HOME/.local/share/bash/vendor-completions
mkdir -p $ZSH_COMPLETION_PATH
mkdir -p $BASH_COMPLETION_PATH

if [[ ! $fpath =~ $ZSH_COMPLETION_PATH ]]; then
    fpath=($ZSH_COMPLETION_PATH $fpath)
fi
if [[ ! $fpath =~ $BASH_COMPLETION_PATH ]]; then
    fpath=($BASH_COMPLETION_PATH $fpath)
fi

### PYENV ###
export PYENV_HOME="$HOME/.pyenv"
export PATH="$PYENV_HOME/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"
### END OF PYENV ###


