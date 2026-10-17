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

# Zsh Autosuggestions & Syntax Highlighting (Dual Theme: Slime / Laboratory White)
if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    typeset -gA ZSH_HIGHLIGHT_STYLES
fi

_apply_slime_zsh_theme() {
    local mode="slime"
    if [[ -f "$HOME/.config/awesome/theme_mode" ]]; then
        mode="${$(<"$HOME/.config/awesome/theme_mode")//[[:space:]]/}"
    fi
    [[ "$mode" == "$_CURRENT_ZSH_THEME_MODE" ]] && return
    _CURRENT_ZSH_THEME_MODE="$mode"

    if [[ "$mode" == "origin" ]]; then
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#5a784d'
        ZSH_HIGHLIGHT_STYLES[command]='fg=#9ece6a,bold'
        ZSH_HIGHLIGHT_STYLES[builtin]='fg=#9ece6a,bold'
        ZSH_HIGHLIGHT_STYLES[alias]='fg=#9ece6a,bold'
        ZSH_HIGHLIGHT_STYLES[function]='fg=#7fa96b'
        ZSH_HIGHLIGHT_STYLES[path]='fg=#5a784d,underline'
        ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#d08770'
        ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#d08770'
        ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#d08770'
        ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#8fbcbb'
        ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#bf616a,bold'
    elif [[ "$mode" == "lab" ]]; then
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#64748b'
        ZSH_HIGHLIGHT_STYLES[command]='fg=#0f766e,bold'
        ZSH_HIGHLIGHT_STYLES[builtin]='fg=#0284c7,bold'
        ZSH_HIGHLIGHT_STYLES[alias]='fg=#0f766e,bold'
        ZSH_HIGHLIGHT_STYLES[function]='fg=#0284c7'
        ZSH_HIGHLIGHT_STYLES[path]='fg=#1d4ed8,underline'
        ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#b45309'
        ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#b45309'
        ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#b45309'
        ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#0369a1'
        ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#dc2626,bold'
    elif [[ "$mode" == "cyber" ]]; then
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#6c5f8d'
        ZSH_HIGHLIGHT_STYLES[command]='fg=#a855f7,bold'
        ZSH_HIGHLIGHT_STYLES[builtin]='fg=#55f736,bold'
        ZSH_HIGHLIGHT_STYLES[alias]='fg=#a855f7,bold'
        ZSH_HIGHLIGHT_STYLES[function]='fg=#55f736'
        ZSH_HIGHLIGHT_STYLES[path]='fg=#00f0ff,underline'
        ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#00f0ff'
        ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#00f0ff'
        ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#00f0ff'
        ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#74ff2e'
        ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#ff007f,bold'
    elif [[ "$mode" == "space" ]]; then
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#5a6578'
        ZSH_HIGHLIGHT_STYLES[command]='fg=#0088cc,bold'
        ZSH_HIGHLIGHT_STYLES[builtin]='fg=#c25d00,bold'
        ZSH_HIGHLIGHT_STYLES[alias]='fg=#0088cc,bold'
        ZSH_HIGHLIGHT_STYLES[function]='fg=#006699'
        ZSH_HIGHLIGHT_STYLES[path]='fg=#0088cc,underline'
        ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#0d8a52'
        ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#0d8a52'
        ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#0d8a52'
        ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#c25d00'
        ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#d32f2f,bold'
    elif [[ "$mode" == "shred" ]]; then
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#525b69'
        ZSH_HIGHLIGHT_STYLES[command]='fg=#e2e8f0,bold'
        ZSH_HIGHLIGHT_STYLES[builtin]='fg=#ff5500,bold'
        ZSH_HIGHLIGHT_STYLES[alias]='fg=#c8d0dc,bold'
        ZSH_HIGHLIGHT_STYLES[function]='fg=#8b95a5'
        ZSH_HIGHLIGHT_STYLES[path]='fg=#c8d0dc,underline'
        ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#ff5500'
        ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#ff5500'
        ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#ff5500'
        ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#ff2a2a'
        ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#ff2a2a,bold'
    else
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#3a5c3e'
        ZSH_HIGHLIGHT_STYLES[command]='fg=#55f736,bold'
        ZSH_HIGHLIGHT_STYLES[builtin]='fg=#74ff2e,bold'
        ZSH_HIGHLIGHT_STYLES[alias]='fg=#55f736,bold'
        ZSH_HIGHLIGHT_STYLES[function]='fg=#74ff2e'
        ZSH_HIGHLIGHT_STYLES[path]='fg=#c6f582,underline'
        ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#d8eb34'
        ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#d8eb34'
        ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#d8eb34'
        ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#36e385'
        ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#ff4343,bold'
    fi
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _apply_slime_zsh_theme
_apply_slime_zsh_theme

# Initialize Starship Prompt (Lab / Slime / Cyber)
eval "$(starship init zsh)"
