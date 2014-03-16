# cohsa aliases
alias c_jw='ruby ~/Libraries/cjsv/jsv.rb --input_dir application/views/cjsv/ --output_dir application/views/'
alias c_csw='coffee -wc -o js/ .'
alias cw='compass watch .'
alias cohsa='ruby ~/Libraries/cohsa/tools/tools.rb'

# git aliases
alias gc='git commit'
alias gcm='git commit -m'

alias ga='git add'
alias gd='git diff'
alias gl='git log'
alias gs='git status'
alias gx='git checkout'

alias gpom='git push origin master'
alias gpull='git pull origin master'
alias glf="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"

# general aliases
alias a='ack'
alias c='clear'
alias l='ls -la'
alias o='open'
alias pag='ps aux | grep'
alias ip="ifconfig | grep 192"
alias ff="find . | grep"

alias size='du -sh'
alias rb='. ~/.bash_profile'

# ssh aliases
alias ssh_evrm="ssh evrm_admin@ftp.wemoveapp.com"
alias ssh_i="ssh instrutec2@instrutec.com.br"

# libraries
alias gur='python ~/Work/everywhere/related/gur/git_update_remote.py' #git update remote
alias min_js='ruby ~/Libraries/js_minifier/js_minifier.rb'
alias fw='ruby ~/Libraries/frameworker/frameworker.rb'
alias sls='ruby ~/Libraries/php_logger/logger.rb' #start log server
alias sis='python artificial_intelligence_implementations/server.py' #start log server
alias sr2='ruby ~/Desktop/.ffrr.rb'
alias sr='ruby ~/Desktop/.ffrr-gst.rb'

# watchers
alias cw='compass watch .'
alias csw='coffee -wc -o js/ coffee/'
alias scsw='ruby ~/Libraries/csw.rb'
alias jw='ruby ~/Libraries/cjsv/jsv.rb .'
alias lw='ruby ~/Libraries/latex_watch/latex_watch.rb .'
alias ow='ruby ~/Work/everywhere/libraries/ohl.rb .'

# rails
alias rs='rails server'
alias rc='rails console'

#alias  '

#dw() {
#    terminator -m -b -l develop_web -T "Watching Coffee, CJSV and Compass" --working-directory $1 &
#}

# android export paths
export PATH=$PATH:~/Libraries/android-sdk/tools
export PATH=$PATH:~/Libraries/android-sdk/platform-tools
export JAVA_HOME=$(/usr/libexec/java_home)
export ANDROID_HOME=~/Libraries/android-sdk/
export PATH=$PATH:~/Library/Trigger\ Toolkit/

# php
export PATH=/usr/local/php5/bin:$PATH
alias php_c='php ~/Libraries/php_composer/composer.phar'

# android development
alias lcw='adb logcat | grep -E "Web Console|InAppBrowser|Cordova"'
alias adi='ant debug install'
alias cra="cordova run android -d"

alias release_we_move='cp WeMove-release-unsigned.apk WeMove-release-signed.apk && jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore ~/Keys/we_move.keystore WeMove-release-signed.apk we_move_key && zipalign -v 4 WeMove-release-signed.apk WeMove-release-signed-aligned.apk'

alias lcw_p='adb -s 900099e0ec47 logcat | grep -E "Web Console|InAppBrowser|Cordova"'

# common tasks
alias dev_index='rm index.html; ln -s dev.html index.html'
alias dep_index='rm index.html; ln -s dep.html index.html'

# node Webkit
export PATH=$PATH:~/Libraries/depot_tools/
alias cnw='zip -r app.nw * && nw app.nw'
alias mnw='zip -0 -r app.nw * && nw app.nw' #Node Webkit com zip sem compressão
alias dnw='zip -0 -r app.nw * && cp app.nw a.app/Contents/Ressources && o a.app'
alias nw="/Applications/node-webkit.app/Contents/MacOS/node-webkit"

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

##
# Your previous /Users/fedorius/.bash_profile file was backed up as /Users/fedorius/.bash_profile.macports-saved_2013-09-15_at_21:34:39
##

# MacPorts Installer addition on 2013-09-15_at_21:34:39: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

export PATH=$PATH:/usr/local/mysql/bin

envup() {
  if [ -f .env ]; then
    source .env
    while read var; do
      if [[ $var != PATH* ]]; then
        export $var
      fi
    done < .env
    return 0
  else
    echo 'No .env file found' 1>&2
    return 1
  fi
}

#export PATH=/Users/fedorius/.rvm/gems/ruby-2.1.0/bin:/Users/fedorius/.rvm/gems/ruby-2.1.0@global/bin:/Users/fedorius/.rvm/rubies/ruby-2.1.0/bin:/opt/local/bin:/opt/local/sbin:/usr/local/php5/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/git/bin:/usr/texbin:/Users/fedorius/Libraries/android-sdk/tools:/Users/fedorius/Libraries/android-sdk/platform-tools:/Users/fedorius/Library/Trigger Toolkit/:/Users/fedorius/Libraries/depot_tools/:/Users/fedorius/.rvm/bin:/usr/local/mysql/bin:/usr/local/mysql/bin

export CFLAGS=-Qunused-arguments
export CPPFLAGS=-Qunused-arguments
