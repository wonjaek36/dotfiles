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


get_latest_from_github 'neovim/neovim' 'nvim-linux64.tar.gz' 2>/dev/null | tar xz -C "$INSTALL_PATH" --strip 1

# Install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 2>/dev/null
