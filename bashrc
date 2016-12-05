# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# my bin
[[ ":${PATH}:" == *:$HOME/bin:* ]] || PATH="$HOME/bin${PATH:+:$PATH}"

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


alias gccd='gcc -std=c11 -ggdb3 -pedantic -Wall -Wextra -Wshadow -Wpointer-arith -Wcast-qual -Wstrict-prototypes'
# no emacs keys
alias info='info --vi-keys'
# rm interactively, for safety
alias rm='rm -i'

pointerspeed() {
    declare speed="${1:-}"
    declare mouse_id=$(xinput --list | sed -r -n -e '/Mouse.*pointer/{s/^.*id=([0-9]+).*$/\1/i;p}')
    if [ -z "$speed" ]; then
        xinput --set-prop "$mouse_id" 'libinput Accel Speed' "-0.9"
        return $?
    else
        xinput --set-prop "$mouse_id" 'libinput Accel Speed' "$speed"
        return $?
    fi
}

touchpad() {
    declare action="${1:-enable}"
    declare touchpad_id=$(xinput --list | sed -r -n -e '/GlidePoint|TouchPad/{s/^.*id=([0-9]+).*$/\1/i;p}')
    if [ "$action" == "enable" ]; then
        xinput --set-prop "$touchpad_id" 'Device Enabled' 1
        # set touchpad able to tap as left click
        xinput --set-prop "$touchpad_id" 'libinput Tapping Enabled' 1
        return $?
    elif [ "$action" == "disable" ]; then
        xinput --set-prop "$touchpad_id" 'Device Enabled' 0
        return $?
    else
        echo "invalid action"
        return 1
    fi
}

complete -W 'enable disable' touchpad

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
    ssh -p "$ssh_port" "$user"@"$ip"
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

CSBOOKS=~/Dropbox/professional/resources/computer-science/resources
WEEKLYREPORT=~/Desktop/weekly_report/weekly_report.tex
SECRECY=~/Desktop/secrecy
NG8W=$SECRECY/ng8w-project
MYPROJECTS=~/Dropbox/professional/my-project
TRYS=~/Desktop/try
MATERIALS_READ=~/Dropbox/professional/materials_read
GOALS=~/Dropbox/goals

special-routes() {
    sudo ip route replace 10.0.0.111/32 via 192.168.18.2 dev eno1 proto static metric 0
    sudo ip route replace 10.255.52.112/32 via 192.168.18.2 dev eno1 proto static metric 0
    sudo ip route replace 192.168.16.0/24 via 192.168.18.2 dev eno1 proto static metric 0
}

launch-win7() {
    declare vm=/home/naitree/vm/win7/win7.qcow2
    declare spice_sock=/tmp/win7-spice.socket
    declare shareddir=/home/naitree/Downloads

    # explanation:
    # VM name
    # detach from stdio
    # fully utilize host CPU with KVM kernel module
    # win7 disk image, use paravirtualized virtio
    # DHCP hostname: win7, launch SMB server on host
    # memory 1G
    # sound card
    # moving the cursor of guest on hovering
    # VGA type: QEMU QXL video accelerator, a paravirtualized framebuffer device for SPICE
    # SPICE, using unix domain socket, disable authentication and audio compression
    # next three lines: spice-vdagent configs, to enable copy&paste between host-guest
    qemu-kvm -name Win7 \
    -daemonize \
    -cpu host -enable-kvm \
    -drive file=$vm,if=virtio \
    -net nic -net user,hostname=win7,smb=$shareddir \
    -m 1G \
    -soundhw hda \
    -usbdevice tablet \
    -vga qxl \
    -spice unix,addr=$spice_sock,disable-ticketing,playback-compression=off \
    -device virtio-serial-pci \
    -device virtserialport,chardev=spicechannel0,name=com.redhat.spice.0 \
    -chardev spicevmc,id=spicechannel0,name=vdagent \
    "$@"

    remote-viewer spice+unix://$spice_sock &
}

# vim:ft=sh
