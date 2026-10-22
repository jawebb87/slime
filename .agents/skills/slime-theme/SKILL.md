---
name: slime-theme
description: >-
  Comprehensive guide and runbook for designing, wiring, and verifying complete
  desktop themes within the Slime rice ecosystem on Arch Linux (AwesomeWM, Alacritty,
  Kitty, LXTerminal, Neovim, Tmux, Starship, Picom, Rofi, Btop, Python Tkinter pads).
  Use whenever creating a new theme, designing a palette, or auditing theme parity.
---

# Slime Desktop Theme Creation & Integration Runbook

This skill defines the complete end-to-end standard for creating and wiring desktop themes in the **Slime Rice** ecosystem (`~/Projects/slime`).

Whether designing the visual palette (Codex) or wiring up system components and tests (Antigravity), follow this exact blueprint to ensure zero regressions and 100% theme parity.

---

## 🏛️ Ecosystem Overview & Architecture

Every theme in Slime is a **full-system desktop profile** that simultaneously styles:
1. Window manager (AwesomeWM 4.3 + custom Cairo bar renderer + wibar companion)
2. Terminals (Alacritty, Kitty, LXTerminal)
3. Multiplexer (Tmux statusline)
4. Shell prompt (Starship 2-line prompt with status codes)
5. Editor (Neovim syntax colorscheme)
6. App launcher (Rofi)
7. Compositor (Picom with dual-kawase blur and themed shadows)
8. System monitor (Btop++ theme)
9. Python GUI pads (10 Tkinter dropdown tools in `pads/` and `~/Projects/qtile_bench/`)
10. Terminal fetch & ASCII banner (`bin/<name>-fetch`, `bin/<name>-pad`, `config/fastfetch/`)
11. Desktop switcher (`bin/theme-toggle` + `Super + o`)

---

## 🎨 Stage 1: Design & Palette Extraction

### 1. Palette Extraction from Artwork
When starting from a wallpaper image (typically in `~/Downloads/` or `wallpaper/`):
```bash
# Extract dominant colors and histogram
magick "$IMAGE_PATH" -resize 150x100 -colors 16 -format "%c" histogram:info: | sort -nr
```

### 2. Standard 9-Role Color Architecture
Every theme maps to these semantic color roles:

| Role | Variable | Description & WCAG Rule |
| :--- | :--- | :--- |
| **Background Base** | `bg` | Deepest canvas tone (`#0c...` to `#18...` for dark themes). |
| **Surface Frame** | `bg_surface` / `bg_card` | Slightly elevated container, wibar card, or modal background. |
| **Border Normal** | `border` / `border_normal` | Subtle separator/inactive window border. |
| **Primary Accent** | `border_focus` / `accent` | High-contrast glowing focus border, active tags, cursor. |
| **Secondary Accent** | `border_today` / `accent_2` | Midtone for badges, occupied tags, telemetry curves. |
| **Foreground Text** | `fg` | Primary readable text. **Must maintain ≥ 7:1 contrast against `bg` (WCAG AAA)**. |
| **Muted Text** | `fg_dim` / `shadow_dim` | Comments, inactive tasklist items, subtle clock seconds. |
| **Status / Olive** | `status_running` / `net_ok` | Earthy or vibrant green/teal for active processes and Wi-Fi OK. |
| **Alert / Hazard** | `status_stopped` / `cpu_hot` | Distinct crimson/red for errors, low battery (≤20%), high temps. |

### 3. Typography Convention
- **Cartoon / Cozy / Retro**: `"ComicShannsMono Nerd Font"` (Jon, Muppet, Tunes, Crayon, Speedster).
- **Technical / Cyber / Clean**: `"JetBrainsMono Nerd Font"` (Slime, Cyber, Space, Shred, Lab).
- **Terminal Vintage**: `"BigBlueTermPlus Nerd Font"` (Chomp).

---

## 🔌 Stage 2: The 15-Component Wiring Checklist

### Component 1: Wallpaper
- Copy original to `wallpaper/<theme>.<ext>` inside `~/Projects/slime/`.
- Copy to `~/Pictures/wallpaper/<theme>.<ext>`.
- Format: Prefer `.png` or `.jpg`.

