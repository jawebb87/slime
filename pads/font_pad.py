#!/usr/bin/env python3
"""Font selector for every installed modular desktop theme.
Updates AwesomeWM, Alacritty, Kitty, LXTerminal, Rofi, GTK and scratchpads.
Theme selection cycles with m; Tab filters fonts; brackets adjust terminal size.
"""

import os
import re
import sys
import subprocess
import json
import shutil
import tomllib
from pathlib import Path
import tkinter as tk

# ==============================================================================
# Theme: Central Slime / Laboratory White (via Super + o)
# ==============================================================================
try:
    sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
    from theme import get_theme
    THEME = get_theme()
except Exception:
    THEME = {
        "bg": "#0c140d", "bg_surface": "#122015", "bg_card": "#16281a",
        "bg_hover": "#1f3a24", "bg_active": "#25482b", "bg_selected": "#1f3a24",
        "border": "#27482d", "border_focus": "#55f736", "border_today": "#d8eb34",
        "fg": "#c6f582", "fg_dim": "#6f9976", "fg_header": "#f0ffcd",
        "key_bg": "#122015", "key_fg": "#d8eb34",
        "status_running": "#4ee24e", "status_stopped": "#ff4343",
        "status_paused": "#d8eb34", "accent_blue": "#36e385",
        "accent_aqua": "#55ffaa", "accent_green": "#4ee24e",
        "accent_yellow": "#d8eb34", "accent_orange": "#e5ff4d",
        "accent_purple": "#7cb324", "accent_red": "#ff4343",
        "font": "MartianMono Nerd Font",
    }

HOME = os.path.expanduser("~")
MODE_FILE = os.path.join(HOME, ".config/awesome/theme_mode")
THEMES_DIR = os.path.join(HOME, ".config/awesome/themes")
BENCH_THEME = os.path.join(HOME, "Projects/qtile_bench/theme.py")


def discover_themes() -> list[str]:
    return sorted(p.stem for p in Path(THEMES_DIR).glob("*.lua")
                  if p.stem != "template" and not p.stem.startswith("_")) or ["slime"]


def get_active_mode() -> str:
    try:
        mode = Path(MODE_FILE).read_text().strip()
        if mode in discover_themes():
            return mode
    except OSError:
        pass
    return "slime"


def get_theme_font_config(mode: str) -> tuple[str, float]:
    family, size = "JetBrainsMono Nerd Font", 7.0
    try:
        content = (Path(THEMES_DIR) / f"{mode}.lua").read_text()
        match = re.search(r'font_family\s*=\s*"([^"\n]+)"', content)
        if match:
            family = match[1]
    except OSError:
        pass
    try:
        data = tomllib.loads((Path(HOME) / f".config/alacritty/{mode}.toml").read_text())
        size = float(data["font"]["size"])
    except (OSError, ValueError, KeyError):
        pass
    return family, size


def update_terminal_fonts(mode: str, family: str, size: float):
    """Update each terminal's named profile; callers handle live copies separately."""
    base = Path(HOME) / ".config"
    path = base / "alacritty" / f"{mode}.toml"
    if path.exists():
        text = path.read_text()
        text = re.sub(r'(?ms)(^\[font\]\n)(.*?)(?=^\[|\Z)',
                      lambda m: m[1] + re.sub(r'(?m)^size\s*=.*$', f'size = {size:g}', m[2]), text)
        text = re.sub(r'(family\s*=\s*)"(?:[^"\\]|\\.)*"',
                      lambda m: m[1] + json.dumps(family), text)
        path.write_text(text)
    path = base / "lxterminal" / f"{mode}.conf"
    if path.exists():
        path.write_text(re.sub(r'(?m)^fontname=.*$', lambda _: f'fontname={family} {size:g}', path.read_text()))


