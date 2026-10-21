"""Floating bar placement and Eeyore theme deployment checks."""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]


class EeyoreTests(unittest.TestCase):
    @unittest.skipUnless(shutil.which('lua'), 'Lua is required')
    def test_floating_geometry_handles_monitor_offsets_and_resizes(self):
        result = subprocess.run(['lua', '-'], cwd=ROOT, text=True,
                                capture_output=True, input='''
local place = dofile('config/awesome/ui/bar_geometry.lua')
for _, scale in ipairs({1, 1.5, 2}) do
    for _, screen in ipairs({
        {x=0, y=0, width=1920}, {x=1920, y=200, width=1366},
        {x=-1920, y=-1080, width=1920}, {x=0, y=0, width=640},
    }) do
        local g, top = place(screen, 44*scale, 20*scale, 12*scale, 12*scale)
        assert(g.x == screen.x + 20*scale)
        assert(g.y == screen.y + 12*scale)
        assert(g.width == screen.width - 40*scale)
        assert(top == 68*scale)
        assert(g.y + g.height < screen.y + top)
    end
end
local tiny = place({x=0,y=0,width=20}, 44, 20, 12, 12)
assert(tiny.width > 0 and tiny.x >= 0 and tiny.x+tiny.width <= 20)
''')
        self.assertEqual(result.returncode, 0, result.stderr)

    def test_switcher_deploys_light_theme_and_wallpaper(self):
        with tempfile.TemporaryDirectory() as directory:
            home = Path(directory)
            shutil.copytree(ROOT / 'config', home / '.config')
            (home / 'Pictures/wallpaper').mkdir(parents=True)
            shutil.copy2(ROOT / 'wallpaper/eeyore.png', home / 'Pictures/wallpaper')
            stubs = home / 'stubs'
            stubs.mkdir()
            for name in ('pkill', 'dbus-send', 'gsettings', 'systemctl', 'feh',
                         'killall', 'tmux', 'sleep'):
                command = stubs / name
                command.write_text('#!/bin/sh\nexit 0\n')
                command.chmod(0o755)
            result = subprocess.run(['bash', str(ROOT / 'bin/theme-toggle'), 'watercolor'],
                                    env=dict(os.environ, HOME=str(home),
                                             PATH=f'{stubs}:{os.environ["PATH"]}'),
                                    capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertEqual((home / '.config/awesome/theme_mode').read_text().strip(), 'eeyore')
            for folder, ext, active in (
                ('kitty', 'conf', 'kitty.conf'), ('alacritty', 'toml', 'alacritty.toml'),
                ('picom', 'conf', 'picom.conf'), ('rofi', 'rasi', 'config.rasi'),
            ):
                self.assertEqual((home / '.config' / folder / active).read_bytes(),
                                 (ROOT / 'config' / folder / f'eeyore.{ext}').read_bytes())
            self.assertIn('eeyore.png', (home / '.fehbg').read_text())
            self.assertIn('gtk-application-prefer-dark-theme = 0',
                          (home / '.config/gtk-3.0/settings.ini').read_text())
