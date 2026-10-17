#!/usr/bin/env bash
# ==============================================================================
# Slime Desktop — Synchronization & Backup Utility
# ==============================================================================
# Usage:
#   ./sync.sh              # Backup live configs -> ~/Projects/slime and show diff
#   ./sync.sh --backup     # Same as above (pull from live system)
#   ./sync.sh --restore    # Restore ~/Projects/slime -> live system (with backup)
#   ./sync.sh --diff       # Show git diff of changes inside ~/Projects/slime
#   ./sync.sh --commit "m" # Commit changes with a message
# ==============================================================================

set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_LIST=(apply-power-limits.sh battery-threshold dots play powerprofilesctl qtile-fzf qtile-notes qtile-screenshot sorted termplay)

color() {
    local c="$1"; shift
    case "$c" in
        green)  echo -e "\033[38;2;85;247;54m$*\033[0m" ;;
        yellow) echo -e "\033[38;2;216;235;52m$*\033[0m" ;;
        blue)   echo -e "\033[38;2;54;227;133m$*\033[0m" ;;
        red)    echo -e "\033[38;2;255;67;67m$*\033[0m" ;;
        dim)    echo -e "\033[38;2;198;245;130;2m$*\033[0m" ;;
        *)      echo "$*" ;;
    esac
}