def discover_fonts() -> tuple[list[dict], set[str]]:
    """Query fontconfig for installed font families and track spacing=100 families for Kitty."""
    fonts_map = {}
    mono_100 = set()
    try:
        out = subprocess.check_output(
            ["fc-list", ":", "family", "spacing"],
            text=True,
            stderr=subprocess.DEVNULL,
            timeout=5,
        )
        for line in out.splitlines():
            parts = line.split(":")
            fams = [x.strip() for x in parts[0].split(",") if x.strip()]
            if not fams:
                continue
            has_100 = "spacing=100" in line
            if has_100:
                for f in fams:
                    mono_100.add(f)

            primary = fams[0]
            if primary.startswith("."):
                continue
            is_nerd = "Nerd Font" in primary
            is_mono = (
                has_100
                or "spacing=90" in line
                or any(k in primary for k in ("Mono", "Term", "Code", "Console", "Fixed"))
            )
            prev_nerd, prev_mono = fonts_map.get(primary, (False, False))
            fonts_map[primary] = (prev_nerd or is_nerd, prev_mono or is_mono)
    except Exception:
        fonts_map["MartianMono Nerd Font"] = (True, True)
        mono_100.add("MartianMono Nerd Font")

    result = []
    for name in sorted(fonts_map.keys(), key=lambda s: s.lower()):
        is_nerd, is_mono = fonts_map[name]
        is_base_nerd = (
            is_nerd
            and not name.endswith("Nerd Font Mono")
            and not name.endswith("Nerd Font Propo")
        )
        result.append({
            "name": name,
            "is_nerd": is_nerd,
            "is_base_nerd": is_base_nerd,
            "is_mono": is_mono,
        })
    return result, mono_100


def resolve_kitty_font(fam: str, mono_100: set[str]) -> str:
    """
    Resolve a font family name to its `spacing=100` monospace family required by Kitty.
    Kitty strictly ignores proportional or spacing=90 fonts in `font_family`.
    """
    if fam in mono_100:
        return fam

    candidates = [
        f"{fam} Mono",
        fam.replace(" Nerd Font", "M Nerd Font Mono"),
        fam.replace(" Nerd Font", "Mono Nerd Font Mono"),
        fam.replace(" Nerd Font", "Mono Nerd Font"),
        fam.replace(" Propo", " Mono"),
        fam.replace(" Propo", ""),
    ]
    for c in candidates:
        if c in mono_100:
            return c

    prefix = fam.split(" Nerd Font")[0].split()[0]
    if len(prefix) >= 3:
        for m in sorted(mono_100):
            if m.lower().startswith(prefix.lower()):
                return m
    return fam


