####### Functions #######
pyenv_checker () {
    if ! (command pyenv root 1> /dev/null 2>&1); then
    	echo "Cannot find pyenv root or pyenv command"
    	echo "Check pyenv installations"
	    exit 4
    fi
}
### End of Functions ###

if ! ( command git --version > /dev/null ); then
	echo "Please install git first"
	exit 2
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
if [ -d $(pyenv root)/plugins/pyenv-update ]; then
	echo "pyenv-update plugins already exists"
else
    git clone https://github.com/pyenv/pyenv-update.git $(pyenv root)/plugins/pyenv-update
    pyenv update
    if [ $? != 0 ];
    then
    	echo "Pyenv update did not success"
    fi
fi

###############################

# Install pyenv-virtualenv #
pyenv_checker
if [ -d $(pyenv root)/plugins/pyenv-virtualenv ]; then
	echo "pyenv-virtualenv plugins already exists"
else
	git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv
	if ! (grep -q -E "^eval.*pyenv virtualenv-init -)\"$" "$HOME/.zshrc"); then
	    echo 'eval "$(pyenv virtualenv-init -)"' >> $HOME/.zshrc
	fi
	pyenv virtualenvs
	if [ $? != 0 ]; then
		echo 'Pyenv virtualenv did not success'
	fi
fi
