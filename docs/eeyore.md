# Eeyore — Watercolor Sky

Based on `Eeyore Beneath a Watercolor Sky.png`, preserved without modification
as `wallpaper/eeyore.png`. The wallpaper fills the desktop with its aspect ratio
preserved; screen proportions may crop the edges.

| Role | Color |
| --- | --- |
| Cloud background | `#f3f6f3` |
| Floating bar | `#eef5f4f2` |
| Slate text | `#34444e` |
| Sky blue focus | `#326d8b` |
| Sage | `#59784b` |
| Muted plum | `#775c83` |
| Soft rose alerts | `#a34f69` |

The detached top bar is 44 logical pixels high, inset 20 pixels from either side
and 12 pixels below the screen edge, with 16-pixel corner radii. A 12-pixel gap
below the bar separates it from tiled windows. Dimensions follow Awesome's DPI
setting. Placement follows monitor geometry changes and handles offset screens.

Its compact layout keeps the launcher, nine workspaces, tasklist, network,
volume, battery, tray, clock, and layout switcher. CPU and system telemetry
remain available in the other themes and through the existing btop shortcut.
The bar uses Noto Sans with borderless status pills. Unfocused application
windows use 90% opacity; focused windows remain opaque.

Includes AwesomeWM, Kitty, Alacritty, LXTerminal, tmux, Rofi, Picom, Starship,
btop, Neovim, Python pads, and the existing switcher's light GTK preference.

Activate with `theme-toggle eeyore`. Aliases: `watercolor`, `watercolor-sky`.
Installation does not switch the active desktop.

Validation:

```sh
python -m unittest discover -s tests -p test_eeyore.py
python -m unittest discover -s tests -p test_desktop_regressions.py
```
