"""Desktop regression checks: python -m unittest discover -s tests -p test_desktop_regressions.py"""

import importlib.util
import os
from pathlib import Path
import re
import shutil
import subprocess
import tempfile
import unittest
from unittest.mock import patch


ROOT = Path(__file__).resolve().parents[1]


class DesktopRegressions(unittest.TestCase):
    def test_restore_preserves_originals_and_deploys_assets(self):
        with tempfile.TemporaryDirectory() as directory:
            home = Path(directory)
            originals = [
                '.config/nvim/init.lua', '.config/alacritty/alacritty.toml',
                '.config/gtk-3.0/settings.ini', '.config/starship.toml',
                '.local/bin/chomp-pad', 'Projects/qtile_bench/theme.py',
                'Pictures/wallpaper/slime.jpg', '.zshrc',
            ]
            for relative in originals:
                target = home / relative
                target.parent.mkdir(parents=True, exist_ok=True)
                target.write_text('original ' + relative)
            # Prevent any live desktop restart, even if Awesome is running.
            stubs = home / 'stubs'
            stubs.mkdir()
            pgrep = stubs / 'pgrep'
            pgrep.write_text('#!/bin/sh\nexit 1\n')
            pgrep.chmod(0o755)
            git = stubs / 'git'
            git.write_text('#!/bin/sh\nexit 0\n')
            git.chmod(0o755)
            env = dict(os.environ, HOME=str(home), PATH=f'{stubs}:{os.environ["PATH"]}')
            result = subprocess.run(
                ['bash', str(ROOT / 'sync.sh'), '--restore'],
                env=env, capture_output=True, text=True,
            )
            self.assertEqual(result.returncode, 0, result.stderr)
            backups = list(home.glob('.slime_backup_*'))
            self.assertEqual(len(backups), 1)
            for relative in originals:
                self.assertEqual(
                    (backups[0] / relative).read_text(), 'original ' + relative,
                )
            self.assertEqual(
                (home / '.config/alacritty/alacritty.toml').read_bytes(),
                (ROOT / 'config/alacritty/alacritty.toml').read_bytes(),
            )
            for source in (ROOT / 'wallpaper').iterdir():
                if source.suffix.lower() in {'.jpg', '.jpeg', '.png', '.webp'}:
                    self.assertEqual(
                        (home / 'Pictures/wallpaper' / source.name).read_bytes(),
                        source.read_bytes(),
                    )
            # A subsequent fresh Alacritty deployment must also work, and a
            # second restore in the same second must keep its own backup.
            shutil.rmtree(home / '.config/alacritty')
            result = subprocess.run(
                ['bash', str(ROOT / 'sync.sh'), '--restore'],
                env=env, capture_output=True, text=True,
            )
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertTrue((home / '.config/alacritty/alacritty.toml').is_file())
            self.assertEqual(len(list(home.glob('.slime_backup_*'))), 2)
            self.assertEqual(
                (backups[0] / '.config/nvim/init.lua').read_text(),
                'original .config/nvim/init.lua',
            )

            # Pull into a throwaway repository to verify backup synchronization
            # without changing the actual working tree.
            repository = home / 'copy'
            repository.mkdir()
            shutil.copy2(ROOT / 'sync.sh', repository / 'sync.sh')
            (repository / 'bin').mkdir()
            shutil.copy2(ROOT / 'bin/gill-pad', repository / 'bin/gill-pad')
            (home / '.local/bin/gill-pad').write_text('# live console update\n')
            result = subprocess.run(
                ['bash', str(repository / 'sync.sh'), '--backup'],
                env=env, capture_output=True, text=True,
            )
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertEqual(
                (repository / 'bin/gill-pad').read_text(), '# live console update\n',
            )
            self.assertEqual(
                (repository / 'wallpaper/mystery.jpg').read_bytes(),
                (ROOT / 'wallpaper/mystery.jpg').read_bytes(),
            )

    def test_theme_console_commands_exist_and_open_shell(self):
        with tempfile.TemporaryDirectory() as directory:
            home = Path(directory)
            shell = home / 'shell'
            shell.write_text('#!/bin/sh\n[ "$1" = "-i" ]\n')
            shell.chmod(0o755)
            keys = (ROOT / 'config/awesome/config/keys.lua').read_text()
            names = set(re.findall(r'/\.local/bin/([\w-]+-pad)', keys))
            for name in names:
                with self.subTest(console=name):
                    script = ROOT / 'bin' / name
                    self.assertTrue(script.is_file())
                    result = subprocess.run(
                        ['bash', str(script)],
                        env=dict(os.environ, HOME=str(home), SHELL=str(shell)),
                        capture_output=True, text=True,
                    )
                    self.assertEqual(result.returncode, 0, result.stderr)

    def test_missing_pad_palettes_match_theme_colors(self):
        spec = importlib.util.spec_from_file_location('pad_theme', ROOT / 'pads/theme.py')
        theme = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(theme)
        with tempfile.TemporaryDirectory() as directory:
            home = Path(directory)
            mode = home / '.config/awesome/theme_mode'
            mode.parent.mkdir(parents=True)
            with patch.dict(os.environ, HOME=str(home)):
                for name in ('clay', 'void', 'bake'):
                    mode.write_text(name)
                    palette = theme.get_theme()
                    self.assertIsNot(palette, theme.SLIME_THEME)
                    self.assertEqual(set(palette), set(theme.SLIME_THEME))
                    lua = (ROOT / f'config/awesome/themes/{name}.lua').read_text()
                    for key in ('border_focus', 'border_normal', 'font_family'):
                        value = re.search(r'\b' + key + r'\s*=\s*"([^"]+)"', lua)[1]
                        pad_key = {'border_normal': 'border', 'font_family': 'font'}.get(key, key)
                        self.assertEqual(palette[pad_key], value)

    @unittest.skipUnless(shutil.which('lua'), 'Lua is required')
    def test_fullscreen_preserves_explicit_floating_state(self):
        result = subprocess.run(['lua', '-'], cwd=ROOT, text=True, capture_output=True, input=r'''
local handlers = {}
package.preload['awful'] = function()
    return { titlebar = { hide = function() end, show = function() end } }
end
package.preload['gears'] = function() return {} end
package.preload['beautiful'] = function() return { border_width = 2 } end
package.preload['wibox'] = function() return {} end
package.preload['theme.slime_shapes'] = function() return {} end
client = { connect_signal = function(name, fn) handlers[name] = fn end }
tag = { connect_signal = function() end }
awesome = { startup = false }
dofile('config/awesome/config/signals.lua')
-- Fullscreen transitions must not reveal or hide the hover-controlled overlay.
for _, visible in ipairs({false, true}) do
    local s = {_bar_autohide={}, mywibox={visible=visible}}
    local c = {screen=s, fullscreen=true, raise=function() end}
    handlers['property::fullscreen'](c)
    assert(s.mywibox.visible==visible, 'Fullscreen overrode autohide visibility')
    c.fullscreen=false;handlers['property::fullscreen'](c)
    assert(s.mywibox.visible==visible, 'Leaving fullscreen overrode autohide visibility')
end
for _, initial in ipairs({false, true, 'implicit'}) do
    local c = { fullscreen = true, raise = function() end }
    if initial ~= 'implicit' then c.floating = initial end
    handlers['manage'](c)
    handlers['property::fullscreen'](c)
    c.fullscreen = false
    handlers['property::fullscreen'](c)
    if initial == 'implicit' then
        assert(c.floating == nil, 'Implicit floating state was overridden')
    else
        assert(c.floating == initial, 'Explicit floating state changed')
    end
end
''')
        self.assertEqual(result.returncode, 0, result.stderr)


if __name__ == '__main__':
    unittest.main()
