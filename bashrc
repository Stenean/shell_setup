#
# ~/.bashrc
#

[[ $- != *i* ]] && return

colors() {
	local fgc bgc vals seq0

	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

	# foreground colors
	for fgc in {30..37}; do
		# background colors
		for bgc in {40..47}; do
			fgc=${fgc#37} # white
			bgc=${bgc#40} # black

			vals="${fgc:+$fgc;}${bgc}"
			vals=${vals%%;}

			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo; echo
	done
}

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion
[ -r /usr/local/etc/profile.d/bash_completion.sh ] && . /usr/local/etc/profile.d/bash_completion.sh

# making Mac more like linux
[ -r /usr/local/opt/coreutils/libexec/gnubin ] && PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

# Change the window title of X terminals
case ${TERM} in
	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
		;;
	screen*)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
		;;
esac

use_color=true

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
	&& type -P dircolors >/dev/null \
	&& match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	if type -P dircolors >/dev/null ; then
		if [[ -f ~/.dir_colors ]] ; then
			eval $(dircolors -b ~/.dir_colors)
		elif [[ -f /etc/DIR_COLORS ]] ; then
			eval $(dircolors -b /etc/DIR_COLORS)
		fi
	fi

	if [[ ${EUID} == 0 ]] ; then
		PS1='\[\033[01;31m\][\h\[\033[01;36m\] \W\[\033[01;31m\]]\$\[\033[00m\] '
	else
		PS1='\[\033[01;32m\][\u@\h\[\033[01;37m\] \W\[\033[01;32m\]]\$\[\033[00m\] '
	fi

	alias ls='ls --color=auto'
	alias grep='grep --colour=auto'
	alias egrep='egrep --colour=auto'
	alias fgrep='fgrep --colour=auto'
else
	if [[ ${EUID} == 0 ]] ; then
		# show root@ when we don't have colors
		PS1='\u@\h \W \$ '
	else
		PS1='\u@\h \w \$ '
	fi
fi

unset use_color safe_term match_lhs sh

alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias np='nano -w PKGBUILD'
alias more=less

xhost +local:root > /dev/null 2>&1

complete -cf sudo

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

shopt -s expand_aliases

# export QT_SELECT=4

# Enable history appending instead of overwriting.  #139609
shopt -s histappend

#
# # ex - archive extractor
# # usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# better yaourt colors
export YAOURT_COLORS="nb=1:pkg=1:ver=1;32:lver=1;45:installed=1;42:grp=1;34:od=1;41;5:votes=1;44:dsc=0:other=1;35"

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

PATH="/opt/vim/bin:$HOME/bin:/usr/local/bin:$PATH:/usr/sbin:/sbin:/usr/bin:/bin:/usr/local/games:/usr/games"

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

export GPG_TTY=$(tty)
# Make the ssh agent the gpg-agent process
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket);

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
# >>> BEGIN ADDED BY CNCHI INSTALLER
export BROWSER=/usr/local/bin/chromium
export EDITOR=/usr/local/bin/vim
if [ "$(uname -s)" != "Darwin" ]; then
    export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python2
    export BROWSER=/usr/bin/chromium
    export EDITOR=/usr/bin/vim
fi
# <<< END ADDED BY CNCHI INSTALLER

if [ -s "$HOME/.gvm/scripts/gvm" ]; then
    source "$HOME/.gvm/scripts/gvm"
fi

export PROJECT_HOME="$HOME/Projects"
export WORKON_HOME="$HOME/.virtualenvs"
export PAGER="less -FRX"

DEFAULT_USER="kuba"

if [ -n "$(command -v xmodmap)" ]; then
    xmodmap -e "keycode 166=Prior"
    xmodmap -e "keycode 167=Next"
fi

function whatsmyip() {
# {{{
    dig +short myip.opendns.com @resolver1.opendns.com
# }}}
}

function find_and_activate_virtualenv() {
# {{{
    if [ -n "$(env | grep -E '^VIRTUAL_ENV')" ]; then
        return;
    fi

    venvs=$(grep "$HOME" ~/.virtualenvs/*/.project | sed -e 's/\/.project//g' -e 's/\(.*\):\(.*\)/\2:\1/g')
    for venv in $venvs; do
        if [[ $PWD/ = $(echo $venv | sed -e 's/:.*//g')/* ]]; then
            curr_pwd=$PWD
            workon $(echo $venv | sed -e 's/.*://g' -e 's/.*\/\(.*\)$/\1/g')
            cd $curr_pwd
            return
        fi
    done
# }}}
}

function to_git_branch {
# {{{
    echo "$1\n" | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/ /g' -e 's/[^a-zA-Z0-9 ]//g' -e 's/\s\+/_/g' -e 's/_\+$//g' -e 's/\(.*\)/\L\1/g'
# }}}
}

function preexec() {
# {{{
    timer=${timer:-$SECONDS}
}
# }}}

function precmd() {
# {{{
    if [ $timer ]; then
        export timer_show=$(($SECONDS - $timer))
        unset timer
    fi
}
# }}}

# Python and pyenv setup {{{
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1

if [ -e "$(which powerline-daemon)" ]; then
    powerline-daemon -q
fi

if [ -f "/usr/lib/python3.8/site-packages/powerline/bindings/bash/powerline.sh" ]; then
    . /usr/lib/python3.8/site-packages/powerline/bindings/bash/powerline.sh
elif [ -f "/usr/lib/python3.7/site-packages/powerline/bindings/bash/powerline.sh" ]; then
    . /usr/lib/python3.7/site-packages/powerline/bindings/bash/powerline.sh
elif [ -f "/usr/local/lib/python3.7/site-packages/powerline/bindings/bash/powerline.sh" ]; then
    . /usr/local/lib/python3.7/site-packages/powerline/bindings/bash/powerline.sh
elif [ -f "/usr/local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh" ]; then
    . /usr/local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh
elif [ -f "/usr/local/lib/python2.7/dist-packages/powerline/bindings/bash/powerline.sh" ]; then
    . /usr/local/lib/python2.7/dist-packages/powerline/bindings/bash/powerline.sh
elif [ -f "/usr/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh" ]; then
    . /usr/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh
fi

export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# Lazy load pyenv
if type pyenv &> /dev/null; then
    function pyenv() {
        unset -f pyenv > /dev/null 2>&1
        eval "$(command pyenv init -)"
        pyenv "$@"
    }
fi
# eval "$(pyenv init -")

# Lazy load pyenv-virtualenv
if type pyenv-virtualenv &> /dev/null; then
    function pyenv-virtualenv() {
        unset -f pyenv-virtualenv > /dev/null 2>&1
        eval "$(command pyenv virtualenv-init -)"
        pyenv-virtualenv "$@"
    }
fi
# eval "$(pyenv virtualenv-init -)"
# pyenv virtualenvwrapper


[[ -s "/etc/grc.bashrc"  ]] && source /etc/grc.bashrc
[[ -s "/etc/profile.d/grc.bashrc" ]] && source /etc/profile.d/grc.bashrc

# }}}

source $HOME/.config/broot/launcher/bash/br

[[ -s "$HOME/.profile" ]] && source $HOME/.profile
