# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

#------------User specific aliases and functions-------------
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

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

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lockscreen='dbus-send --type=method_call --dest=org.gnome.ScreenSaver /org/gnome/ScreenSaver org.gnome.ScreenSaver.Lock'

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth
# history list shows timestamp
HISTTIMEFORMAT='%F %T '
# because each timestamp takes a separate line in $HISTFILE,
# to make history list and history file contain the same lines
# of history, $HISTFILESIZE should double $HISTSIZE
HISTSIZE=8192
HISTFILESIZE=16384

# append to the history file, don't overwrite it.
# this is for safety concerns. If multiple bash were killed
# simultaneously and each overwrite the $HISTFILE, race
# condition may result in $HISTFILE truncated to zero.
shopt -s histappend
# do not clear input when history substitution failed to match.
# because a failed substitution input does not count as a failed command,
# Ctrl-P doesn't work.
shopt -s histreedit
# concatenate multiline command into one line in history, to ease re-editting
shopt -s cmdhist

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
# check if the remembered command path exists before executing it
shopt -s checkhash
# print background job status (if any) alongside the "There are stopped jobs" line
shopt -s checkjobs
# unset `force_fignore`, we don't want to ignore any files.
# we are managing a filesystem, not some source code repo.
shopt -u force_fignore
# to avoid surprising comparison result caused by unexpected locale collating order,
# we ignore locale's collating sequence definition in range expression
shopt -s globasciiranges
# set LC_COLLATE=C to collate in strict numeric order
export LC_COLLATE=C
# completing hostname on tab completion
shopt -s hostcomplete
# `#` char acts as comment char, as usual (set by default)
shopt -s interactive_comments
# do not tab-complete on an empty line
shopt -s no_empty_cmd_completion
# exit status of pipeline should reflect the failing commands
set -o pipefail
# default editor and viewer
export EDITOR=vim
export VIEWER=vim

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# `\e]2;-----\a part is for title bar
# \[-----\] part does not occupy screen space
# \e[---m part is color code
# add git repo status to ps1
source ~/git-prompt.sh
__jobnums() {
    declare jobnums=$(jobs -p | wc -l)
    [[ $jobnums -gt 0 ]] && echo -n "$jobnums:"
}

# put cwd in PS1 if we are in terminal,
# otherwise put cwd atop pseudo-terminal window
if [[ $(tty) == *pts* ]]; then
    # terminal header line: host@$PWD
    # prompt: user:n:(branch)$
    PS1='\[\e]2;\h@\w\a\e[33;1m\]\u:$(__jobnums)\[\e[30;1m\]$(__git_ps1 "(%s)")\[\e[33;1m\]$ \[\e[0m\]'
else
    # keep only the last two components of pathname
    PROMPT_DIRTRIM=2
    # user@host:$PWD:n:(branch)$
    PS1='\[\e[33;1m\]\u@\h:\w:$(__jobnums)\[\e[30;1m\]$(__git_ps1 "(%s)")\[\e[33;1m\]$ \[\e[0m\]'
fi

# more delicate info in debug prompt
PS4='${BASH_SOURCE[0]}@${LINENO}(${FUNCNAME[0]}): '
# for profiling, you may use the following
#PS4='+ $(date "+%s.%N") ${BASH_SOURCE}@${LINENO}: '

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar
# set extended glob (pattern matching)
shopt -s extglob
# expand variables in paths when performing tab completion
shopt -s direxpand
# auto-correct minor spelling errors on filepath tab completion
shopt -s dirspell

# to enable forward search command with Ctrl-s
stty -ixon

# my bin
[[ ":${PATH}:" == *:$HOME/bin:* ]] || PATH="$HOME/bin${PATH:+:$PATH}"
# pyenv bin
declare -x PYENV_ROOT="$HOME/.pyenv"
[[ ":${PATH}:" == *:$PYENV_ROOT/bin:* ]] || PATH="$PYENV_ROOT/bin${PATH:+:$PATH}"
eval "$(pyenv init -)"

# do not include `-pedantic`, it warns casting from (void*) to function pointer
# export this variable to environ, so as to be used in makefile
declare -x CDBFLAGS='-ggdb3 -Wall -Wextra -Wshadow -Wpointer-arith -Wcast-qual -Wstrict-prototypes'
# no emacs keys
alias info='info --vi-keys'
# rm interactively, for safety
alias rm='rm -i'

