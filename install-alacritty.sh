if ! [ -z INSTALL_PATH ]; then
	INSTALL_PATH="$HOME/.local"
fi

get_latest_from_github() {
	# $1: user/repo
    # name_tag_suffix

	curl https://api.github.com/repos/$1/releases/latest |
		grep browser_download_url |
		grep -Po 'https://.*?'$2 | 
		xargs curl -L
}

mkdir -p $HOME/.alacritty
curl https://github.com/alacritty/alacritty/archive/refs/tags/v0.10.1.tar.gz-Lo $HOME/.alacritty/alacritty-v0.10.1.tar.gz
tar -xvf $HOME/.alacritty/alacritty-v0.10.1.tar.gz
cd $HOME/.alacritty/alacritty-0.10.1
./configure --prefix=$HOME/.local
make -j 4
make install
  
