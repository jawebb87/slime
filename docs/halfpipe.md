# Halfpipe — After Hours

A concrete skatepark workspace with graffiti-green focus accents, faded safety yellow,
chalk lettering, muted sage, and spray-pink alerts. Native Cairo artwork makes the
bar a halfpipe in cross-section: raised quarterpipes at either end flow into a
long flat coping line. The transparent area above the flat remains outside the
bar's input mask, so it does not intercept clicks on the wallpaper.

![Ramp renderer with representative widgets](previews/halfpipe-bar.png)

The detached bar is 94 logical pixels tall, with an 8-pixel top gap and 12-pixel
side insets. Controls occupy the lower flat section, below the coping; 88-pixel
horizontal padding keeps them off the curved ends. The desktop reserves the
bar's full height plus a 12-pixel gap underneath. Geometry follows DPI and screen
resizing. Nine numbered deck graphics retain the standard workspace mouse
bindings; the selected tag becomes a skater grinding the coping, occupied tags
use brighter decks, and urgent tags use pink. The clock is a large 24-hour
scoreboard. Uppercase, bold monospace status labels give the stats a park-signage
style. CPU, memory, network, volume, battery, tray, tasklist, and layout controls
remain functional.

Windows and notifications have clipped panel corners and graffiti-green focus borders.
Terminals, Rofi, Starship, btop, Neovim, tmux, and Python pads share the palette.
Focused windows stay opaque; inactive windows use 87% opacity. Rendering has no
animation timer: the active tag's skater changes with workspace selection.

The supplied graffiti-and-skateboards wallpaper is preserved unmodified in
`wallpaper/halfpipe.png` and installed at `~/Pictures/wallpaper/halfpipe.png`.
AwesomeWM fills the desktop while preserving aspect ratio; different screen
proportions may crop the edges. Green focus accents (`#9cdb45`) and pink alerts
(`#df6094`) echo the spray paint, with charcoal concrete and off-white lettering.

Activate with `theme-toggle halfpipe`; aliases: `skate`, `skatepark`, `ramp`.
Installation leaves the active desktop unchanged.

Checks and preview:

```sh
python -m unittest discover -s tests -p test_halfpipe.py
lua5.3 tools/preview_halfpipe.lua
```

The preview uses production Cairo shapes with representative widget placement;
it is not a live desktop screenshot.
