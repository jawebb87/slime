# Speedster and Crew — Cozy Cartoon Hangout

A warm, vintage cartoon hangout aesthetic with cozy amber lighting, rich timber darks,
and subtle violet dusk undertones, based on the supplied clubhouse illustration.
The original artwork is preserved as `wallpaper/speedster.png` and fills the
desktop with aspect ratio preserved.

![Speedster and Crew Desktop](screenshots/speedster.png)

| Role | Color | Hex Code |
| :--- | :--- | :--- |
| Clubhouse Espresso | Background base | `#140d0d` |
| Warm Chestnut | Surface / card container | `#241513` |
| Elevated Russet | Card & hover state | `#2d1a17` / `#3a211a` |
| Vanilla Cream | Readable text & foreground | `#f9cda7` |
| Radiant Amber Orange | Speedster focus & primary accent | `#cb6d25` |
| Honey Apricot | Warm midtones & secondary accents | `#dd9868` |
| Retro Olive Moss | Earthy status & telemetry | `#605526` |
| Twilight Violet | Night skyline accent & pops | `#8330b7` |
| Hearth Fire Red | Critical alerts & hazard state | `#d93829` |

## Components

- **AwesomeWM**: [`config/awesome/themes/speedster.lua`](../config/awesome/themes/speedster.lua) featuring custom Speedster bar background Cairo renderer in [`config/awesome/theme/slime_shapes.lua`](../config/awesome/theme/slime_shapes.lua), pill widget styling, and companion profile in [`config/awesome/ui/bar.lua`](../config/awesome/ui/bar.lua).
- **Typography**: Uses `ComicShannsMono Nerd Font` across terminals, bar, launcher, and pads.
- **Terminals**: Kitty (`kitty/speedster.conf`), Alacritty (`alacritty/speedster.toml`), LXTerminal (`lxterminal/speedster.conf`).
- **Editor**: Neovim colorscheme (`nvim/colors/speedster.lua`).
- **Shell & Multiplexer**: Starship prompt (`config/starship-speedster.toml`) & Tmux (`config/tmux/themes/speedster.conf`).
- **Compositor & Launcher**: Picom with dual-kawase blur (`config/picom/speedster.conf`) & Rofi launcher (`config/rofi/speedster.rasi`).
- **Pads & Btop**: Centralized Tkinter palette in [`pads/theme.py`](../pads/theme.py) and btop monitor theme (`config/btop/themes/speedster.theme`).
- **Companion CLI & Banner**: `speedster-fetch` and `speedster-pad` terminal dropdown with ASCII banner art.

## Activation

Activate the theme with:
```bash
theme-toggle speedster
```
Aliases: `speedster-crew`, `crew`, `hangout`, `speed`.
Installing the theme leaves the current active desktop unchanged until activated.
