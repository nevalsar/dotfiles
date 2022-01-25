export DOTFILES=$HOME/source/github/dotfiles

# https://zsh.sourceforge.io/Contrib/startup/users/debbiep/dot.zshenv
# Function to remove non-existent directories from array.
rationalize-path () {
  local element
  local build
  build=()
  # Evil quoting to survive an eval and to make sure that
  # this works even with variables containing IFS characters, if I'm
  # crazy enough to setopt shwordsplit.
  eval '
  foreach element in "$'"$1"'[@]"
  do
    if [[ -d "$element" ]]
    then
      build=("$build[@]" "$element")
    fi
  done
  '"$1"'=( "$build[@]" )
  '
}

# Set up additional paths
path+=(
    ~/.npm-global/bin
    ~/.local/bin
    ~/.linuxbrew/bin
    ~/.linuxbrew/sbin
)

rationalize-path path
# only unique entries
typeset -U path

# Set INFOPATH
typeset -T INFOPATH infopath
infopath+=(
    ~/.linuxbrew/share/info
)
rationalize-path infopath
typeset -U infopath

# Set MANPATH
typeset -T MANPATH manpath
manpath+=(
    ~/.linuxbrew/share/man
)
rationalize-path manpath
typeset -U manpath

source "$HOME/.cargo/env"

# Set up Brew
export HOMEBREW_PREFIX=~/.linuxbrew
export HOMEBREW_CELLAR=~/.linuxbrew/Cellar
export HOMEBREW_REPOSITORY=~/.linuxbrew/Homebrew
export HOMEBREW_SHELLENV_PREFIX=~/.linuxbrew

# Source aliases
source $DOTFILES/zsh/aliases.zsh

# Set up pyenv
export PYENV_ROOT="$HOME/.pyenv"
path=($PYENV_ROOT/bin "$path[@]")
eval "$(pyenv init -)"