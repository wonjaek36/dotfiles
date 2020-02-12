# ubuntu-configuration

My ubuntu application list and those configuration files

* Environment: Ubuntu 19.04(Disco Dingo) or 19.10(Eoan Ermine)
* Applications

  * Mail
    * **Mailspring**([Link](https://www.getmailspring.com))
    * **Mutt**([Link](http://www.mutt.org))

  * Web browser
    * **Whale**([Link](https://whale.naver.com/ko))
      * Naver web browser based on Chrome
      * Installation
      	* Download naver-whale-stable_amd64.deb from naver whale site
      	* ```shell
	$ dpkg -i naver-whale-stable_amd64.deb
	```
    * **Chromium**([Link](https://www.chromium.org))
      * Open-source version of Chrome
      * Installation
      	```bash
	apt install chromium-browser
	```

  * Shell
    * **zshell**
      * ```bash
	apt install zsh
     	apt install powerline fonts-powerline # Support zshell fonts
	```
      
    * **oh-my-zshell**([Link](https://github.com/ohmyzsh/ohmyzsh#getting-started))
      * A framework for managing zsh configuration
      * Installation
        * ```bash
	  sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	  ```
      * .zshrc
        * plugins=(git rails ruby capistrano bundler heroku rake rvm autojump command-not-found python pip github gnu-utils history-substring-search zsh-syntax-highlighting)
        * themes: agnoster
        * solarized([Link](https://gist.github.com/renshuki/3cf3de6e7f00fa7e744a))
          *
	  ```bash
          apt install dconf-cli
          git clone git://github.com/sigurdga/gnome-terminal-colors-solarized.git ~/.solarized
          cd ~./solarized
          ./install.sh
          ```
          * Pick option1 twice(Dark Theme, seebi dircolors-solarized).
          * eval `dircolors ~/.dir_colors/dircolors`

  * fcitx

  * Notion(Lotion)([Link](https://github.com/puneetsl/lotion))
    * Unofficial Linux app for Notion.so
    * Installation
      * Clone github repository(https://github.com/puneetsl/lotion)
      * cd ./lotion
      * ./install.sh