ng8w-ssh() {
    declare need_knock
    declare ssh_port
    declare ip
    if [ "$1" == '-k' ]; then
        need_knock=true
        ssh_port=22999
        ip=$2
    else
        need_knock=false
        ssh_port=22
        ip=$1
    fi
    if [[ "$ip" != *.*.*.* ]]; then
        ip=192.168.$ip
    fi
    if [[ ! ( "$ip" =~ ^([[:digit:]]{1,3}\.){3}[[:digit:]]{1,3}$ ) ]]; then
        echo 'Usage: ng8w-ssh [-k] <ipaddr>'
        return 1
    fi
    declare knock_port=10001
    declare knock_str='eJzLSM3JyQcABiwCFQ=='
    declare user=root
    if "$need_knock"; then
        base64 -d <<<"$knock_str" >/dev/udp/"$ip"/$"$knock_port"
        sleep 0.1
    fi
    ssh -p "$ssh_port" -o StrictHostKeyChecking=no "$user"@"$ip"
}

ng8w-scp() {
    declare need_knock
    declare knock_port=10001
    declare knock_str='eJzLSM3JyQcABiwCFQ=='
    declare ssh_port
    declare ip

    if [ "$1" == '-k' ]; then
        need_knock=true
        ssh_port=22999
        shift
    else
        need_knock=false
        ssh_port=22
    fi

    declare -a ips
    declare saved_params="$@"
    while (($# > 0)); do
        [[ $1 =~ ^.*@(([0-9]{1,3}\.){3}[0-9]{1,3}):.*$ ]] && ips+=(${BASH_REMATCH[1]})
        shift
    done

    $need_knock && {
        for ip in "${ips[@]}"; do
            base64 -d <<<"$knock_str" >/dev/udp/"$ip"/$"$knock_port"
            sleep 0.2
        done
    }

    scp -P $ssh_port $saved_params
}

cd() {
    if [ $# -eq 0 ]; then
        builtin cd
    fi
    if [ -e "$(readlink -e "${!#}")" ]; then
        builtin cd "$@"
    elif [[ "${!#}" == +(.)* ]]; then
        declare dir=${!#//../../}
        declare x=$(($#-1))
        builtin cd "${@:1:$x}" "$dir"
    else
        builtin cd "$@"
    fi
}

# display where the shell function is defined
whereisfunc() {
    declare ret=0
    shopt -s extdebug
    declare -F "$1" || ret=1
    shopt -u extdebug
    return $ret
}

if [[ "$HOSTNAME" == workstation ]]; then
    CSBOOKS=~/Dropbox/professional/resources/computer-science/resources
    WEEKLYREPORT=~/Desktop/weekly_report/weekly_report.tex
    SECRECY=~/Desktop/secrecy
    NG8W=$SECRECY/ng8w-project
    MYPROJECTS=~/Dropbox/professional/my-project
    TRYS=~/Desktop/try
    MATERIALS_READ=~/Dropbox/professional/materials_read
    GOALS=~/Dropbox/goals
    NOTES=~/Dropbox/professional/notes-and-knowledge
elif [[ "$HOSTNAME" == homestation ]]; then
    CSBOOKS=~/Desktop/csbooks
    MYPROJECTS=~/Desktop/my-project
    TRYS=~/Desktop/try
    MATERIALS_READ=~/Desktop/materials_read
    GOALS=~/Desktop/goals
    NOTES=~/Desktop/professional-notes-knowledge
fi

special-routes() {
    sudo ip route replace 10.0.0.111/32 via 192.168.18.2 dev eno1 proto static metric 0
    sudo ip route replace 10.255.0.10/32 via 192.168.18.2 dev eno1 proto static metric 0
    sudo ip route replace 10.255.52.111/32 via 192.168.18.2 dev eno1 proto static metric 0
    sudo ip route replace 10.255.52.112/32 via 192.168.18.2 dev eno1 proto static metric 0
    sudo ip route replace 10.255.49.65/32 via 192.168.18.2 dev eno1 proto static metric 0
    sudo ip route replace 192.168.16.0/24 via 192.168.18.2 dev eno1 proto static metric 0
}

backup-home() {
    sudo rsync -avu --delete --exclude='.cache' --exclude='vm/*.qcow2' --exclude='Downloads' --exclude='Desktop/try' --exclude='.mozilla' /home/naitree/ naitree@workstation
}

# vim:ft=sh
