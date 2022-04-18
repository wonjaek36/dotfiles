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
    GIT_CHECK=$(echo $?)
    return $GIT_CHECK
}
### End of Functions ###

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
            libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
            libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev \
            liblzma-dev python-openssl 
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
if [ -d $HOME/.pyenv/pyenv-virtualenv ]; then
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
    curl -L -o "$HOME/.local/bats/bat-$BAT_VERSION.tar.gz" "https://github.com/sharkdp/bat/releases/download/$BAT_VERSION/bat-$BAT_VERSION-x86_64-unknown-linux-gnu.tar.gz"
    cd $HOME/.local/bats
    tar -xvf bat-$BAT_VERSION.tar.gz
    echo $BAT_VERSION
    mv bat-$BAT_VERSION-x86_64-unknown-linux-gnu bat-$BAT_VERSION
    ln -s $HOME/.local/bats/bat-$BAT_VERSION/bat $HOME/.local/bin/bat
    ln -s $HOME/.local/bats/bat-$BAT_VERSION $HOME/.local/bats/bat-latest
    cd $HOME
fi
##### End of Bat #####

### Install fzf #####
GIT_CHECK=$(check_git_exists)
if [ $GIT_CHECK != 0 ]; then
    echo "git command not found, skip install fzf"
else
    if [ -d $HOME/.local/.fzf ]; then
        echo "Previous installed fzf, removed"
        rm -rf $HOME/.local/.fzf
    fi

    git clone https://github.com/junegunn/fzf.git $HOME/.local/.fzf
    cd $HOME/.local/.fzf
    printf 'y\ny\ny\n' | $HOME/.local/.fzf/install 
fi
## End of fzf #####
