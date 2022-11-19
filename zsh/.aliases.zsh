# Alternate tools
alias htop=btop
alias cat=bat

# Safety aliases for file operations
alias mv='mv -i'
alias cp='cp -i'

# Open files cleanly with default program
function open () {
  xdg-open "$*" > /dev/null 2>&1
}

# alias for using emacs when running in server mode
alias em='emacsclient --tty'
alias ema='emacsclient --create-frame --no-wait'

# alias for kubectl via minikube
alias kubectl="minikube kubectl --"

# Git aliases
#

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

