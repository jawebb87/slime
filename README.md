# 🧪 Slime Rice — Arch Linux Desktop & Configuration Suite

A cohesive, biohazard/radioactive-swamp themed desktop environment built on **AwesomeWM 4.3**, **Picom (GLX + dual-kawase)**, **Kitty**, **Rofi**, **Neovim**, and **Tkinter Python dropdown pads**, designed specifically for Arch Linux on the ASUS TUF FX505DY.

---

## 🎨 Color Palette Reference

| Swatch | Name | Hex Code | Role |
| :--- | :--- | :--- | :--- |
| 🟢 | **Slime Base** | `#0c140d` | Root background, murky swamp bar background |
| 🟢 | **Swamp Dark** | `#122015` | Widget pills, tag backgrounds, inactive borders |
| 🟢 | **Murky Green** | `#25452a` | Tasklist cards, selections, borders |
| 🟢 | **Toxic Slime** | `#55f736` | Active window border, notifications, primary accents |
| 🟢 | **Neon Lime** | `#74ff2e` | Focused cursor, active tags, highlights |
| 🟡 | **Acid Yellow** | `#d8eb34` | Drip glow tips, warning temperatures (≥70°C), modifier keys |
| 🟡 | **Pale Lichen** | `#c6f582` | Terminal foreground, readable UI text, clock pill |
| 🔴 | **Hazard Red** | `#ff4343` | Muted states, critical alerts, battery ≤20%, compiler errors |

---

## 📁 Repository Layout

```text
~/Projects/slime/
├── README.md               # This documentation
├── sync.sh                 # Backup, diff, commit, and restore utility
├── .gitignore              # Ignores __pycache__, editor swaps, backups
├── config/                 # Mirrors ~/.config/
│   ├── awesome/            # Modular AwesomeWM configuration
│   │   ├── rc.lua          # Main entrypoint
│   │   ├── config/         # Apps, autostart, keys, rules, scratchpads, signals
│   │   ├── theme/          # Palette variables & Cairo slime_shapes generator
│   │   └── ui/             # Dripping wibar, quick menu, notifications
│   ├── picom/              # Picom compositor with phosphor-bloom shadows
│   ├── kitty/              # Kitty terminal with 16-color strict slime palette
│   ├── rofi/               # Rofi application launcher
│   ├── nvim/               # Neovim config + slime.lua colorscheme
│   ├── btop/               # System monitor config + slime.theme
│   ├── gtk-3.0/            # MartianMono Nerd Font & dark theme settings
│   ├── gtk-4.0/            # MartianMono Nerd Font & dark theme settings
│   ├── mpv/                # Media player configuration
│   ├── yt-dlp/             # Media downloader configuration
│   └── starship.toml       # Two-line powerline prompt with toxic green/yellow
├── bin/                    # Custom user scripts (mirrors ~/.local/bin/)
│   ├── apply-power-limits.sh
│   ├── battery-threshold   # Passwordless UPower 80% / 100% threshold toggle
│   ├── dots                # Dotfile wrapper
│   ├── play                # Media player alias -> termplay
│   ├── powerprofilesctl    # busctl wrapper for power-profiles-daemon
│   ├── qtile-fzf           # Fuzzy desktop app launcher
│   ├── qtile-notes         # Quick timestamped terminal note pad
│   ├── qtile-screenshot    # Full, window, or region screenshot utility
│   ├── sorted              # Automatic ~/Downloads file sorter
│   └── termplay            # Terminal media player
├── pads/                   # 10 Tkinter Python GUI dropdown pads (~/Projects/qtile_bench/)
│   ├── audio_pad.py        # PipeWire / WirePlumber volume & device manager
│   ├── clip_pad.py         # Clipboard history manager
│   ├── docker_pad.py       # Docker container monitor
│   ├── emoji_pad.py        # Searchable emoji picker
│   ├── key_cheat.py        # Desktop keybinding cheatsheet
│   ├── log_pad.py          # Systemd journal viewer
│   ├── theme.py            # Centralized Tkinter slime theme variables
│   ├── vim_cheat.py        # Neovim cheatsheet
│   ├── weather_pad.py      # Weather dashboard
│   ├── wifi_pad.py         # NetworkManager Wi-Fi scanner & manager
│   └── zodiac_pad.py       # Zodiac & calendar information
├── shell/                  # Shell dotfiles
│   ├── .zshrc              # Slime Zsh config with syntax highlighting & autosuggestions
│   └── .bashrc             # Fallback Bash configuration
├── wallpaper/              # Assets
│   └── slime.jpg           # High-resolution slime wallpaper
└── docs/
    └── slime-rice.md       # Full design specification artifact
```

