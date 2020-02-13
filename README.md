# ubuntu-configuration

My ubuntu application list and those configuration files.(Updated 2020-02-13)
* Environment: Ubuntu 19.04(Disco Dingo) or 19.10(Eoan Ermine)

&nbsp;
## Mail Client
### Mailspring
([Link](https://www.getmailspring.com))

### Mutt
([Link](http://www.mutt.org))

&nbsp;
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

&nbsp;
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
[oh-my-zshell official site](https://ohmyz.sh), [oh-my-zshell github](https://github.com/ohmyzsh/ohmyzsh#getting-started)  

**Installation**
```bash
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Zshell configuration
In ~/.zshrc
```
ZSH_THEME="agnoster" #Recommend install solarized theme
plugins=(git rails ruby capistrano bundler
    heroku rake rvm autojump command-not-found
    python pip github gnu-utils history-substring-search
    zsh-syntax-highlighting)
```
My full zshrc is [Link](https://github.com/wonjaek36/ubuntu-configuration/blob/master/zshrc)

### Solarized
Color scheme created by Ethan Schoonover. Detail in [Wiki](https://en.wikipedia.org/wiki/Solarized_(color_scheme)).  
[Zshell agnoster theme solarized instruction](https://gist.github.com/renshuki/3cf3de6e7f00fa7e744a)  

```
apt install dconf-cli
git clone git://github.com/sigurdga/gnome-terminal-colors-solarized.git ~/.solarized
cd ~./solarized
./install.sh
```

pick option1 twice(dark theme, seebi dircolors-solarized).  
Finally, add the line to $HOME/.zshrc 
```
eval `dircolors ~/.dir_colors/dircolors`
```
&nbsp;

## Language
### Java

### Ruby
Download [official ruby](https://www.ruby-lang.org/en/downloads/)
I've downloaded Ruby 2.7.0.
Assume nodejs is already installed
```
apt install git curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev

# install rbenv
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc # or bashrc
echo 'eval "$(rbenv init -)"' >> ~/.zshrc
source ~/.zshrc

# install new ruby version
rbenv install 2.6.5
rbenv global # show list of versions
rbenv global 2.6.5
rbenv rehash
```


### Python
Download [official python](https://www.python.org/).
I've downloaded Python 3.6.10.

```
tar -xvf Python-3.6.10
./configure
make
make install
```

&nbsp;
## Text Editor
### Emacs

### Vim

### Atom

&nbsp;
## Project Managment Tools
### Maven

### Gradle


&nbsp;
## Integrated Development Environment
### IntelliJ

### Eclipse


&nbsp;
## Communication Tools
### Notion
Unofficial Linux app for Notion.so.

**Installation**
```
git clone https://github.com/puneetsl/lotion
cd .lotion
./install.sh
```

&nbsp;
## Input Method
### fcitx