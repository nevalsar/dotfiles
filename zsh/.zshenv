# set up default editors
export VISUAL='emacsclient'
export EDITOR='emacsclient'
export SUDO_EDITOR="emacsclient"

# Set up additional paths
path+=(
    ~/.local/bin
)

# set infopath
typeset -T INFOPATH infopath

# set manpath
typeset -T MANPATH manpath

# Override TERM variable set by kitty
if [[ "$TERM" == "xterm-kitty" ]]; then
    TERM=xterm-256color
fi

# ALIASES ######################################################################

# Alternate tools
alias htop=btop

# Safety aliases for file operations
alias mv='mv -i'
alias cp='cp -i'

# aliases for Emacs in server mode
alias em='emacsclient --tty'
alias ema='emacsclient --create-frame --no-wait'

# alias for kubectl via minikube
alias kubectl="minikube kubectl --"

# Git aliases ------------------------------------------------------------------

# Branch (b)
alias gb='git branch'
alias gba='git branch --all --verbose'

# Commit (c)
alias gc='git commit --verbose'
alias gco='git checkout'

# Working copy (ws)
alias gws='git status --short'
alias gwS='git status'
alias gwd='git diff --no-ext-diff'
alias gwdD='git diff --no-ext-diff --word-diff'

# Remote (R)
alias gRu='git remote update'

# Stash (s)
alias gs='git stash'
alias gsa='git stash apply'

# Index (i)
alias gia='git add'
alias gid='git diff --no-ext-diff --cached'
alias giD='git diff --no-ext-diff --cached --word-diff'

# Log (l)
alias gl='git log --topo-order'
alias glc='git shortlog --summary --numbered'
alias glS='git log --show-signature'

# End git aliases --------------------------------------------------------------

# Functions ####################################################################

# Source ROS Noetic
function source-ros-noetic() {
    source /opt/ros/noetic/setup.zsh
}

# Source ROS Galactic
function source-ros-galactic() {
    source /opt/ros/galactic/setup.zsh
    export ROS_DOMAIN_ID=42
}

# Set tab titles in Konsole
set-konsole-tab-title-type ()
{
    local _title="$1"
    local _type=${2:-0}
    [[ -z "${_title}" ]]               && return 1
    [[ -z "${KONSOLE_DBUS_SERVICE}" ]] && return 1
    [[ -z "${KONSOLE_DBUS_SESSION}" ]] && return 1
    qdbus >/dev/null "${KONSOLE_DBUS_SERVICE}" "${KONSOLE_DBUS_SESSION}" setTabTitleFormat "${_type}" "${_title}"
}
set-konsole-tab-title ()
{
    set-konsole-tab-title-type "$1" && set-konsole-tab-title-type "$1" 1
}

function launch {
    nohup $1 >/dev/null 2>/dev/null & disown;
}

# Open files cleanly with default program
function open () {
  xdg-open "$*" > /dev/null 2>&1
}

################################################################################