class FontPadApp:
    """Graphical Per-Theme Font Selector & Config Populator."""

    FILTER_MODES = [
        ("nerd", "Nerd Fonts (Recommended)"),
        ("mono", "Monospace Fonts"),
        ("all", "All System Fonts"),
    ]

    def __init__(self, root: tk.Tk):
        self.root = root
        self.root.title("Desktop Per-Theme Font Selector")
        self.root.configure(bg=THEME["bg"])

        try:
            self.root.wm_attributes("-type", "dialog")
        except Exception:
            pass

        sw = self.root.winfo_screenwidth()
        sh = self.root.winfo_screenheight()
        target_w = min(1380, int(sw * 0.80))
        target_h = min(850, int(sh * 0.85))
        self.root.geometry(f"{target_w}x{target_h}")

        self.active_mode = get_active_mode()
        self.target_mode = self.active_mode  # A discovered theme name or "all"

        self.theme_fonts = {name: list(get_theme_font_config(name)) for name in discover_themes()}
        if self.active_mode not in self.theme_fonts:
            self.active_mode = next(iter(self.theme_fonts))
            self.target_mode = self.active_mode

        self.ui_font = THEME.get("font", "MartianMono Nerd Font")
        self.all_fonts, self.mono_100 = discover_fonts()
        self.filtered_fonts = []
        self.filter_mode_idx = 0

        cur_fam, cur_size = self.theme_fonts[self.active_mode]
        self.selected_font = cur_fam
        self.base_size = cur_size

        self._build_header()
        self._build_main_panes()
        self._build_footer()
        self._bind_keys()

        self._update_target_button()
        self._apply_filter(select_current=True)
        self.listbox.focus_set()

    # ==========================================================================
    # UI Construction
    # ==========================================================================
    def _build_header(self):
        header = tk.Frame(
            self.root,
            bg=THEME["bg_card"],
            bd=0,
            highlightthickness=1,
            highlightbackground=THEME["border"],
        )
        header.pack(fill="x", padx=12, pady=(12, 6), ipady=8)

        # Title
        title_box = tk.Frame(header, bg=THEME["bg_card"])
        title_box.pack(side="left", padx=14)

        tk.Label(
            title_box,
            text="\uf031",
            font=(self.ui_font, 15),
            fg=THEME["key_fg"],
            bg=THEME["bg_card"],
        ).pack(side="left", padx=(0, 8))

        tk.Label(
            title_box,
            text="FONT SELECTOR",
            font=(self.ui_font, 12, "bold"),
            fg=THEME["fg_header"],
            bg=THEME["bg_card"],
        ).pack(side="left")

        # Search input
        search_frame = tk.Frame(
            header,
            bg=THEME["bg_surface"],
            bd=1,
            highlightthickness=1,
            highlightbackground=THEME["border"],
        )
        search_frame.pack(side="left", fill="x", expand=True, padx=14, ipady=3)

        tk.Label(
            search_frame,
            text="\uf002",
            font=(self.ui_font, 10),
            fg=THEME["fg_dim"],
            bg=THEME["bg_surface"],
        ).pack(side="left", padx=(8, 4))

        self.search_var = tk.StringVar()
        self.search_var.trace_add("write", lambda *_: self._apply_filter())

        self.search_entry = tk.Entry(
            search_frame,
            textvariable=self.search_var,
            font=(self.ui_font, 11),
            fg=THEME["fg"],
            bg=THEME["bg_surface"],
            insertbackground=THEME["key_fg"],
            bd=0,
            highlightthickness=0,
        )
        self.search_entry.pack(side="left", fill="x", expand=True, padx=6)

        # Controls: Target Theme Button + Filter Mode Button + Size Controls + Apply Button
        ctrl_box = tk.Frame(header, bg=THEME["bg_card"])
        ctrl_box.pack(side="right", padx=12)

        self.btn_target = tk.Button(
            ctrl_box,
            text="",
            font=(self.ui_font, 9, "bold"),
            fg=THEME["accent_aqua"],
            bg=THEME["key_bg"],
            activebackground=THEME["bg_active"],
            activeforeground=THEME["fg_header"],
            bd=0,
            padx=10,
            pady=4,
            cursor="hand2",
            command=self.cycle_target_mode,
        )
        self.btn_target.pack(side="left", padx=(0, 8))

        self.btn_filter = tk.Button(
            ctrl_box,
            text="",
            font=(self.ui_font, 9, "bold"),
            fg=THEME["key_fg"],
            bg=THEME["key_bg"],
            activebackground=THEME["bg_active"],
            activeforeground=THEME["fg_header"],
            bd=0,
            padx=10,
            pady=4,
            cursor="hand2",
            command=self.cycle_filter_mode,
        )
        self.btn_filter.pack(side="left", padx=(0, 8))

        # Size stepper
        size_box = tk.Frame(ctrl_box, bg=THEME["bg_surface"], highlightthickness=1, highlightbackground=THEME["border"])
        size_box.pack(side="left", padx=(0, 8))

        tk.Button(
            size_box,
            text=" - ",
            font=(self.ui_font, 9, "bold"),
            fg=THEME["fg"],
            bg=THEME["bg_hover"],
            activebackground=THEME["bg_active"],
            bd=0,
            padx=6,
            pady=3,
            cursor="hand2",
            command=lambda: self.adjust_size(-0.5),
        ).pack(side="left")

        self.lbl_size = tk.Label(
            size_box,
            text=f" {self.base_size:g} pt ",
            font=(self.ui_font, 9, "bold"),
            fg=THEME["accent_aqua"],
            bg=THEME["bg_surface"],
            padx=6,
        )
        self.lbl_size.pack(side="left")

        tk.Button(
            size_box,
            text=" + ",
            font=(self.ui_font, 9, "bold"),
            fg=THEME["fg"],
            bg=THEME["bg_hover"],
            activebackground=THEME["bg_active"],
            bd=0,
            padx=6,
            pady=3,
            cursor="hand2",
            command=lambda: self.adjust_size(0.5),
        ).pack(side="left")

        # Apply button
        self.btn_apply = tk.Button(
            ctrl_box,
            text="✔ Apply (Enter)",
            font=(self.ui_font, 9, "bold"),
            fg=THEME["bg"],
            bg=THEME["status_running"],
            activebackground=THEME["accent_yellow"],
            activeforeground=THEME["bg"],
            bd=0,
            padx=12,
            pady=4,
            cursor="hand2",
            command=self.apply_selected_font,
        )
        self.btn_apply.pack(side="left")

    def _build_main_panes(self):
        body = tk.Frame(self.root, bg=THEME["bg"])
        body.pack(fill="both", expand=True, padx=12, pady=4)

        # Left pane: Font Family Listbox
        left_card = tk.Frame(
            body,
            bg=THEME["bg_card"],
            width=430,
            highlightthickness=1,
            highlightbackground=THEME["border"],
        )
        left_card.pack(side="left", fill="y", padx=(0, 8))
        left_card.pack_propagate(False)

        left_hdr = tk.Frame(left_card, bg=THEME["bg_card"])
        left_hdr.pack(fill="x", padx=10, pady=(8, 4))

        tk.Label(
            left_hdr,
            text="INSTALLED FAMILIES",
            font=(self.ui_font, 9, "bold"),
            fg=THEME["fg_dim"],
            bg=THEME["bg_card"],
        ).pack(side="left")

        self.lbl_count = tk.Label(
            left_hdr,
            text="0 fonts",
            font=(self.ui_font, 9, "bold"),
            fg=THEME["accent_blue"],
            bg=THEME["key_bg"],
            padx=6,
            pady=1,
        )
        self.lbl_count.pack(side="right")

        list_container = tk.Frame(left_card, bg=THEME["bg_surface"])
        list_container.pack(fill="both", expand=True, padx=8, pady=(0, 8))

        self.scrollbar = tk.Scrollbar(
            list_container,
            orient="vertical",
            bg=THEME["bg_card"],
            troughcolor=THEME["bg_surface"],
            activebackground=THEME["accent_blue"],
            bd=0,
            width=10,
        )
        self.listbox = tk.Listbox(
            list_container,
            font=(self.ui_font, 10),
            fg=THEME["fg"],
            bg=THEME["bg_surface"],
            selectbackground=THEME["bg_active"],
            selectforeground=THEME["fg_header"],
            activestyle="none",
            bd=0,
            highlightthickness=0,
            yscrollcommand=self.scrollbar.set,
            exportselection=False,
        )
        self.scrollbar.config(command=self.listbox.yview)
        self.listbox.pack(side="left", fill="both", expand=True, padx=4, pady=4)
        self.scrollbar.pack(side="right", fill="y")

        self.listbox.bind("<<ListboxSelect>>", self._on_listbox_select)
        self.listbox.bind("<Double-Button-1>", lambda _e: self.apply_selected_font())

        # Right pane: Live Preview & Target Config Breakdown
        right_card = tk.Frame(
            body,
            bg=THEME["bg_card"],
            highlightthickness=1,
            highlightbackground=THEME["border"],
        )
        right_card.pack(side="left", fill="both", expand=True)

        # Selected font banner
        banner = tk.Frame(right_card, bg=THEME["bg_surface"], highlightthickness=1, highlightbackground=THEME["border"])
        banner.pack(fill="x", padx=12, pady=12, ipady=6)

        self.lbl_preview_title = tk.Label(
            banner,
            text=self.selected_font,
            font=(self.selected_font, 15, "bold"),
            fg=THEME["fg_header"],
            bg=THEME["bg_surface"],
            anchor="w",
        )
        self.lbl_preview_title.pack(side="left", padx=12)

        self.lbl_active_badge = tk.Label(
            banner,
            text="",
            font=(self.ui_font, 9, "bold"),
            fg=THEME["status_running"],
            bg=THEME["key_bg"],
            padx=8,
            pady=3,
        )
        self.lbl_active_badge.pack(side="right", padx=12)

        # Specimen Card 1: Alphabet, Digits & Symbols
        spec_card = tk.Frame(right_card, bg=THEME["bg_surface"], highlightthickness=1, highlightbackground=THEME["border"])
        spec_card.pack(fill="x", padx=12, pady=(0, 10))

        tk.Label(
            spec_card,
            text="TYPOGRAPHY & GLYPH SPECIMEN",
            font=(self.ui_font, 8, "bold"),
            fg=THEME["fg_dim"],
            bg=THEME["bg_surface"],
            anchor="w",
        ).pack(fill="x", padx=12, pady=(8, 2))

        specimen_text = (
            "ABCDEFGHIJKLMNOPQRSTUVWXYZ  abcdefghijklmnopqrstuvwxyz\n"
            "0123456789   !@#$%^&*()_+-=[]{}|;':\",./<>?`~   Il1O0S5Z2\n"
            "The quick brown fox jumps over a lazy dog. Pack my box with five dozen liquor jugs.\n"
            "Icons: \uf120 Term   \uf11c Keys   \uf028 Audio   \uf1eb WiFi   \uf240 Bat   \uf0e7 Power   \uf135 Launch"
        )
        self.lbl_specimen = tk.Label(
            spec_card,
            text=specimen_text,
            font=(self.selected_font, int(round(self.base_size))),
            fg=THEME["fg"],
            bg=THEME["bg_surface"],
            justify="left",
            anchor="w",
        )
        self.lbl_specimen.pack(fill="x", padx=12, pady=(2, 10))

        # Specimen Card 2: Terminal / Code Sample
        code_card = tk.Frame(right_card, bg=THEME["bg_surface"], highlightthickness=1, highlightbackground=THEME["border"])
        code_card.pack(fill="both", expand=True, padx=12, pady=(0, 10))

        tk.Label(
            code_card,
            text="TERMINAL & CODE PREVIEW (KITTY MONOSPACE)",
            font=(self.ui_font, 8, "bold"),
            fg=THEME["fg_dim"],
            bg=THEME["bg_surface"],
            anchor="w",
        ).pack(fill="x", padx=12, pady=(8, 2))

        code_sample = (
            "[NET//LINK] ❯ jaws:~/Projects/slime (git:main) ⚡\n"
            "❯❯ ./sync.sh --backup && theme-toggle\n\n"
            "def configure_theme_font(mode: str, font: str, size: float = 10.5) -> bool:\n"
            "    weights = [100, 400, 700]  # != === -> => :: <= >= ~= // /* */\n"
            "    return all(w >= 100 and font != \"\" for w in weights)"
        )
        self.lbl_code = tk.Label(
            code_card,
            text=code_sample,
            font=(resolve_kitty_font(self.selected_font, self.mono_100), int(round(self.base_size))),
            fg=THEME["accent_aqua"],
            bg=THEME["bg_surface"],
            justify="left",
            anchor="nw",
        )
        self.lbl_code.pack(fill="both", expand=True, padx=12, pady=(2, 10))

        # Target Configs Summary Card
        targets_card = tk.Frame(right_card, bg=THEME["bg_surface"], highlightthickness=1, highlightbackground=THEME["border"])
        targets_card.pack(fill="x", padx=12, pady=(0, 12))

        tk.Label(
            targets_card,
            text="PER-THEME CONFIGURATIONS POPULATED ON APPLY",
            font=(self.ui_font, 8, "bold"),
            fg=THEME["key_fg"],
            bg=THEME["bg_surface"],
            anchor="w",
        ).pack(fill="x", padx=12, pady=(8, 4))

        self.lbl_targets = tk.Label(
            targets_card,
            text="",
            font=(self.ui_font, 9),
            fg=THEME["fg"],
            bg=THEME["bg_surface"],
            justify="left",
            anchor="w",
        )
        self.lbl_targets.pack(fill="x", padx=12, pady=(0, 8))

    def _build_footer(self):
        footer = tk.Frame(
            self.root,
            bg=THEME["bg_card"],
            bd=0,
            highlightthickness=1,
            highlightbackground=THEME["border"],
        )
        footer.pack(fill="x", side="bottom", padx=12, pady=(4, 12), ipady=5)

        hints = [
            ("j/k / ↑↓", "Navigate"),
            ("Enter", "Apply"),
            ("m", "Target Theme"),
            ("/", "Search"),
            ("Tab", "Filter"),
            ("[ / ]", "Size"),
            ("Esc / q", "Close"),
        ]
        for key, desc in hints:
            pill = tk.Frame(footer, bg=THEME["bg_card"])
            pill.pack(side="left", padx=5)

            tk.Label(
                pill,
                text=key,
                font=(self.ui_font, 8, "bold"),
                fg=THEME["key_fg"],
                bg=THEME["key_bg"],
                padx=6,
                pady=2,
            ).pack(side="left")

            tk.Label(
                pill,
                text=desc,
                font=(self.ui_font, 8),
                fg=THEME["fg_dim"],
                bg=THEME["bg_card"],
                padx=3,
            ).pack(side="left")

        self.lbl_toast = tk.Label(
            footer,
            text="",
            font=(self.ui_font, 9, "bold"),
            fg=THEME["accent_aqua"],
            bg=THEME["bg_card"],
            padx=12,
        )
        self.lbl_toast.pack(side="right")
        self._update_footer_status()

    def _update_footer_status(self):
        family, size = self.theme_fonts[self.active_mode]
        self.lbl_toast.configure(
            text=f"{self.active_mode}: {family} ({size:g}pt) • {len(self.theme_fonts)} themes",
            fg=THEME["accent_aqua"],
        )

    # ==========================================================================
    # Target Theme, Filtering, Selection & Live Preview
    # ==========================================================================
    def cycle_target_mode(self):
        order = [*self.theme_fonts, "all"]
        idx = (order.index(self.target_mode) + 1) % len(order) if self.target_mode in order else 0
        self.target_mode = order[idx]
        if self.target_mode in self.theme_fonts:
            fam, sz = self.theme_fonts[self.target_mode]
            self.selected_font = fam
            self.base_size = sz
            self.lbl_size.configure(text=f" {self.base_size:g} pt ")
        self._update_target_button()
        self._apply_filter(select_current=True)

    def _update_target_button(self):
        self.btn_target.configure(text=f"🎯 Target: {self.target_mode.upper()} (m)")

    def cycle_filter_mode(self):
        self.filter_mode_idx = (self.filter_mode_idx + 1) % len(self.FILTER_MODES)
        self._apply_filter()

    def adjust_size(self, delta: float):
        self.base_size = max(6.0, min(20.0, round((self.base_size + delta) * 2) / 2))
        self.lbl_size.configure(text=f" {self.base_size:g} pt ")
        self._update_preview()

    def _apply_filter(self, select_current: bool = False):
        mode_key, mode_label = self.FILTER_MODES[self.filter_mode_idx]
        self.btn_filter.configure(text=f"\uf0b0 {mode_label}")

        query = self.search_var.get().strip().lower()
        self.filtered_fonts = []

        for f in self.all_fonts:
            if mode_key == "nerd" and not f["is_base_nerd"]:
                continue
            if mode_key == "mono" and not (f["is_mono"] or f["is_nerd"]):
                continue
            if query and query not in f["name"].lower():
                continue
            self.filtered_fonts.append(f["name"])

        self.listbox.delete(0, "end")
        for name in self.filtered_fonts:
            badges = [mode.upper() for mode, (family, _) in self.theme_fonts.items() if name == family]
            suffix = f"  [{', '.join(badges)}]" if badges else ""
            prefix = "★ " if badges else "  "
            self.listbox.insert("end", f"{prefix}{name}{suffix}")

        self.lbl_count.configure(text=f"{len(self.filtered_fonts)} fonts")

        if not self.filtered_fonts:
            return

        if select_current:
            ref_mode = self.active_mode if self.target_mode == "all" else self.target_mode
            target = self.theme_fonts[ref_mode][0]
        else:
            target = self.selected_font

        idx = 0
        if target in self.filtered_fonts:
            idx = self.filtered_fonts.index(target)

        self.listbox.selection_clear(0, "end")
        self.listbox.selection_set(idx)
        self.listbox.activate(idx)
        self.listbox.see(idx)
        self.selected_font = self.filtered_fonts[idx]
        self._update_preview()

    def _on_listbox_select(self, _event=None):
        sel = self.listbox.curselection()
        if not sel:
            return
        idx = sel[0]
        if 0 <= idx < len(self.filtered_fonts):
            self.selected_font = self.filtered_fonts[idx]
            self._update_preview()

    def _update_preview(self):
        fam = self.selected_font
        kitty_fam = resolve_kitty_font(fam, self.mono_100)
        pt = int(round(self.base_size))
        awesome_pt = max(7, int(round(self.base_size - 1.5)))
        rofi_pt = max(8, int(round(self.base_size - 0.5)))

        self.lbl_preview_title.configure(text=fam, font=(fam, 15, "bold"))

        badges = [mode.upper() + " FONT" for mode, (family, _) in self.theme_fonts.items() if fam == family]
        if badges:
            self.lbl_active_badge.configure(text=" • ".join(badges), fg=THEME["status_running"])
        else:
            self.lbl_active_badge.configure(
                text=f"PREVIEWING FOR {self.target_mode.upper()}",
                fg=THEME["key_fg"],
            )

        self.lbl_specimen.configure(font=(fam, pt))
        self.lbl_code.configure(font=(kitty_fam, pt))

        modes_str = "all installed themes" if self.target_mode == "all" else self.target_mode
        targets_info = (
            f"  • Target Theme Mode                         :  {modes_str.upper()}\n"
            f"  • Alacritty / Kitty / LXTerminal ({modes_str})              :  font_family {kitty_fam}  ({self.base_size:g} pt)\n"
            f"  • AwesomeWM (themes/{modes_str}.lua)            :  {fam} {awesome_pt} / Bold {awesome_pt}\n"
            f"  • Rofi & GTK ({modes_str}.rasi / settings.ini)   :  {fam} {rofi_pt}\n"
            f"  • Python Scratchpads (theme.py)             :  {modes_str.upper()}_THEME[\"font\"] = \"{fam}\""
        )
        self.lbl_targets.configure(text=targets_info)

    # ==========================================================================
    # Config Population & Live Reload
    # ==========================================================================
    def apply_selected_font(self):
        fam = self.selected_font
        if not fam:
            return

        fam_clean = fam.replace('"', '').replace("\\", "").replace('\n', '').replace('\r', '')
        kitty_fam = resolve_kitty_font(fam_clean, self.mono_100).replace('\n', '').replace('\r', '')
        kitty_size = f"{self.base_size:g}"
        awesome_size = str(max(7, int(round(self.base_size - 1.5))))
        rofi_size = str(max(8, int(round(self.base_size - 0.5))))

        modes_to_update = list(self.theme_fonts) if self.target_mode == "all" else [self.target_mode]
        active_updated = self.active_mode in modes_to_update

        try:
            for m in modes_to_update:
                self.theme_fonts[m] = [fam_clean, self.base_size]

                # 1. Terminal profiles
                kpath = os.path.join(HOME, ".config/kitty", f"{m}.conf")
                if os.path.exists(kpath):
                    with open(kpath, "r", encoding="utf-8") as f:
                        content = f.read()
                    content = re.sub(r"(?m)^font_family\s+.*$", lambda _: f"font_family      {kitty_fam}", content)
                    content = re.sub(r"(?m)^font_size\s+.*$", lambda _: f"font_size        {kitty_size}", content)
                    with open(kpath, "w", encoding="utf-8") as f:
                        f.write(content)

                update_terminal_fonts(m, kitty_fam, self.base_size)

                # 2. Rofi per-theme profile
                rpath = os.path.join(HOME, ".config/rofi", f"{m}.rasi")
                if os.path.exists(rpath):
                    with open(rpath, "r", encoding="utf-8") as f:
                        content = f.read()
                    content = re.sub(
                        r'(?m)^(\s*font:\s*").*(";\s*)$',
                        lambda match: f"{match.group(1)}{fam_clean} {rofi_size}{match.group(2)}",
                        content,
                    )
                    with open(rpath, "w", encoding="utf-8") as f:
                        f.write(content)

                # 3. Modular AwesomeWM theme
                awesome_theme = os.path.join(THEMES_DIR, f"{m}.lua")
                if os.path.exists(awesome_theme):
                    with open(awesome_theme, "r", encoding="utf-8") as f:
                        content = f.read()
                    content = re.sub(
                        r'(?m)^(\s*font_family\s*=\s*")[^"]*(")',
                        lambda match: f"{match.group(1)}{fam_clean}{match.group(2)}",
                        content,
                    )
                    content = re.sub(
                        r'(?m)^(\s*font_size\s*=\s*")[^"]*(")',
                        lambda match: f"{match.group(1)}{awesome_size}{match.group(2)}",
                        content,
                    )
                    with open(awesome_theme, "w", encoding="utf-8") as f:
                        f.write(content)

                # 4. Matching Python scratchpad palette
                if os.path.exists(BENCH_THEME):
                    with open(BENCH_THEME, "r", encoding="utf-8") as f:
                        content = f.read()
                    block_name = m.upper().replace("-", "_") + "_THEME"
                    content = re.sub(
                        rf'({block_name}\s*=\s*\{{[^}}]*?"font":\s*")[^"]+(")',
                        lambda match: f"{match.group(1)}{fam_clean}{match.group(2)}",
                        content,
                        flags=re.DOTALL,
                    )
                    with open(BENCH_THEME, "w", encoding="utf-8") as f:
                        f.write(content)

            # 5. If the currently active theme was updated, apply live to kitty.conf, config.rasi, GTK, and AwesomeWM!
            if active_updated:
                active_kpath = os.path.join(HOME, ".config/kitty", f"{self.active_mode}.conf")
                live_kpath = os.path.join(HOME, ".config/kitty/kitty.conf")
                if os.path.exists(active_kpath):
                    with open(active_kpath, "r", encoding="utf-8") as f:
                        kcontent = f.read()
                    with open(live_kpath, "w", encoding="utf-8") as f:
                        f.write(kcontent)
                subprocess.run(["pkill", "-USR1", "-x", "kitty"], check=False, stderr=subprocess.DEVNULL)

                for folder, ext in (("alacritty", "toml"), ("lxterminal", "conf")):
                    source = Path(HOME) / ".config" / folder / f"{self.active_mode}.{ext}"
                    if source.exists():
                        shutil.copy2(source, source.with_name(f"{folder}.{ext}"))

                active_rpath = os.path.join(HOME, ".config/rofi", f"{self.active_mode}.rasi")
                live_rpath = os.path.join(HOME, ".config/rofi/config.rasi")
                if os.path.exists(active_rpath):
                    with open(active_rpath, "r", encoding="utf-8") as f:
                        rcontent = f.read()
                    with open(live_rpath, "w", encoding="utf-8") as f:
                        f.write(rcontent)

                for gver in ("gtk-3.0", "gtk-4.0"):
                    gpath = os.path.join(HOME, ".config", gver, "settings.ini")
                    if os.path.exists(gpath):
                        with open(gpath, "r", encoding="utf-8") as f:
                            gcontent = f.read()
                        gcontent = re.sub(
                            r"(?m)^gtk-font-name\s*=.*$",
                            f"gtk-font-name = {fam} {rofi_size}",
                            gcontent,
                        )
                        with open(gpath, "w", encoding="utf-8") as f:
                            f.write(gcontent)

                subprocess.run(
                    ["gsettings", "set", "org.gnome.desktop.interface", "font-name", f"{fam} {rofi_size}"],
                    check=False,
                    stderr=subprocess.DEVNULL,
                )
                subprocess.run(
                    ["gsettings", "set", "org.gnome.desktop.interface", "monospace-font-name", f"{kitty_fam} {rofi_size}"],
                    check=False,
                    stderr=subprocess.DEVNULL,
                )

            self._apply_filter(select_current=False)
            self._update_footer_status()
            self.lbl_toast.configure(
                text=f"✔ Saved {fam} (Kitty: {kitty_fam}) for {', '.join(m.upper() for m in modes_to_update)}!",
                fg=THEME["status_running"],
            )

            # Sync repo & reload AwesomeWM if active theme changed
            reload_cmd = (
                'dbus-send --dest=org.awesomewm.awful --type=method_call / '
                'org.awesomewm.awful.Remote.Eval string:"awesome.restart()" 2>/dev/null || true'
                if active_updated
                else "true"
            )
            subprocess.Popen(
                [
                    "bash",
                    "-c",
                    f'"{HOME}/Projects/slime/sync.sh" --backup >/dev/null 2>&1 || true; {reload_cmd}',
                ],
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
            )
        except Exception as exc:
            self.lbl_toast.configure(text=f"Error: {exc}", fg=THEME["status_stopped"])

    # ==========================================================================
    # Keyboard Navigation
    # ==========================================================================
    def _bind_keys(self):
        self.root.bind("<Escape>", self._on_escape)
        self.root.bind("q", self._on_q)
        self.root.bind("<slash>", self._on_slash)
        self.root.bind("<Tab>", self._on_tab)
        self.root.bind("m", lambda _e: self.cycle_target_mode() if self.root.focus_get() != self.search_entry else None)
        self.root.bind("<Return>", lambda _e: self.apply_selected_font())
        self.root.bind("j", lambda _e: self._move_selection(1) if self.root.focus_get() != self.search_entry else None)
        self.root.bind("k", lambda _e: self._move_selection(-1) if self.root.focus_get() != self.search_entry else None)
        self.root.bind("<Down>", lambda _e: self._move_selection(1))
        self.root.bind("<Up>", lambda _e: self._move_selection(-1))
        self.root.bind("<Next>", lambda _e: self._move_selection(12))
        self.root.bind("<Prior>", lambda _e: self._move_selection(-12))
        self.root.bind("<bracketleft>", lambda _e: self.adjust_size(-0.5) if self.root.focus_get() != self.search_entry else None)
        self.root.bind("<bracketright>", lambda _e: self.adjust_size(0.5) if self.root.focus_get() != self.search_entry else None)

    def _move_selection(self, delta: int):
        if not self.filtered_fonts:
            return "break"
        sel = self.listbox.curselection()
        cur = sel[0] if sel else 0
        nxt = max(0, min(len(self.filtered_fonts) - 1, cur + delta))
        self.listbox.selection_clear(0, "end")
        self.listbox.selection_set(nxt)
        self.listbox.activate(nxt)
        self.listbox.see(nxt)
        self.selected_font = self.filtered_fonts[nxt]
        self._update_preview()
        return "break"

    def _on_tab(self, _event):
        self.cycle_filter_mode()
        return "break"

    def _on_slash(self, _event):
        if self.root.focus_get() != self.search_entry:
            self.search_entry.focus_set()
            self.search_entry.select_range(0, "end")
            return "break"

    def _on_escape(self, _event):
        if self.root.focus_get() == self.search_entry:
            if self.search_var.get():
                self.search_var.set("")
            self.listbox.focus_set()
        else:
            self.root.destroy()

    def _on_q(self, _event):
        if self.root.focus_get() != self.search_entry:
            self.root.destroy()


def main():
    root = tk.Tk(className="font-pad")
    FontPadApp(root)
    root.mainloop()


if __name__ == "__main__":
    main()
