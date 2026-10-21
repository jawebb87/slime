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
# Copy only scripts owned by this project when pulling live changes.
BIN_LIST=()
for script in "$SCRIPT_DIR/bin"/*; do
    BIN_LIST+=("${script##*/}")
done

copy_wallpapers() {
    local source="$1" destination="$2" image
    mkdir -p "$destination"
    for image in "$source"/*; do
        [ -f "$image" ] || continue
        case "${image,,}" in
            *.jpg|*.jpeg|*.png|*.webp) cp -p "$image" "$destination/" ;;
        esac
    done
}

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
    
    # Picom, Kitty, Alacritty, LXTerminal, TMUX, Rofi, XSettingsd (including theme variants)
    mkdir -p "$SCRIPT_DIR/config/picom" "$SCRIPT_DIR/config/kitty" "$SCRIPT_DIR/config/alacritty" "$SCRIPT_DIR/config/lxterminal" "$SCRIPT_DIR/config/tmux/themes" "$SCRIPT_DIR/config/rofi" "$SCRIPT_DIR/config/xsettingsd"
    cp -p "$HOME/.config/picom"/*.conf "$SCRIPT_DIR/config/picom/" 2>/dev/null || true
    cp -p "$HOME/.config/kitty"/*.conf "$SCRIPT_DIR/config/kitty/" 2>/dev/null || true
    cp -p "$HOME/.config/alacritty"/*.toml "$SCRIPT_DIR/config/alacritty/" 2>/dev/null || true
    cp -p "$HOME/.config/lxterminal"/*.conf "$SCRIPT_DIR/config/lxterminal/" 2>/dev/null || true
    cp -p "$HOME/.config/tmux"/*.conf "$SCRIPT_DIR/config/tmux/" 2>/dev/null || true
    cp -p "$HOME/.config/tmux/themes"/*.conf "$SCRIPT_DIR/config/tmux/themes/" 2>/dev/null || true
    cp -p "$HOME/.config/rofi"/*.rasi "$SCRIPT_DIR/config/rofi/" 2>/dev/null || true
    cp -p "$HOME/.config/xsettingsd"/*.conf "$SCRIPT_DIR/config/xsettingsd/" 2>/dev/null || true
    
    # Neovim & Btop
    mkdir -p "$SCRIPT_DIR/config/nvim" "$SCRIPT_DIR/config/btop"
    [ -d "$HOME/.config/nvim" ] && cp -rp "$HOME/.config/nvim"/* "$SCRIPT_DIR/config/nvim/"
    [ -d "$HOME/.config/btop" ] && cp -rp "$HOME/.config/btop"/* "$SCRIPT_DIR/config/btop/"
    
    # GTK, MPV, yt-dlp, Starship, XDG Desktop Portal, Fastfetch
    mkdir -p "$SCRIPT_DIR/config/gtk-3.0" "$SCRIPT_DIR/config/gtk-4.0" "$SCRIPT_DIR/config/mpv" "$SCRIPT_DIR/config/yt-dlp" "$SCRIPT_DIR/config/xdg-desktop-portal" "$SCRIPT_DIR/config/fastfetch"
    [ -f "$HOME/.config/gtk-3.0/settings.ini" ] && cp -p "$HOME/.config/gtk-3.0/settings.ini" "$SCRIPT_DIR/config/gtk-3.0/"
    [ -f "$HOME/.config/gtk-4.0/settings.ini" ] && cp -p "$HOME/.config/gtk-4.0/settings.ini" "$SCRIPT_DIR/config/gtk-4.0/"
    [ -f "$HOME/.config/mpv/mpv.conf" ] && cp -p "$HOME/.config/mpv/mpv.conf" "$SCRIPT_DIR/config/mpv/"
    [ -f "$HOME/.config/yt-dlp/config" ] && cp -p "$HOME/.config/yt-dlp/config" "$SCRIPT_DIR/config/yt-dlp/"
    cp -p "$HOME/.config"/starship*.toml "$SCRIPT_DIR/config/" 2>/dev/null || true
    [ -d "$HOME/.config/xdg-desktop-portal" ] && cp -rp "$HOME/.config/xdg-desktop-portal"/* "$SCRIPT_DIR/config/xdg-desktop-portal/" 2>/dev/null || true
    [ -d "$HOME/.config/fastfetch" ] && cp -rp "$HOME/.config/fastfetch"/* "$SCRIPT_DIR/config/fastfetch/" 2>/dev/null || true
    
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
    [ -f "$HOME/.bash_aliases" ] && cp -p "$HOME/.bash_aliases" "$SCRIPT_DIR/shell/.bash_aliases"
    copy_wallpapers "$HOME/Pictures/wallpaper" "$SCRIPT_DIR/wallpaper"
    
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
    local backup_dir
    backup_dir="$(mktemp -d "$HOME/.slime_backup_$(date +%Y%m%d_%H%M%S)_XXXXXX")"
    color yellow "=== 🟡 Restoring ~/Projects/slime -> Live System ==="
    color dim "Creating backup of current configs at $backup_dir..."
    mkdir -p "$backup_dir"
    
    # Preserve all deployment destinations with their paths relative to HOME.
    # Finish the backup before touching any live files; cp failures abort restore.
    local relative source
    local destinations=(
        .config/awesome .config/picom .config/kitty .config/alacritty
        .config/lxterminal .config/tmux .config/rofi .config/xsettingsd
        .config/xdg-desktop-portal .config/nvim .config/btop
        .config/gtk-3.0 .config/gtk-4.0 .config/mpv .config/yt-dlp
        .config/fastfetch
        .local/bin Projects/qtile_bench Pictures/wallpaper
        .zshrc .bashrc .bash_aliases
    )
    for source in "$HOME/.config"/starship*.toml; do
        [ -e "$source" ] || [ -L "$source" ] || continue
        destinations+=("${source#"$HOME/"}")
    done
    for relative in "${destinations[@]}"; do
        source="$HOME/$relative"
        if [ -e "$source" ] || [ -L "$source" ]; then
            mkdir -p "$backup_dir/$(dirname "$relative")"
            cp -a "$source" "$backup_dir/$relative"
        fi
    done

    # Deploy
    mkdir -p "$HOME/.config/alacritty" "$HOME/.config/awesome" "$HOME/.config/picom" "$HOME/.config/kitty" "$HOME/.config/lxterminal" "$HOME/.config/tmux/themes" "$HOME/.config/rofi" "$HOME/.config/xsettingsd" "$HOME/.config/xdg-desktop-portal" "$HOME/.config/fastfetch"
    mkdir -p "$HOME/.config/nvim" "$HOME/.config/btop" "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"
    mkdir -p "$HOME/.config/mpv" "$HOME/.config/yt-dlp" "$HOME/.local/bin" "$HOME/Projects/qtile_bench"
    mkdir -p "$HOME/Pictures/wallpaper"
    
    cp -rp "$SCRIPT_DIR/config/awesome"/* "$HOME/.config/awesome/"
    cp -p "$SCRIPT_DIR/config/picom"/*.conf "$HOME/.config/picom/"
    cp -p "$SCRIPT_DIR/config/kitty"/*.conf "$HOME/.config/kitty/"
    cp -p "$SCRIPT_DIR/config/alacritty"/*.toml "$HOME/.config/alacritty/"
    cp -p "$SCRIPT_DIR/config/lxterminal"/*.conf "$HOME/.config/lxterminal/" 2>/dev/null || true
    cp -p "$SCRIPT_DIR/config/tmux"/*.conf "$HOME/.config/tmux/" 2>/dev/null || true
    cp -p "$SCRIPT_DIR/config/tmux/themes"/*.conf "$HOME/.config/tmux/themes/" 2>/dev/null || true
    cp -p "$SCRIPT_DIR/config/rofi"/*.rasi "$HOME/.config/rofi/"
    cp -p "$SCRIPT_DIR/config/xsettingsd"/*.conf "$HOME/.config/xsettingsd/" 2>/dev/null || true
    [ -d "$SCRIPT_DIR/config/xdg-desktop-portal" ] && cp -rp "$SCRIPT_DIR/config/xdg-desktop-portal"/* "$HOME/.config/xdg-desktop-portal/" 2>/dev/null || true
    [ -d "$SCRIPT_DIR/config/fastfetch" ] && cp -rp "$SCRIPT_DIR/config/fastfetch"/* "$HOME/.config/fastfetch/" 2>/dev/null || true
    cp -rp "$SCRIPT_DIR/config/nvim"/* "$HOME/.config/nvim/"
    cp -rp "$SCRIPT_DIR/config/btop"/* "$HOME/.config/btop/"
    cp -p "$SCRIPT_DIR/config/gtk-3.0/settings.ini" "$HOME/.config/gtk-3.0/"
    cp -p "$SCRIPT_DIR/config/gtk-4.0/settings.ini" "$HOME/.config/gtk-4.0/"
    cp -p "$SCRIPT_DIR/config/mpv/mpv.conf" "$HOME/.config/mpv/"
    cp -p "$SCRIPT_DIR/config/yt-dlp/config" "$HOME/.config/yt-dlp/"
    cp -p "$SCRIPT_DIR/config"/starship*.toml "$HOME/.config/"
    
    cp -a "$SCRIPT_DIR/bin"/* "$HOME/.local/bin/"
    for source in "$SCRIPT_DIR/bin"/*; do
        chmod +x "$HOME/.local/bin/${source##*/}"
    done
    
    cp -p "$SCRIPT_DIR/pads"/*.py "$HOME/Projects/qtile_bench/"
    for source in "$SCRIPT_DIR/pads"/*.py; do
        chmod +x "$HOME/Projects/qtile_bench/${source##*/}"
    done
    
    [ -f "$SCRIPT_DIR/shell/.zshrc" ] && cp -p "$SCRIPT_DIR/shell/.zshrc" "$HOME/.zshrc"
    [ -f "$SCRIPT_DIR/shell/.bashrc" ] && cp -p "$SCRIPT_DIR/shell/.bashrc" "$HOME/.bashrc"
    [ -f "$SCRIPT_DIR/shell/.bash_aliases" ] && cp -p "$SCRIPT_DIR/shell/.bash_aliases" "$HOME/.bash_aliases"
    copy_wallpapers "$SCRIPT_DIR/wallpaper" "$HOME/Pictures/wallpaper"
    
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
