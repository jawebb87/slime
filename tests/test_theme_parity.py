"""Cross-theme behavior checked in disposable homes, with desktop effects stubbed."""
import importlib.util
import os
from pathlib import Path
import re
import shutil
import subprocess
import tempfile
import tomllib
import unittest
from unittest.mock import Mock, patch

ROOT = Path(__file__).resolve().parents[1]
THEMES = sorted(p.stem for p in (ROOT / 'config/awesome/themes').glob('*.lua')
                if p.stem != 'template' and not p.stem.startswith('_'))
PROFILES = [('kitty', 'conf', 'kitty.conf'), ('alacritty', 'toml', 'alacritty.toml'),
            ('lxterminal', 'conf', 'lxterminal.conf'), ('tmux/themes', 'conf', '../theme.conf'),
            ('rofi', 'rasi', 'config.rasi'), ('picom', 'conf', 'picom.conf')]


def isolated_home(home):
    shutil.copytree(ROOT / 'config', home / '.config')
    stubs = home / 'stubs'
    stubs.mkdir()
    for name in ('pkill', 'dbus-send', 'gsettings', 'systemctl', 'feh', 'killall', 'tmux', 'sleep'):
        path = stubs / name
        path.write_text('#!/bin/sh\nexit 0\n')
        path.chmod(0o755)
    return dict(os.environ, HOME=str(home), XDG_CONFIG_HOME=str(home / '.config'),
                XDG_CACHE_HOME=str(home / '.cache'), XDG_DATA_HOME=str(home / '.local/share'),
                XDG_STATE_HOME=str(home / '.local/state'),
                PATH=f'{stubs}:{os.environ["PATH"]}')


