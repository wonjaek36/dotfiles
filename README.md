# ubuntu-configuration

My ubuntu application list and those configuration files
* Environment: Ubuntu 19.04(Disco Dingo) or 19.10(Eoan Ermine)

## Mail Client
### Mailspring
([Link](https://www.getmailspring.com))

### Mutt
([Link](http://www.mutt.org))

## Web browser
### Whale
Naver web browser based on Chromium([Link](https://whale.naver.com/ko))  
  
**Installation**  
Download naver-whale-stable_amd64.deb from [Whale Official Site](https://whale.naver.com/ko)
```
dpkg -i naver-whale-stable_amd64.deb
```

### Chromium
Open-source web browser([Link](https://www.chromium.org))
  
**Installation**  
```
apt install chromium-browser
```

## Shell
### Zshell
Extended shell from bash(Bourne shell)  

**Installation**
```
apt install zsh
apt install powerline fonts-powerline # Support zshell fonts
```

### oh-my-zshell
Zshell framework to manage zshell configure effectively.
(oh-my-zshell official site)[https://ohmyz.sh/], (oh-my-zshell github)[https://github.com/ohmyzsh/ohmyzsh#getting-started]
  
**Installation**
```bash
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Zshell configuration
In ~/.zshrc
```
ZSH_THEME="agnoster" #Recommend install solarized theme
plugins=(git rails ruby capistrano bundler heroku rake rvm autojump command-not-found python pip github gnu-utils history-substring-search zsh-syntax-highlighting)

### Solarized
Color scheme created by Ethan Schoonover. Detail in [Wiki](https://en.wikipedia.org/wiki/Solarized_(color_scheme))
[Zshell agnoster theme solarized instruction](https://gist.github.com/renshuki/3cf3de6e7f00fa7e744a)

```
apt install dconf-cli
git clone git://github.com/sigurdga/gnome-terminal-colors-solarized.git ~/.solarized
cd ~./solarized
./install.sh
```

Pick option1 twice(Dark Theme, seebi dircolors-solarized).
eval `dircolors ~/.dir_colors/dircolors`

  * fcitx

  * Notion(Lotion)([Link](https://github.com/puneetsl/lotion))
    * Unofficial Linux app for Notion.so
    * Installation
      * Clone github repository(https://github.com/puneetsl/lotion)
      * cd ./lotion
      * ./install.sh
