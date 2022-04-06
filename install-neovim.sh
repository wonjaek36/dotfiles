if ( command neovim --version 1> /dev/null 2> /dev/null ); then
    echo "Neovim already installed"
    exit 1
fi

DEPENDENCIES_NEEDED=false

if ! ( command make --version 1> /dev/null 2>&1 ); then
    echo "Need to install make"
    DEPENDENCIES_NEEDED=true
fi
if ! ( command cmake --version > /dev/null 2>&1 ); then
    echo "Need to install cmake"
    DEPENDENCIES_NEEDED=true
fi
if ! ( command libtool --version > /dev/null 2>&1 ); then
    echo "Need to install libtool"
    DEPENDENCIES_NEEDED=true
fi
if ! ( command git --version > /dev/null 2>&1 ); then
    echo "Need to install git"
    DEPENDENCIES_NEEDED=true
fi 

if [ "$DEPENDENCIES_NEEDED" = true ]; then
    
    SUDO_PREVILEGES=$(sudo -nv 2>&1)
    if [ $? -eq 0 ]; then
        echo "Have sudo previlege"
    elif echo $SUDO_PREVILEGES | grep -q '^sudo:'; then
        echo "Have sudo, but password needed"
        sudo -v 
    else
        exit 2
    fi
    
    if ( command apt --version 1> /dev/null 2>&1 ); then
        sudo apt install libtool automake cmake pkg-config gettext -y
    elif ( command yum --version 1> /dev/null 2>&1 ); then
        sudo yum install libtool automake cmake pkg-config gettext -y
    else
        echo "Unsupported Operating System"
    fi
fi
if ! ( command git --version > /dev/null ); then
	echo "Please install git first"
	exit 3
fi

if [ ! -z ${INSTALL_PATH} ]; then
    echo "INSTALL PATH: $INSTALL_PATH"
else
    echo "No set INSTALL PATH"
    exit 4
fi

# Newest version at 22/04/06 
mkdir -p $INSTALL_PATH
git clone -b v0.6.1 https://github.com/neovim/neovim.git $INSTALL_PATH/neovim
cd $INSTALL_PATH/neovim
make distclean && LDFLAGS=-static
make CMAKE_INSTALL_PREFIX=$INSTALL_PATH
make install