---

## ⌨️ Desktop Keybindings

| Shortcut | Action / Dropdown | Description |
| :--- | :--- | :--- |
| **`Super + q`** | `client:kill()` | Close active focused window (also `Alt + F4` / `Super + Shift + c`) |
| **`Super + Return`** | `kitty` | Spawn Kitty terminal |
| **`Super + b`** | `firefox` | Spawn Firefox browser |
| **`Super + d`** | `rofi -normal-window -show drun` | Launch Rofi application launcher |
| **`Super + a`** | `audio_pad.py` | PipeWire / WirePlumber audio dashboard |
| **`Super + i`** | `wifi_pad.py` | Wi-Fi network scanner & connection manager |
| **`Super + x`** | `clip_pad.py` | Clipboard history search and copy manager |
| **`Super + t`** | `btop-float` | Floating btop system monitor (`kitty --class btop-float`) |
| **`Super + w`** | `weather_pad.py`| Weather forecast dashboard |
| **`Super + n`** | `log_pad.py` | Systemd journal log viewer |
| **`Super + Shift + d`**| `docker_pad.py` | Docker container and service status monitor |
| **`Super + v`** | `vim_cheat.py` | Vim keybindings cheatsheet |
| **`Super + s`** | `qtile-notes` | Quick timestamped note-taking scratchpad (`kitty --class notes-pad`) |
| **`Super + F1`** | `key_cheat.py` | Desktop keybindings cheatsheet |
| **`Super + z`** | `zodiac_pad.py` | Zodiac and calendar information |
| **`Super + m`** | `emoji_pad.py` | Interactive emoji picker |
| **`F12`** | `term-scratch` | Dropdown terminal overlay |
| **`Super + g`** | `agy-pad` | Antigravity AI coding assistant dropdown |
| **`Print`** | `qtile-screenshot full` | Fullscreen screenshot saved to `~/Pictures/Screenshots` + clipboard |
| **`Super + Print`** | `qtile-screenshot window`| Active window screenshot |
| **`Shift + Print`** | `qtile-screenshot region`| Interactive region screenshot |
| **`XF86AudioRaiseVolume`** | `wpctl +5%` | Raise volume & refresh bar pill |
| **`XF86AudioLowerVolume`** | `wpctl -5%` | Lower volume & refresh bar pill |
| **`XF86AudioMute`** | `wpctl toggle` | Toggle audio mute & refresh bar pill |
| **`XF86MonBrightnessUp/Down`** | `brightnessctl ±5%` | Adjust laptop display backlight |

---

## ⚡ Status Bar Telemetry & Interactions

- **CPU Pill (``):** Live utilization % + AMD `k10temp` package temperature. Left-click launches `btop-float`.
- **System Pill (``):** AMD GPU temperature + used RAM (`GiB`) + free `/` disk space (`GiB`). Left-click launches `btop-float`.
- **Network Pill (`` / ``):** Live Wi-Fi SSID or ` Wired`. Left-click launches `wifi_pad.py`.
- **Volume Pill (``):** PipeWire volume % (turns hazard red ` %` when muted). Left-click launches `audio_pad.py`, right-click toggles mute, scroll adjusts ±5%.
- **Battery Pill (``):** Capacity %, charging state, and `[80%]` limit badge. Left-click toggles `power-saver` ↔ `balanced`; right-click toggles battery charge threshold (`80%` ↔ `100%`) via UPower.
- **Clock Pill (``):** Formatted date and time. Left-click opens `weather_pad.py`, right-click opens `zodiac_pad.py`.

---

## 🔄 How to Backup, Modify, & Restore

### 1. Re-sync live changes into the backup repository
Whenever you make tweaks to your live desktop and want to back them up:
```bash
cd ~/Projects/slime
./sync.sh
```
This copies all modified files from your live desktop into `~/Projects/slime` and displays git status.

### 2. Review diffs and commit
```bash
cd ~/Projects/slime
git diff
./sync.sh --commit "Detailed message describing changes"
```

### 3. Restore repository configs back to the desktop
If you experiment, break something, or want to roll back:
```bash
cd ~/Projects/slime
./sync.sh --restore
```
`sync.sh` automatically creates a safety backup at `~/.slime_backup_<timestamp>` before overwriting any live files, then restarts AwesomeWM.
