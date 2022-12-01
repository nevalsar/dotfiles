# Download znap if not present
# https://github.com/marlonrichert/zsh-snap
[[ -f ~/.znap/zsh-snap/znap.zsh ]] ||
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git ~/.znap/zsh-snap

# Load znap
source ~/.znap/zsh-snap/znap.zsh

# Enable menu-driven completion
zstyle ':completion:*' menu select

# Enable case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Enable autocompletion for SSH hosts and logins
zstyle ':completion:*:ssh:*' hosts
zstyle ':completion:*:slogin:*' hosts

# https://starship.rs/
if (( $+commands[starship] ))
then
    znap eval starship 'starship init zsh'
    # znap prompt starship
    prompt_starship_precmd
    znap prompt
else
    znap prompt sindresorhus/pure
fi

# ajeetdsouza/zoxide
znap eval zoxide 'zoxide init zsh'

### Install plugins
#
znap source sorin-ionescu/prezto modules/{environment,history}
znap source zsh-users/zsh-syntax-highlighting
znap eval trapd00r/LS_COLORS "$( whence -a dircolors gdircolors ) -b LS_COLORS"
znap source zsh-users/zsh-autosuggestions
znap source zsh-users/zsh-completions
znap source esc/conda-zsh-completion

# Install exa aliases only if exa is installed
if (( $+commands[exa] ))
then
    znap source DarrinTisdale/zsh-aliases-exa
fi
### End install plugins

### Configure completions
#
if (( $+commands[rustup] ))
then
    znap fpath _rustup 'rustup completions zsh'
    znap fpath _cargo 'rustup completions zsh cargo'
fi
### End configure completions

### End functions

### Configure conda
#
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
### End configure conda

### Configure junegunn/fzf
# https://github.com/junegunn/fzf
#
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
    source $HOME/.fzf.zsh
fi

# Options to fzf command
export FZF_COMPLETION_OPTS='--border --info=inline'

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
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
### End configure junegunn/fzf

# Enable command-line editing in external editor
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

# Set default editor
export VISUAL='emacsclient -t'
export EDITOR='emacsclient -t'

# Fix comment highlight color since kitty doesn't interpret bold colors as bright
# colors (zsh comments are set to bold black by zsh-syntax-highlighting plugin)
ZSH_HIGHLIGHT_STYLES[comment]=fg=245

# Set up pyenv
if (( $+commands[pyenv] ))
then
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi