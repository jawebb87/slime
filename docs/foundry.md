# Foundry — Victorian Engine Room

A cast-iron and aged-brass theme inspired by Victorian steam power houses.
Copper details, warm ivory type, patinated green instruments, riveted rails,
Roman numeral workspaces, and a matching Victorian engine-room wallpaper
carry the palette across the desktop.

![The Foundry Desktop](screenshots/foundry.png)

## Mechanical edges

The wibar is a cast assembly with distinct reduction gearboxes joined by a
supported line shaft. Wheels share a common tooth module; pinions mesh with
larger wheels at their pitch radii. Recessed chambers, front flanges, broad
spokes, keyed axle ends, countersunk fasteners, and directional shadows give
the machinery depth. Quiet spans carry bearings and cooling slots.

Window bottoms are thick iron sills with recessed faces, beveled edges, and
two rows of raised rivets. Their rectangular masks keep the bottom edge solid.
Focus changes the edge highlight; fullscreen still hides the decorations.

Metalwork is static and rendered on demand. A shared cache retains at most
24 background surfaces (7 MiB), keyed by dimensions, DPI depth, render mode,
and focus. Up to 32 wheel sprites (1 MiB) and 64 local tooth paths are also
reused during resizing. Sprites render at device DPI. Telemetry redraws reuse
whole backgrounds; no new refresh timers or client signal handlers are installed.

`config/awesome/theme/foundry_shapes.lua` supplies shared masks and paint.
`config/awesome/themes/foundry.lua` sets a 74-pixel bar and a 40-pixel window
bottom titlebar at normal DPI. The bar reserves its full height so windows
stay clear of the teeth. Both dimensions scale with DPI.

## Select the theme

Once installed, run `theme-toggle foundry` (aliases: `industrial`, `victorian`,
`engine-room`, `brass`), or cycle with Super+o. Switching restarts AwesomeWM
and updates the terminal, Rofi, Picom, Starship, Btop, Tmux, GTK preference,
and wallpaper. New Neovim instances and dropdown pads use Foundry colors.

## Artwork and checks

`wallpaper/foundry.png` is the supplied Victorian engine-room wallpaper used
by the theme and switcher. The earlier vector illustration is archived at
`docs/previews/foundry-original.svg`.

Regenerate the Cairo edge preview and run its checks with:

```sh
lua5.3 tools/preview_foundry.lua
python -m unittest discover -s tests -p test_foundry.py -v
```

The geometry test uses Lua 5.3 and lgi/Cairo to check narrow windows and
multiple DPI scales, gear meshing, and bounded cache reuse. The switcher test uses a temporary home and stubs out
commands that affect the desktop. The edge preview is in
[`previews/foundry-edges.png`](previews/foundry-edges.png).