backup_live_to_repo() {
    color green "=== 🟢 Syncing Live Desktop Configs -> ~/Projects/slime ==="
    
    # AwesomeWM
    mkdir -p "$SCRIPT_DIR/config/awesome"
    cp -rp "$HOME/.config/awesome"/* "$SCRIPT_DIR/config/awesome/"
    
    # Picom, Kitty, Rofi
    mkdir -p "$SCRIPT_DIR/config/picom" "$SCRIPT_DIR/config/kitty" "$SCRIPT_DIR/config/rofi"
    [ -f "$HOME/.config/picom/picom.conf" ] && cp -p "$HOME/.config/picom/picom.conf" "$SCRIPT_DIR/config/picom/"
    [ -f "$HOME/.config/kitty/kitty.conf" ] && cp -p "$HOME/.config/kitty/kitty.conf" "$SCRIPT_DIR/config/kitty/"
    [ -f "$HOME/.config/rofi/config.rasi" ] && cp -p "$HOME/.config/rofi/config.rasi" "$SCRIPT_DIR/config/rofi/"
    
    # Neovim & Btop
    mkdir -p "$SCRIPT_DIR/config/nvim" "$SCRIPT_DIR/config/btop"
    [ -d "$HOME/.config/nvim" ] && cp -rp "$HOME/.config/nvim"/* "$SCRIPT_DIR/config/nvim/"
    [ -d "$HOME/.config/btop" ] && cp -rp "$HOME/.config/btop"/* "$SCRIPT_DIR/config/btop/"
    
    # GTK, MPV, yt-dlp, Starship
    mkdir -p "$SCRIPT_DIR/config/gtk-3.0" "$SCRIPT_DIR/config/gtk-4.0" "$SCRIPT_DIR/config/mpv" "$SCRIPT_DIR/config/yt-dlp"
    [ -f "$HOME/.config/gtk-3.0/settings.ini" ] && cp -p "$HOME/.config/gtk-3.0/settings.ini" "$SCRIPT_DIR/config/gtk-3.0/"
    [ -f "$HOME/.config/gtk-4.0/settings.ini" ] && cp -p "$HOME/.config/gtk-4.0/settings.ini" "$SCRIPT_DIR/config/gtk-4.0/"
    [ -f "$HOME/.config/mpv/mpv.conf" ] && cp -p "$HOME/.config/mpv/mpv.conf" "$SCRIPT_DIR/config/mpv/"
    [ -f "$HOME/.config/yt-dlp/config" ] && cp -p "$HOME/.config/yt-dlp/config" "$SCRIPT_DIR/config/yt-dlp/"
    [ -f "$HOME/.config/starship.toml" ] && cp -p "$HOME/.config/starship.toml" "$SCRIPT_DIR/config/"
    
    # User scripts
    mkdir -p "$SCRIPT_DIR/bin"
    for b in "${BIN_LIST[@]}"; do
        if [ -e "$HOME/.local/bin/$b" ]; then
            cp -a "$HOME/.local/bin/$b" "$SCRIPT_DIR/bin/"
        fi
    done
    
    # Python GUI dropdown pads
    mkdir -p "$SCRIPT_DIR/pads"
    if [ -d "$HOME/Projects/qtile_bench" ]; then
        cp -p "$HOME/Projects/qtile_bench"/*.py "$SCRIPT_DIR/pads/"
    fi
    
    # Shell & Wallpaper
    mkdir -p "$SCRIPT_DIR/shell" "$SCRIPT_DIR/wallpaper"
    [ -f "$HOME/.zshrc" ] && cp -p "$HOME/.zshrc" "$SCRIPT_DIR/shell/.zshrc"
    [ -f "$HOME/.bashrc" ] && cp -p "$HOME/.bashrc" "$SCRIPT_DIR/shell/.bashrc"
    [ -f "$HOME/Pictures/wallpaper/slime.jpg" ] && cp -p "$HOME/Pictures/wallpaper/slime.jpg" "$SCRIPT_DIR/wallpaper/"
    
    color green "✔ All configs refreshed into ~/Projects/slime."
    echo ""
    
    if command -v git >/dev/null 2>&1; then
        cd "$SCRIPT_DIR"
        local status
        status=$(git status --short)
        if [ -n "$status" ]; then
            color yellow "Modified / New files in repository:"
            echo "$status"
            echo ""
            color dim "To review changes:    cd ~/Projects/slime && git diff"
            color dim "To commit changes:    ./sync.sh --commit 'your message'"
        else
            color green "✔ Working tree is clean — repository matches live system exactly."
        fi
    fi
}

restore_repo_to_live() {
    local backup_dir="$HOME/.slime_backup_$(date +%Y%m%d_%H%M%S)"
    color yellow "=== 🟡 Restoring ~/Projects/slime -> Live System ==="
    color dim "Creating backup of current configs at $backup_dir..."
    mkdir -p "$backup_dir"
    
    # Backup existing
    [ -d "$HOME/.config/awesome" ] && cp -rp "$HOME/.config/awesome" "$backup_dir/"
    [ -f "$HOME/.config/picom/picom.conf" ] && cp -p "$HOME/.config/picom/picom.conf" "$backup_dir/"
    [ -f "$HOME/.config/kitty/kitty.conf" ] && cp -p "$HOME/.config/kitty/kitty.conf" "$backup_dir/"
    [ -f "$HOME/.config/rofi/config.rasi" ] && cp -p "$HOME/.config/rofi/config.rasi" "$backup_dir/"
    
    # Deploy
    mkdir -p "$HOME/.config/awesome" "$HOME/.config/picom" "$HOME/.config/kitty" "$HOME/.config/rofi"
    mkdir -p "$HOME/.config/nvim" "$HOME/.config/btop" "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"
    mkdir -p "$HOME/.config/mpv" "$HOME/.config/yt-dlp" "$HOME/.local/bin" "$HOME/Projects/qtile_bench"
    mkdir -p "$HOME/Pictures/wallpaper"
    
    cp -rp "$SCRIPT_DIR/config/awesome"/* "$HOME/.config/awesome/"
    cp -p "$SCRIPT_DIR/config/picom/picom.conf" "$HOME/.config/picom/"
    cp -p "$SCRIPT_DIR/config/kitty/kitty.conf" "$HOME/.config/kitty/"
    cp -p "$SCRIPT_DIR/config/rofi/config.rasi" "$HOME/.config/rofi/"
    cp -rp "$SCRIPT_DIR/config/nvim"/* "$HOME/.config/nvim/"
    cp -rp "$SCRIPT_DIR/config/btop"/* "$HOME/.config/btop/"
    cp -p "$SCRIPT_DIR/config/gtk-3.0/settings.ini" "$HOME/.config/gtk-3.0/"
    cp -p "$SCRIPT_DIR/config/gtk-4.0/settings.ini" "$HOME/.config/gtk-4.0/"
    cp -p "$SCRIPT_DIR/config/mpv/mpv.conf" "$HOME/.config/mpv/"
    cp -p "$SCRIPT_DIR/config/yt-dlp/config" "$HOME/.config/yt-dlp/"
    cp -p "$SCRIPT_DIR/config/starship.toml" "$HOME/.config/"
    
    cp -a "$SCRIPT_DIR/bin"/* "$HOME/.local/bin/"
    chmod +x "$HOME/.local/bin"/*
    
    cp -p "$SCRIPT_DIR/pads"/*.py "$HOME/Projects/qtile_bench/"
    chmod +x "$HOME/Projects/qtile_bench"/*.py
    
    [ -f "$SCRIPT_DIR/shell/.zshrc" ] && cp -p "$SCRIPT_DIR/shell/.zshrc" "$HOME/.zshrc"
    [ -f "$SCRIPT_DIR/shell/.bashrc" ] && cp -p "$SCRIPT_DIR/shell/.bashrc" "$HOME/.bashrc"
    [ -f "$SCRIPT_DIR/wallpaper/slime.jpg" ] && cp -p "$SCRIPT_DIR/wallpaper/slime.jpg" "$HOME/Pictures/wallpaper/"
    
    color green "✔ Restore complete! Live configs updated."
    color dim "Previous configs saved in: $backup_dir"
    
    # Reload AwesomeWM if running
    if pgrep -x awesome >/dev/null 2>&1; then
        color blue "Reloading AwesomeWM..."
        dbus-send --dest=org.awesomewm.awful --type=method_call / org.awesomewm.awful.Remote.Eval string:'awesome.restart()' 2>/dev/null || true
    fi
}

case "${1:-}" in
    --restore|--install|--push)
        restore_repo_to_live
        ;;
    --diff)
        cd "$SCRIPT_DIR"
        git diff
        ;;
    --commit)
        shift
        msg="${*:-Update slime configs}"
        cd "$SCRIPT_DIR"
        git add -A
        git commit -m "$msg"
        color green "✔ Committed changes: '$msg'"
        ;;
    --help|-h)
        echo "Slime Config Manager"
        echo "  ./sync.sh              Backup live configs into ~/Projects/slime"
        echo "  ./sync.sh --restore    Restore repository configs to live desktop"
        echo "  ./sync.sh --diff       Show uncommitted changes"
        echo "  ./sync.sh --commit 'm' Add all and commit to git"
        ;;
    *)
        backup_live_to_repo
        ;;
esac
