# Sketchbook — notes in progress

A light mixed media theme built around the supplied hedgehog illustration.
The original image is preserved in `wallpaper/sketchbook.png`.

Warm paper (`#faf4e7`), graphite (`#343b39`), watercolor teal (`#276c67`),
mushroom amber (`#86591f`), and dusty rose (`#994b58`) keep text legible.
Opaque terminal and panel surfaces prevent the detailed wallpaper from competing
with text. The 38px bar adds sparse watercolor washes and broken pencil rules;
workspace tags, tasks, and telemetry use clipped paper corners. Decoration stays
behind content and uses the existing controls and hit areas.

Includes AwesomeWM, Kitty, Alacritty, LXTerminal, tmux, Rofi, Picom, Starship,
btop, Neovim, and Python dropdown pad palettes. GTK uses the existing light
Adwaita selection through the theme switcher's `is_light` detection.

After deploying the configuration and wallpaper through the project's normal
restore workflow, run `theme-toggle sketchbook`. The theme is discovered
automatically. Implementation does not change the active theme or live settings.
The restore workflow applies all repository changes, so review those first.

Validation: Lua syntax checks, Python AST parsing, TOML parsing, four desktop
regression tests, and Cairo bar rendering at 320×38, 1920×38, and 3840×76.
The rendered bar is in `docs/previews/sketchbook-bar.png`. Live desktop
interaction and screenshot validation remain to be performed after activation.
