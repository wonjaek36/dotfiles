#!/bin/bash
####### Functions #######
pyenv_checker () {
    if ! (command pyenv root 1> /dev/null 2>&1); then
    	echo "Cannot find pyenv root or pyenv command"
    	echo "Check pyenv installations"
    fi
}

get_latest_from_github() {
	# $1: user/repo
    # name_tag_suffix

	curl https://api.github.com/repos/$1/releases/latest |
		grep browser_download_url |
		grep -Po 'https://.*?'$2 | 
		xargs curl -L
}

get_latest_tag_from_github() {

    # $1: user/repo
    curl https://api.github.com/repos/$1/releases/latest |
        grep tag_name |
        grep -Po 'v[0-9]+\.[0-9]+\.[0-9]+'
}

check_git_exists() {

    # if git exists return 0, or not 0
    git --version 1>/dev/null 2>/dev/null
    echo $?
}
### End of Functions ###

export ZSH_COMPLETION_PATH=$HOME/.local/share/zsh/vendor-completions
export BASH_COMPLETION_PATH=$HOME/.local/share/bash/vendor-completions
export MAN_PATH=$HOME/.local/share/man/man1
if [ ! -d $ZSH_COMPLETION_PATH ]; then
    mkdir -p $ZSH_COMPLETION_PATH
fi
if [ ! -d $BASH_COMPLETION_PATH ]; then
    mkdir -p $BASH_COMPLETION_PATH
fi
if [ ! -d $MAN_PATH ]; then
    mkdir -p $MAN_PATH
fi

##### INSTALL PYENV ##### 
if ! ( command git --version > /dev/null ); then
	echo "Please install git first"
	exit 2
fi

echo "Install dependencies, if you have sudo previleges"
SUDO_VALID=$(sudo -v &> /dev/null)
SUDO_RET=$?

if [ $SUDO_RET = 0 ]; then
    if command apt --version 1> /dev/null 2>&1; then
        sudo apt install -y make build-essential libssl-dev zlib1g-dev \
            libbz2-dev libreadline-dev libsqlite3-dev wget curl \
            libncurses5-dev libncursesw5-dev xz-utils libffi-dev \
            liblzma-dev libevent-dev
        sudo apt install -y python-openssl llvm tk-dev
    fi
    if command yum --version 1> /dev/null 2>&1; then
        # ToDo Support Redhat dependencies
        echo "" 1> /dev/null
    fi
fi

if [ -d ~/.pyenv ]; then
	echo "$HOME/.pyenv directory exists"
	echo "May pyenv already installed"
	echo "If pyenv is not installed properly, retry after remove $HOME/.pyenv"
fi

if ! ( command pyenv --version 1> /dev/null 2>&1); then
	git clone https://github.com/pyenv/pyenv.git ~/.pyenv
	if ! ( command make --version > /dev/null 2>&1 ); then
		# ToDo Check sudo privilege
		sudo apt install make -y 
	fi

	cd ~/.pyenv && src/configure && make -C src
	if ! (grep -q PYENV_HOME "$HOME/.zshrc"); then
		echo "export PYENV_HOME=$HOME/.pyenv" >> $HOME/.zshrc
		echo "export PATH=\"$PYENV_HOME/bin:$PATH\"" >> $HOME/.zshrc
		echo 'eval "$(pyenv init -)"' >> $HOME/.zshrc
	fi
fi
# Install PYENV Complete

# Install pyenv-update plugin #
pyenv_checker
if [ -d $HOME/.pyenv/plugins/pyenv-update ]; then
	echo "pyenv-update plugins already exists"
else
    git clone https://github.com/pyenv/pyenv-update.git $HOME/.pyenv/plugins/pyenv-update
    pyenv update
    if [ $? != 0 ];
    then
    	echo "Pyenv update did not success"
    fi
fi

###############################

# Install pyenv-virtualenv #
pyenv_checker
if [ -d $HOME/.pyenv/plugins/pyenv-virtualenv ]; then
	echo "pyenv-virtualenv plugins already exists"
else
	git clone https://github.com/pyenv/pyenv-virtualenv.git $HOME/.pyenv/plugins/pyenv-virtualenv
	if ! (grep -q -E "^eval.*pyenv virtualenv-init -)\"$" "$HOME/.zshrc"); then
	    echo 'eval "$(pyenv virtualenv-init -)"' >> $HOME/.zshrc
	fi
	pyenv virtualenvs
	if [ $? != 0 ]; then
		echo 'Pyenv virtualenv did not success'
	fi
fi
##### END OF INSTALL PYENV #####


##### Install NVM #####
nvm --version &>/dev/null
NVM_CHECK=$(echo $?)
echo "----- Install NVM -----"
export NVM_DIR="$HOME/.nvm"
if [ -d $NVM_DIR ]; then
    echo "Previous installed nvm, removed"
    rm -rf "$HOME/.nvm"
fi

NVM_VERSION=$(get_latest_tag_from_github 'nvm-sh/nvm')
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh | bash
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # this loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # THIS LOADS NVM BASH_COMPLETION
nvm --version
nvm install --lts
npm install --prefix $HOME/.local -g yarn
##### END of INSTALL NVM #####

