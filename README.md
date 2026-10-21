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
| **`Super + Return`** | `alacritty` | Spawn Alacritty terminal |
| **`Super + b`** | `firefox` | Spawn Firefox browser |
| **`Super + d`** | `rofi -normal-window -show drun` | Launch Rofi application launcher |
| **`Super + a`** | `audio_pad.py` | PipeWire / WirePlumber audio dashboard |
| **`Super + i`** | `wifi_pad.py` | Wi-Fi network scanner & connection manager |
| **`Super + x`** | `clip_pad.py` | Clipboard history search and copy manager |
| **`Super + t`** | `btop-float` | Floating btop system monitor in Alacritty |
| **`Super + w`** | `weather_pad.py`| Weather forecast dashboard |
| **`Super + n`** | `log_pad.py` | Systemd journal log viewer |
| **`Super + Shift + d`**| `docker_pad.py` | Docker container and service status monitor |
| **`Super + v`** | `vim_cheat.py` | Vim keybindings cheatsheet |
| **`Super + s`** | `qtile-notes` | Quick timestamped note-taking scratchpad (Alacritty notes-pad) |
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

## Foundry — Victorian Engine Room

A cast-iron, aged-brass, and copper theme with gear assemblies along the
wibar and riveted iron window sills, plus a matching boiler-room wallpaper. Run
`theme-toggle foundry` after deployment. See [the Foundry guide](docs/foundry.md)
for styling, dimensions, and validation commands.

## Mothgomery — Lamplit Workshop

Gill's companion theme shares its rounded glass layout, with brass focus accents,
parchment text, and the supplied moth inventor wallpaper. See
[the Mothgomery guide](docs/mothgomery.md) for the palette and activation.

## Sketchbook — Notes in Progress

A light paper-and-watercolor theme with graphite text, teal selections, clipped
paper corners, and the supplied hedgehog wallpaper. See the
[Sketchbook guide](docs/sketchbook.md) for styling, validation, and activation.

## Grindhouse JAWS — Terror from the Deep

A dark ocean-blue theme with aged cream text, poster-yellow focus accents, blood-red
alerts, and the supplied vintage shark poster. Select `theme-toggle jaws` after
deployment. See [the Grindhouse JAWS guide](docs/jaws.md).

## The Bamboo Corsair

Violet sails, bamboo green focus accents, ghost lantern mint, and transparent
unfocused windows. Select `theme-toggle bamboo-corsair` after deployment. See
[The Bamboo Corsair guide](docs/bamboo-corsair.md) for the palette and opacity.

## Eeyore — Watercolor Sky

A modern cloud-white floating bar, sky-blue selections, sage status accents, and
muted plum details from the supplied watercolor wallpaper. Select
`theme-toggle eeyore` after deployment. See [the Eeyore guide](docs/eeyore.md).

## Halfpipe — After Hours

A concrete ramp silhouette with raised quarterpipes, deck workspace markers,
a grinding skater for the active workspace, park signage stats, and a scoreboard
clock, with the supplied graffiti skatepark wallpaper. Select
`theme-toggle halfpipe`. See
[the Halfpipe guide and bar preview](docs/halfpipe.md).

## Punk Show! — Sound Check

A battered console bar with channel-button workspaces, live CPU and memory LED
meters, a red seven-segment clock, and the supplied amplifier-wall wallpaper.
Select `theme-toggle punk-show`. See [the Punk Show guide](docs/punk-show.md).

## Sugar Rush — Candy Chainsaw

A frosted-pink chainsaw bar with lavender teeth, heart workspace markers, live
sprinkle meters, and the supplied candy-land wallpaper. Select
`theme-toggle sugar-rush`. See [the Sugar Rush guide](docs/sugar-rush.md).

## Crayon Chomp — Hacker Muskrat

A detached paper bar with broken crayon strokes, multicolor workspace markers,
and scribbled telemetry, inspired by the supplied pond-side hacker muskrat.
Select `theme-toggle crayon-chomp` after deployment. See
[the Crayon Chomp guide and preview](docs/crayon-chomp.md).

## Satanic Panic — Do Not Play

A detached tarnished knife bar with dried oxblood crust, a riveted handle,
and the supplied VHS occult desk wallpaper. See
[the Satanic Panic guide and preview](docs/satanic-panic.md).

## Vaporwave Schizoid — Signal Lost

A detached holographic bar with fractured neon edges, wireframe pyramid
workspaces, and subtle VHS scanlines, paired with the supplied neon pyramid
wallpaper. Select `theme-toggle vaporwave-schizoid`. See
[the Vaporwave Schizoid guide and preview](docs/vaporwave-schizoid.md).

## Theme feature parity

All 37 themes provide Alacritty, Kitty, LXTerminal, tmux, Rofi, Picom, Starship,
btop, Neovim, and Python pad palettes. Neovim follows the desktop theme on launch
and when focus returns. The font chooser discovers all installed AwesomeWM themes
and updates their modular definitions and terminal profiles.

Later Alacritty profiles (Foundry through Vaporwave Schizoid) use the established
7 pt terminal size; Slime retains its existing 6.5 pt accessibility-font setting.
Kitty and LXTerminal retain their established per-application sizes.

Every bar retains CPU/system controls. Hover over CPU or memory meters for
CPU temperature, GPU temperature, RAM, and free disk details where available;
hover over the clock for the full date. Compact bars use shorter labels.
F12 retains existing character consoles and uses the current theme's name for
other consoles. Custom art, mascot presence and decorative geometry remain
specific to each theme.

Shortcut conflicts resolved: native Awesome help uses Super+Control+F1;
Chomp console uses Super+Control+c; Tunes console uses Super+Control+t.
Super+Shift+c closes a window, Super+Shift+t toggles keep-on-top, and
Super+Shift+l adjusts the master count. Super+Shift+s opens the TMNT console.

Run `python -m unittest discover -s tests -v` for theme parity and regression
checks. Tests use temporary homes and stub desktop commands.

## Bar autohide — all themes

Every theme's bar starts hidden. Move the pointer to the invisible 2-pixel strip
along the top of any screen to reveal that screen's bar. Detached bars retain
their themed gap and shape; the gap stays reachable while moving to the controls.
The bar hides about half a second after the pointer leaves its top region.

Bars overlay windows without reserving desktop space or moving tiled clients.
Each monitor reveals independently, including over fullscreen windows, and follows
screen geometry changes. The edge strip scales with DPI and remains transparent.
Restart AwesomeWM after deployment to load the behavior.

```sh
python -m unittest discover -s tests -p test_bar_autohide.py
```

## The Well — Something Answered

A moonlit stone bar with well-ring workspaces, spectral teal accents, and
creeping tentacles, paired with `Moonlit Eldritch Well.png`. Select
`theme-toggle moonlit-well`. See [The Well guide and preview](docs/moonlit-well.md).

## SCP Facility — Security Operations

A gunmetal security dashboard with camera-style workspaces, containment-red
focus indicators, warning amber, and segmented system meters. Paired with the
supplied SCP containment corridor wallpaper. Select `theme-toggle scp-facility`.
See [the SCP Facility guide and preview](docs/scp-facility.md).
