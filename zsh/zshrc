# ZSH configuration -----------------------------------------------------------

# ignore '..' parent directory shortcut during completion
zstyle ':completion:*' special-dirs false

# source antidote installed via Homebrew
source $HOMEBREW_PREFIX/opt/antidote/share/antidote/antidote.zsh

# plugin pre-load configuration -----------------------------------------------
export _Z_CMD=j

# load plugins
antidote load

# plugin post-load configuration ----------------------------------------------
autoload -Uz promptinit && promptinit && prompt zephyr

# load prompt
prompt powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# configure junegunn/fzf
eval "$(fzf --zsh)"
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"

