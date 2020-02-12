# ubuntu-configuration

My ubuntu application list and those configuration files

* Environment: Ubuntu 19.04(Disco Dingo) or 19.10(Eoan Ermine)
* Applications
  * Mail
    * **Mailspring**([Link](https://www.getmailspring.com))
    * **Mutt**([Link](http://www.mutt.org))
  * Web browser
    * **whale**([Link](https://whale.naver.com/ko))
      * Naver web browser based on Chrome
      * Installation
      	* Download naver-whale-stable_amd64.deb from naver whale site
      	* dpkg -i naver-whale-stable_amd64.deb
    * **chromium**([Link](https://www.chromium.org))
      * Open-source version of Chrome
      * Installation
      	* apt install chromium-browser
  * **Zshell**
    * Installation
      * apt install zsh
      * apt install powerline fonts-powerline

    * **oh-my-Zshell**([Link](https://github.com/ohmyzsh/ohmyzsh#getting-started))
      * A framework for managing zsh configuration
      * Installation
        * sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
      * .zshrc
        * Plugins=()
        * Themes: agnoster
        * Solarized([Link](https://gist.github.com/renshuki/3cf3de6e7f00fa7e744a))
          * ```bash
          apt install dconf-cli
          git clone git://github.com/sigurdga/gnome-terminal-colors-solarized.git ~/.solarized
          cd ~./solarized
          ./install.sh
          ```
          * Pick option1 twice(Dark Theme, seebi dircolors-solarized).
          * eval `dircolors ~/.dir_colors/dircolors`

    * oh-my-zshell
  * fcitx

  * Notion(Lotion)([Link](https://github.com/puneetsl/lotion))
    * Unofficial Linux app for Notion.so
    * Installation
      * Clone github repository(https://github.com/puneetsl/lotion)
      * cd ./lotion
      * ./install.sh
