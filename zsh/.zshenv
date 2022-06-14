# Function to remove non-existent directories from array.
# https://zsh.sourceforge.io/Contrib/startup/users/debbiep/dot.zshenv
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
# End function

# Set up additional paths
path+=(
    ~/.local/bin
)

rationalize-path path
# only unique entries
typeset -U path

# Set INFOPATH
typeset -T INFOPATH infopath

# Set MANPATH
typeset -T MANPATH manpath
manpath+=(
    ~/.linuxbrew/share/man
)
rationalize-path manpath
typeset -U manpath

## Set up tools
#

if [ -f "$HOME/.cargo/env" ]
then
    source "$HOME/.cargo/env"
fi

# Set up pyenv
if (( $+commands[pyenv] ))
then
    export PYENV_ROOT="$HOME/.pyenv"
    path=($PYENV_ROOT/bin "$path[@]")
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
    export PYENV_VIRTUALENV_DISABLE_PROMPT=1
fi

# Set up linuxbrew
if [ $(uname -s) = "Darwin" ]
then
    path+=(
        ~/homebrew/bin
    )
else
    path+=(
        ~/.linuxbrew/bin
        ~/.linuxbrew/sbin
    )
    rationalize-path path
    typeset -U path

    infopath+=(
        ~/.linuxbrew/share/info
    )
    rationalize-path infopath
    typeset -U infopath

    if (( $+commands[brew] ))
    then
        export HOMEBREW_PREFIX=~/.linuxbrew
        export HOMEBREW_CELLAR=~/.linuxbrew/Cellar
        export HOMEBREW_REPOSITORY=~/.linuxbrew/Homebrew
        export HOMEBREW_SHELLENV_PREFIX=~/.linuxbrew
    fi
fi

# Set up cuda
if [ -d "/usr/local/cuda-11.6/bin" ]
then
    path=(/usr/local/cuda-11.6/bin "$path[@]")
fi

# Set up CoppeliaSim
if [ -d "~/tools/CoppeliaSim_Edu_V4_3_0_Ubuntu20_04" ]
then
    export COPPELIASIM_ROOT_DIR=~/tools/CoppeliaSim_Edu_V4_3_0_Ubuntu20_04
fi

# Set up NPM
if [ -d "$HOME/.npm-global" ]
then
    path=(~/.npm-global "$path[@]")
fi

# Set up NVM
if [ -d "$HOME/.config/nvm" ]
then
    export NVM_DIR="$HOME/.config/nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
fi

# Set up NVM
if [ -d "$HOME/.config/nvm" ]
then
    export NVM_DIR="$HOME/.config/nvm"
    # This loads nvm
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    # This loads nvm bash_completion
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

#
## End load tools

# Source aliases
source ~/.aliases.zsh
