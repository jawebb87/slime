# ==============================================================================
# Zsh Configuration - Slime Desktop
# ==============================================================================

# Environment variables
export PATH="$HOME/.local/bin:$PATH"
export EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="kitty"

# History Configuration
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

setopt EXTENDED_HISTORY          # Write timestamps to history
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded
setopt HIST_IGNORE_ALL_DUPS      # Delete older duplicate entry if new entry is a duplicate
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file
setopt SHARE_HISTORY             # Share history across active sessions
setopt AUTO_CD                   # Type directory name to cd
setopt INTERACTIVE_COMMENTS      # Allow comments even in interactive shells

# Fish-style prefix history search with Up / Down arrows
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^[OA' up-line-or-beginning-search
bindkey '^[OB' down-line-or-beginning-search
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char

# Completion System
mkdir -p "$HOME/.cache/zsh"
autoload -Uz compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
compinit -d "$HOME/.cache/zsh/zcompdump"

# Aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
[[ -f ~/.bash_aliases ]] && source ~/.bash_aliases

# Zsh Autosuggestions (styled in dark moss green)
if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#3a5c3e'
fi

# Zsh Syntax Highlighting (styled to match the Slime palette)
if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    typeset -A ZSH_HIGHLIGHT_STYLES
    ZSH_HIGHLIGHT_STYLES[command]='fg=#55f736,bold'
    ZSH_HIGHLIGHT_STYLES[builtin]='fg=#74ff2e,bold'
    ZSH_HIGHLIGHT_STYLES[alias]='fg=#55f736,bold'
    ZSH_HIGHLIGHT_STYLES[function]='fg=#74ff2e'
    ZSH_HIGHLIGHT_STYLES[path]='fg=#c6f582,underline'
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#d8eb34'
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#d8eb34'
    ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#d8eb34'
    ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#36e385'
    ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#ff4343,bold' # Red alert for unrecognized commands!
fi

# Initialize Starship Prompt (Slime two-line powerline)
eval "$(starship init zsh)"