### Component 2: AwesomeWM Bar Background (Cairo Renderer)
- File: [`config/awesome/theme/slime_shapes.lua`](file:///home/jaws/Projects/slime/config/awesome/theme/slime_shapes.lua)
- Define `function slime_shapes.render_<theme>_bar_bg()`:
  - 1. Top-to-bottom gradient (`cairo.Pattern.create_linear(0, 0, 0, h)`).
  - 2. Top subtle highlight rim (`cr:rectangle(0, 0, w, 1)` with accent color).
  - 3. Decorative side accents (left and right sparks, icons, or motifs).
  - 4. Triple-trim bottom rail (distinct multi-line themed accent edge).

### Component 3: AwesomeWM Theme Definition
- File: `config/awesome/themes/<theme>.lua`
- Must export a table with:
  - `name = "<theme>"`
  - `display_name = "<Display Name>"`
  - `narrative_title = "<CAPS TITLE> [<SUBTITLE>]"`
  - `narrative_body = "<Description> (Super+o to cycle)"`
  - `font_family = "<Font Name> Nerd Font"`, `font_size = "10"`
  - `border_width = dpi(2)`, `border_normal`, `border_focus`, `border_marked`
  - `bg_normal`, `bg_focus`, `bg_urgent`, `fg_normal`, `fg_focus`
  - `taglist_bg_focus`, `taglist_fg_focus`, `taglist_bg_occupied`, `taglist_fg_occupied`
  - `palette = { cpu, temp_ok, temp_hot, gpu, sys, net_ok, net_off, vol_ok, bat_ok, ... }`
  - `bar_bgimage = slime_shapes.render_<theme>_bar_bg()`

### Component 4: Bar Companion Profile
- File: [`config/awesome/ui/bar.lua`](file:///home/jaws/Projects/slime/config/awesome/ui/bar.lua)
- In `COMPANION_PROFILES`, register:
  ```lua
  <theme> = {
      prompt_markup = "<span foreground='<accent>' weight='bold'><ICON> [ <PROMPT_TAG> ]</span>",
      label = "<LABEL>", icon = "<ICON> ", accent = "<accent>", bg = "<bg_surface>",
      console = "<theme>-pad",
  },
  ```

### Component 5: Alacritty Terminal (Baseline Size Rule)
- File: `config/alacritty/<theme>.toml`
- **CRITICAL PARITY RULE**: `font.size` MUST be `7.0` (or `6.5` for slime).
- `font.normal = { family = "<Font Name>" }`
- Full 16-color ANSI palette (`[colors.normal]` and `[colors.bright]`).

### Component 6: Kitty Terminal
- File: `config/kitty/<theme>.conf`
- `font_family <Font Name>`
- `font_size 11.0`
- `background_opacity 0.94`, `window_padding_width 10`
- 16 color codes (`color0` through `color15`).

### Component 7: LXTerminal
- File: `config/lxterminal/<theme>.conf`
- `fontname=<Font Name> 11`
- `bgcolor`, `fgcolor`, and `palette_color_0` through `palette_color_15`.

### Component 8: Tmux Theme
- File: `config/tmux/themes/<theme>.conf`
- `set -g status-style "bg=<bg>,fg=<fg>"`
- Themed `status-left` with badge, `status-right` with icon & host, active pane borders.

### Component 9: Rofi Launcher
- File: `config/rofi/<theme>.rasi`
- Must include: `font: "<Font Name> 11";`
- 10px rounded border, matching `@accent` and `@bg-selected`.

### Component 10: Picom Compositor
- File: `config/picom/<theme>.conf`
- `backend = "glx"`, `blur-method = "dual_kawase"`, `blur-strength = 5`.
- Focused opacity `1.0`, unfocused `0.94`, dim `0.10`.
- Themed shadow color and radius 16.

### Component 11: Starship Prompt (Status Error Display Rule)
- File: `config/starship-<theme>.toml`
- **CRITICAL PARITY RULE**: Must include `[status] disabled = false` so exit codes are displayed.
- Palette table `[palettes.<theme>]` matching the theme.

### Component 12: Neovim Colorscheme
- File: `config/nvim/colors/<theme>.lua`
- **CRITICAL PARITY RULE**: Must set `vim.g.colors_name = "<theme>"` and define `Normal = { fg = c.fg, bg = c.bg }`.
- Full syntax highlight groups: `Comment`, `String`, `Function`, `Keyword`, `Operator`, `PmenuSel`, `DiffAdd`, etc.

### Component 13: Btop System Monitor
- File: `config/btop/themes/<theme>.theme`
- Matching `main_bg`, `main_fg`, `title`, box outlines, temperature gradient, and graph colors.

### Component 14: Centralized Python Tkinter Pads
- File: [`pads/theme.py`](file:///home/jaws/Projects/slime/pads/theme.py) (and mirror to `~/Projects/qtile_bench/theme.py`)
- Define `<THEME>_THEME = { ... }` with all 24 UI keys and `"font": "<Font Name>"`.
- In `get_active_theme()`:
  ```python
  if mode in ("<theme>", "<alias1>", "<alias2>"):
      return <THEME>_THEME
  ```

### Component 15: Fastfetch & Companion Scripts
- Banner art: `config/fastfetch/<theme>.ans` (generated via `chafa` from wallpaper).
- Companion fetch: `bin/<theme>-fetch` (executable Python script with TrueColor ANSI sysinfo).
- Companion pad: `bin/<theme>-pad` (executable bash script launching fetch + interactive shell).

### Component 16: Switcher Registration & Aliases
- File: [`bin/theme-toggle`](file:///home/jaws/Projects/slime/bin/theme-toggle)
  1. Add `"<theme>"` to `CANONICAL=( ... )` list.
  2. Add target case alias:
     ```bash
     <theme>|<alias1>|<alias2>)
         TARGET="<theme>"
         ;;
     ```

### Component 17: Theme Documentation
- File: `docs/<theme>.md`
- Document palette table, aesthetic concept, components, and activation command.

---

## 🧪 Stage 3: Verification & Parity Testing

Before finishing, ALWAYS execute the automated test suites:

```bash
# 1. Run the strict cross-theme parity test
cd ~/Projects/slime && python -m unittest discover -s tests -p 'test_theme_parity.py'

# 2. Run the full test suite
cd ~/Projects/slime && python -m unittest discover -s tests
```

What `test_theme_parity.py` verifies automatically:
1. `theme-toggle <theme>` successfully copies all terminal, editor, starship, and rofi configs into place.
2. Terminal font size equals 7.0 (or 6.5 for slime).
3. Neovim loads the scheme headlessly without errors and exports a valid `Normal` foreground.
4. Font chooser pad discovers the new theme and can dynamically retune its font.
5. Persistent console shell opens with the theme's title without fallback errors.
6. Desktop shortcut keybindings contain zero conflicts.

---

## 🚀 Stage 4: Deployment

To make the theme available for immediate live testing without interrupting the currently active desktop:

```bash
# Copy theme configurations to live ~/.config/
cp ~/Projects/slime/config/awesome/themes/<theme>.lua ~/.config/awesome/themes/
cp ~/Projects/slime/config/awesome/theme/slime_shapes.lua ~/.config/awesome/theme/
cp ~/Projects/slime/config/awesome/ui/bar.lua ~/.config/awesome/ui/
cp ~/Projects/slime/config/alacritty/<theme>.toml ~/.config/alacritty/
cp ~/Projects/slime/config/kitty/<theme>.conf ~/.config/kitty/
cp ~/Projects/slime/config/lxterminal/<theme>.conf ~/.config/lxterminal/
cp ~/Projects/slime/config/tmux/themes/<theme>.conf ~/.config/tmux/themes/
cp ~/Projects/slime/config/rofi/<theme>.rasi ~/.config/rofi/
cp ~/Projects/slime/config/picom/<theme>.conf ~/.config/picom/
cp ~/Projects/slime/config/starship-<theme>.toml ~/.config/
cp ~/Projects/slime/config/nvim/colors/<theme>.lua ~/.config/nvim/colors/
cp ~/Projects/slime/config/btop/themes/<theme>.theme ~/.config/btop/themes/
cp ~/Projects/slime/config/fastfetch/<theme>.ans ~/.config/fastfetch/

# Deploy user binaries & pad themes
cp ~/Projects/slime/bin/<theme>-fetch ~/.local/bin/
cp ~/Projects/slime/bin/<theme>-pad ~/.local/bin/
cp ~/Projects/slime/bin/theme-toggle ~/.local/bin/
chmod +x ~/.local/bin/<theme>-fetch ~/.local/bin/<theme>-pad ~/.local/bin/theme-toggle
cp ~/Projects/slime/pads/theme.py ~/Projects/qtile_bench/theme.py

# Verify theme-toggle lists it
theme-toggle list
```

Activate at will with:
```bash
theme-toggle <theme>
```
