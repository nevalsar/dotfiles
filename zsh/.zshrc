# Download marlonrichert/znap if not present
# https://github.com/marlonrichert/zsh-snap
[[ -f ~/.znap/zsh-snap/znap.zsh ]] ||
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git ~/.znap/zsh-snap

# Load znap plugin manager
source ~/.znap/zsh-snap/znap.zsh

# Enable menu-driven completion
zstyle ':completion:*' menu select

# Enable case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Enable autocompletion for SSH hosts and logins
zstyle ':completion:*:ssh:*' hosts
zstyle ':completion:*:slogin:*' hosts

# Enable command-line editing in external editor
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

# Configure shell theme ########################################################

# # https://starship.rs/
# if (( $+commands[starship] ))
# then
#     znap eval starship 'starship init zsh --print-full-init'
#     znap prompt
# else
#     znap prompt sindresorhus/pure
# fi

# znap prompt sindresorhus/pure

# romkatv/powerlevel10k
znap prompt romkatv/powerlevel10k
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# End configure shell theme ####################################################

# Configure shell navigation and completion plugins ############################

# ajeetdsouza/zoxide
znap eval zoxide 'zoxide init zsh'

znap source sorin-ionescu/prezto modules/{environment,history}

znap source zsh-users/zsh-autosuggestions
znap source zsh-users/zsh-completions
znap source esc/conda-zsh-completion

# Install exa aliases only if exa is installed
if (( $+commands[exa] ))
then
    znap source DarrinTisdale/zsh-aliases-exa
fi

# configure rust completions
if (( $+commands[rustup] ))
then
    znap fpath _rustup 'rustup completions zsh'
    znap fpath _cargo 'rustup completions zsh cargo'
fi

# Configure junegunn/fzf -------------------------------------------------------
# https://github.com/junegunn/fzf

export FZF_DEFAULT_COMMAND="fd -H ."
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd -H -t d . $HOME"

# Press CTRL-Y to copy the line to clipboard and aborts fzf
export FZF_DEFAULT_OPTS="--bind 'ctrl-w:execute-silent(echo {} | xclip -i -sel clip)+abort'"

# Source key binding and completion
if [ -d /usr/share/doc/fzf/ ]
then
    source /usr/share/doc/fzf/examples/key-bindings.zsh
    source /usr/share/doc/fzf/examples/completion.zsh
else
    source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh
fi

# Options to fzf command
export FZF_COMPLETION_OPTS='--border --info=inline'

# Configure sharkdp/fd
# https://github.com/sharkdp/fd
_fzf_compgen_path() {
    fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
    fd --type d --hidden --follow --exclude ".git" . "$1"
}

# (EXPERIMENTAL) Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
    local command=$1
    shift

    case "$command" in
        cd)           fzf "$@" --preview 'tree -C {} | head -200' ;;
        export|unset) fzf "$@" --preview "eval 'echo \$'{}" ;;
        ssh)          fzf "$@" --preview 'dig {}' ;;
        *)            fzf "$@" ;;
    esac
}
# End configure junegunn/fzf ---------------------------------------------------

# End configure shell navigation and completion ################################

################################################################################
# Configure shell syntax highlighting

# set up colors
znap eval trapd00r/LS_COLORS "$( whence -a dircolors gdircolors ) -b LS_COLORS"
znap source marlonrichert/zcolors
znap eval zcolors "zcolors ${(q)LS_COLORS}"

# load zsh-syntax-highlighting as las plugin
znap source zsh-users/zsh-syntax-highlighting

# highlight known and unknown tokens
ZSH_HIGHLIGHT_STYLES[command]=fg=green
ZSH_HIGHLIGHT_STYLES[builtin]=fg=green
ZSH_HIGHLIGHT_STYLES[precommand]=fg=green
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red,bold

# differentiate aliases and functions
ZSH_HIGHLIGHT_STYLES[alias]=fg=magenta
ZSH_HIGHLIGHT_STYLES[function]=fg=magenta

# Fix comment highlight color since kitty doesn't interpret bold colors as bright
# colors (zsh comments are set to bold black by zsh-syntax-highlighting plugin)
ZSH_HIGHLIGHT_STYLES[comment]=fg=245

# End configure shell syntax highlighting ###################################### 

# Configure tools ##############################################################

# Configure conda --------------------------------------------------------------
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('$HOME/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/anaconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
# End configure conda ----------------------------------------------------------
# Configure pyenv --------------------------------------------------------------
if [ -d "$HOME/.pyenv" ]
then
    export PYENV_ROOT="$HOME/.pyenv"
    path=($PYENV_ROOT/bin "$path[@]")
    export PYENV_VIRTUALENV_DISABLE_PROMPT=1
fi
if (( $+commands[pyenv] ))
then
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi
# ------------------------------------------------------------------------------
# Set up asdf ------------------------------------------------------------------
if (( $+commands[brew] ))
then
    . $(brew --prefix asdf)/libexec/asdf.sh
fi
# ------------------------------------------------------------------------------

# Set up NVM -------------------------------------------------------------------
if [ -d "$HOME/.config/nvm" ]
then
    export NVM_DIR="$HOME/.config/nvm"
    # This loads nvm
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi
# ------------------------------------------------------------------------------

# Set up NPM -------------------------------------------------------------------
if [ -d "$HOME/.npm-global" ]
then
    path=(~/.npm-global "$path[@]")
fi
# ------------------------------------------------------------------------------

# Set up Homebrew --------------------------------------------------------------
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
# ------------------------------------------------------------------------------

# Set up cargo -----------------------------------------------------------------
if [ -f "$HOME/.cargo/env" ]
then
    source "$HOME/.cargo/env"
fi
# ------------------------------------------------------------------------------

# Set up cuda ------------------------------------------------------------------
if [ -d "/usr/local/cuda-11.6/bin" ]
then
    path=(/usr/local/cuda-11.6/bin "$path[@]")
fi
# ------------------------------------------------------------------------------

# Set up CoppeliaSim -----------------------------------------------------------
if [ -d "~/tools/CoppeliaSim_Edu_V4_3_0_Ubuntu20_04" ]
then
    export COPPELIASIM_ROOT_DIR=~/tools/CoppeliaSim_Edu_V4_3_0_Ubuntu20_04
fi
# ------------------------------------------------------------------------------

# Set up golang ----------------------------------------------------------------
path+=(
    /usr/local/go/bin
)
export GOROOT=/usr/local/go
# ------------------------------------------------------------------------------

# End configure tools ##########################################################