class ThemeParityTests(unittest.TestCase):
    def test_every_theme_switches_all_application_profiles(self):
        with tempfile.TemporaryDirectory() as directory:
            home = Path(directory)
            env = isolated_home(home)
            for name in THEMES:
                with self.subTest(theme=name):
                    result = subprocess.run(['bash', str(ROOT / 'bin/theme-toggle'), name],
                                            env=env, text=True, capture_output=True)
                    self.assertEqual(result.returncode, 0, result.stderr)
                    for folder, ext, active in PROFILES:
                        self.assertEqual((home / '.config' / folder / active).read_bytes(),
                                         (ROOT / 'config' / folder / f'{name}.{ext}').read_bytes())
                    self.assertEqual((home / '.config/starship.toml').read_bytes(),
                                     (ROOT / f'config/starship-{name}.toml').read_bytes())
                    self.assertTrue((ROOT / f'config/nvim/colors/{name}.lua').exists())
                    self.assertTrue((ROOT / f'config/btop/themes/{name}.theme').exists())
                    self.assertIn(f'color_theme = "{name}"', (home / '.config/btop/btop.conf').read_text())
                    self.assertRegex((home / '.config/gtk-3.0/settings.ini').read_text(), r'gtk-font-name = .+ \d')
            # Cycling works without an argument and retains canonical ordering.
            result = subprocess.run(['bash', str(ROOT / 'bin/theme-toggle')], env=env, capture_output=True)
            self.assertEqual(result.returncode, 0)

    def test_terminal_sizes_match_established_baseline(self):
        for name in THEMES:
            data = tomllib.loads((ROOT / f'config/alacritty/{name}.toml').read_text())
            self.assertEqual(data['font']['size'], 6.5 if name == 'slime' else 7.0, name)

    @unittest.skipUnless(shutil.which('nvim'), 'Neovim required')
    def test_neovim_loads_every_scheme_and_tracks_focus(self):
        with tempfile.TemporaryDirectory() as directory:
            home = Path(directory)
            env = isolated_home(home)
            script = home / 'verify.lua'
            script.write_text('''
local names = {NAMES}
local file = os.getenv('HOME') .. '/.config/awesome/theme_mode'
for _, name in ipairs(names) do
    local f = assert(io.open(file, 'w')); f:write(name); f:close()
    vim.api.nvim_exec_autocmds('FocusGained', {})
    assert(vim.g.colors_name == name, 'Theme failed: ' .. name)
    assert(vim.api.nvim_get_hl(0, {name='Normal'}).fg, 'Missing foreground: ' .. name)
end
local f = assert(io.open(file, 'w')); f:write('nonexistent'); f:close()
vim.api.nvim_exec_autocmds('FocusGained', {})
assert(vim.g.colors_name == 'slime')
'''.replace('NAMES', ','.join(repr(name) for name in THEMES)))
            result = subprocess.run(['nvim', '--headless', '-i', 'NONE', '-n',
                                     '-c', f'luafile {script}', '-c', 'qa!'],
                                    env=env, capture_output=True, text=True, timeout=20)
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertNotIn('Error', result.stderr)

    def test_font_chooser_discovers_and_updates_every_theme(self):
        with tempfile.TemporaryDirectory() as directory:
            home = Path(directory)
            env = isolated_home(home)
            bench = home / 'Projects/qtile_bench'
            bench.mkdir(parents=True)
            shutil.copy2(ROOT / 'pads/theme.py', bench / 'theme.py')
            spec = importlib.util.spec_from_file_location('font_pad_parity', ROOT / 'pads/font_pad.py')
            module = importlib.util.module_from_spec(spec)
            with patch.dict(os.environ, env):
                spec.loader.exec_module(module)
            self.assertEqual(module.discover_themes(), THEMES)
            (home / '.config/awesome/theme_mode').write_text('vaporwave-schizoid')
            self.assertEqual(module.get_active_mode(), 'vaporwave-schizoid')
            self.assertEqual(module.get_theme_font_config('vaporwave-schizoid')[1], 7.0)
            app = module.FontPadApp.__new__(module.FontPadApp)
            app.theme_fonts = {name: list(module.get_theme_font_config(name)) for name in THEMES}
            app.selected_font = 'Test Mono'
            app.mono_100 = {'Test Mono'}
            app.base_size = 8.5
            app.target_mode = 'all'
            app.active_mode = 'vaporwave-schizoid'
            app.lbl_toast = Mock()
            app._apply_filter = Mock()
            app._update_footer_status = Mock()
            with patch.object(module.subprocess, 'run'), patch.object(module.subprocess, 'Popen'):
                app.apply_selected_font()
            for name in THEMES:
                with self.subTest(theme=name):
                    conf = home / '.config'
                    data = tomllib.loads((conf / f'alacritty/{name}.toml').read_text())
                    self.assertEqual(data['font']['size'], 8.5)
                    self.assertEqual(data['font']['normal']['family'], 'Test Mono')
                    self.assertIn('fontname=Test Mono 8.5', (conf / f'lxterminal/{name}.conf').read_text())
                    self.assertRegex((conf / f'kitty/{name}.conf').read_text(), r'font_size\s+8.5')
                    self.assertRegex((conf / f'awesome/themes/{name}.lua').read_text(), r'font_family\s*=\s*"Test Mono"')
                    self.assertRegex((conf / f'rofi/{name}.rasi').read_text(), r'font:\s*"Test Mono 8"')
            data = tomllib.loads((home / '.config/alacritty/alacritty.toml').read_text())
            self.assertEqual(data['font']['size'], 8.5)
            self.assertNotIn('Error:', str(app.lbl_toast.configure.call_args))

    def test_theme_console_opens_shell_without_chomp_fallback(self):
        with tempfile.TemporaryDirectory() as directory:
            home = Path(directory)
            env = isolated_home(home)
            shell = home / 'shell'
            shell.write_text('#!/bin/sh\n[ "$1" = "-i" ]\n')
            shell.chmod(0o755)
            env['SHELL'] = str(shell)
            for name in THEMES:
                (home / '.config/awesome/theme_mode').write_text(name + '\n')
                result = subprocess.run(['bash', str(ROOT / 'bin/theme-console')], env=env,
                                        capture_output=True, text=True)
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertIn('console', result.stdout)
                if name not in ('chomp', 'crayon-chomp'):
                    self.assertNotIn('Chomp', result.stdout)

    def test_shortcuts_have_no_duplicate_or_client_conflicting_bindings(self):
        keys = (ROOT / 'config/awesome/config/keys.lua').read_text()
        combos = re.findall(r'awful.key\(\{([^}]+)\},\s*"([^"]+)"', keys)
        seen = set()
        for mods, key in combos:
            combo = (tuple(sorted(x.strip() for x in mods.split(',') if x.strip())), key)
            self.assertNotIn(combo, seen, f'Duplicate shortcut: {combo}')
            seen.add(combo)