##### Install Neofetch ##### 
git --version &>/dev/null
GIT_CHECK=$(echo $?)
echo "----- Install Neofetch -----"
if [ $GIT_CHECK != 0 ]; then
    echo "git command not found, skip install neofetch"
else
    if [ -d $HOME/.neofetch ]; then
        echo "Previous installed neofetch, removed"
        rm -rf $HOME/.neofetch
    fi
    git clone https://github.com/dylanaraps/neofetch $HOME/.neofetch
    cd $HOME/.neofetch
    make PREFIX=$HOME/.local install
    cd $HOME
fi
##### End of Neofetch #####

##### Install Bat #####
BAT_VERSION=$(get_latest_tag_from_github 'sharkdp/bat')
git --version &>/dev/null
GIT_CHECK=$(echo $?)
echo "----- Install Bat -----"
if [ $GIT_CHECK != 0 ]; then
    echo "git command not found, skip install neofetch"
else
    if [ -d $HOME/.local/bats/bat-latest ]; then
        echo "Previous installed bat, removed"
        rm -rf $HOME/.local/bin/bat
        rm -rf $HOME/.local/bats/bat-latest
        rm -rf $HOME/.local/bats/bat-$BAT_VERSION*
    fi
    mkdir -p $HOME/.local/bats/
    curl -L -o "$HOME/.local/bats/bat-$BAT_VERSION.tar.gz" "https://github.com/sharkdp/bat/releases/download/$BAT_VERSION/bat-$BAT_VERSION-x86_64-unknown-linux-musl.tar.gz"
    cd $HOME/.local/bats
    tar -xvf bat-$BAT_VERSION.tar.gz
    echo $BAT_VERSION
    mv bat-$BAT_VERSION-x86_64-unknown-linux-musl bat-$BAT_VERSION
    ln -s $HOME/.local/bats/bat-$BAT_VERSION/bat $HOME/.local/bin/bat
    ln -s $HOME/.local/bats/bat-$BAT_VERSION $HOME/.local/bats/bat-latest
    cp $HOME/.local/bats/bat-latest/autocomplete/bat.zsh "$ZSH_COMPLETION_PATH/_bat"
    cp $HOME/.local/bats/bat-latest/autocomplete/bat.bash "$BASH_COMPLETION_PATH/bat"
    cp $HOME/.local/bats/bat-latest/bat.1 $MAN_PATH/bat.1
    cd $HOME
fi
##### End of Bat #####

##### Install fd #####'
echo "################## Install fd ##################"
get_latest_from_github 'sharkdp/fd' 'x86_64-unknown-linux-musl.tar.gz' | tar xz -C "$HOME/.local/bin" --strip 1
cp "$HOME/.local/bin/autocomplete/_fd" "$ZSH_COMPLETION_PATH/_fd"
cp "$HOME/.local/bin/autocomplete/fd.bash" "$BASH_COMPLETION_PATH/fd"
cp "$HOME/.local/bin/fd.1" "$MAN_PATH/fd.1"
##### End of fd ######'

##### Install ripgrep #####'
echo "################## Install ripgrep #################"
get_latest_from_github burntSushi/ripgrep linux-musl.tar.gz 2> /dev/null | tar xz -C "$HOME/.local/bin" --strip 1
cp "$HOME/.local/bin/complete/_rg" "$ZSH_COMPLETION_PATH/_rg"
cp "$HOME/.local/bin/complete/rg.bash" "$BASH_COMPLETION_PATH/rg"
cp "$HOME/.local/bin/doc/rg.1" "$MAN_PATH/rg.1"
echo "### End ripgrep ###"


### Install fzf #####
# GIT_CHECK=$(check_git_exists)
# if [ $GIT_CHECK -ne 0 ]; then
#     echo "git command not found, skip install fzf"
# else
#     if [ -d $HOME/.local/.fzf ]; then
#         echo "Previous installed fzf, removed"
#         rm -rf $HOME/.local/.fzf
#     fi
# 
#     git clone https://github.com/junegunn/fzf.git $HOME/.local/.fzf
#     cd $HOME/.local/.fzf
#     printf 'y\ny\ny\n' | $HOME/.local/.fzf/install 
# fi
## End of fzf #####

echo '###### Install fd #####'
get_latest_from_github sharkdp/fd x86_64-unknown-linux-musl.tar.gz 2> /dev/null | tar xz -C "$HOME/.local/bin" --strip 1
mv $HOME/.local/bin/autocomplete/_fd $ZSH_COMPLETION_PATH/_fd
mv $HOME/.local/bin/autocomplete/fd.bash $BASH_COMPLETION_PATH/fd
mv $HOME/.local/bin/fd.1 $MAN_PATH/fd.1


echo '##### Install tmux #####'
mkdir -p $HOME/.local/.tmux/tmux-latest
get_latest_from_github tmux/tmux .tar.gz 2>/dev/null | tar -xz -C "$HOME/.local/.tmux/tmux-latest" --strip 1
cd $HOME/.local/.tmux/tmux-latest
./configure --prefix=$HOME/.local/
make -j 4
make install
mkdir -p $HOME/.tmux/plugins
rm -rf $HOME/.tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
