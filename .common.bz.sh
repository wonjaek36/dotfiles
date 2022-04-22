
if [ -e "$HOME/.common.sh" ]; then
    source $HOME/.common.sh
fi

export ZSH_COMPLETION_PATH=$HOME/.local/share/zsh/vendor-completions
export BASH_COMPLETION_PATH=$HOME/.local/share/bash/vendor-completions
if [ ! -d $ZSH_COMPLETION_PATH ]; then
    mkdir -p $ZSH_COMPLETION_PATH
fi
if [ ! -d $BASH_COMPLETION_PATH ]; then
    mkdir -p $BASH_COMPLETION_PATH
fi

if [[ ! $fpath =~ $ZSH_COMPLETION_PATH ]]; then
    fpath=($ZSH_COMPLETION_PATH $fpath)
fi
if [[ ! $FPATH =~ $BASH_COMPLETION_PATH ]]; then
    FPATH="$BASH_COMPLETION_PATH:$FPATH"
fi

### PYENV ###
export PYENV_HOME="$HOME/.pyenv"
export PATH="$PYENV_HOME/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"
### END OF PYENV ###


