"""Headless checks for Foundry's Cairo geometry and theme switching."""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import tomllib
import unittest

ROOT = Path(__file__).resolve().parents[1]


class FoundryTests(unittest.TestCase):
    @unittest.skipUnless(shutil.which('lua5.3'), 'Lua 5.3 with lgi is required')
    def test_gear_shapes_and_renderers_at_multiple_sizes(self):
        result = subprocess.run(['lua5.3', '-'], cwd=ROOT, text=True,
                                capture_output=True, input=r'''
package.path = 'config/awesome/?.lua;' .. package.path
local cairo = require('lgi').cairo
local shapes = require('theme.foundry_shapes')
package.preload['gears'] = function()
    return {shape = {rounded_rect = function(cr,w,h) cr:rectangle(0,0,w,h) end}}
end
local scale = 1
package.preload['beautiful.xresources'] = function()
    return {apply_dpi = function(n) return n * scale end}
end
for _, dpi in ipairs({1, 1.5, 2}) do
    scale = dpi
    local theme = dofile('config/awesome/themes/foundry.lua')
    assert(theme.name == 'foundry')
    assert(theme.bar_height - theme.bar_margin_top - theme.bar_margin_bottom >= 24)
    for _, width in ipairs({24, 139, 140, 160, 239, 240, 419, 420, 440, 441, 800, 1450, 1451, 1920}) do
        local w,h = width*dpi, theme.bar_height
        local surface = cairo.ImageSurface.create(cairo.Format.ARGB32, w,h)
        local cr = cairo.Context(surface)
        theme.bar_shape(cr,w,h)
        assert(cr:in_fill(w/2,2), 'Solid fascia must be inside mask')
        local depth = theme.window_edge_height
        local layout = shapes.assembly_layout(width, 'bar')
        local g = layout.gears[1]
        assert(cr:in_fill(g.x*dpi,h-depth+(g.y+g.radius*0.55)*dpi),
            'Gear must project below fascia')
        assert(not cr:in_fill(0,h-1), 'Bottom corner must remain transparent')
        cr:new_path()
        theme.bar_bgimage(nil,cr,w,h)
        assert(cr.status == 'SUCCESS', tostring(cr.status))
        local c = {}
        client = {focus = c}
        local render = theme.window_edge_fn(c)
        render(nil,cr,w,theme.window_titlebar_height)
        client.focus = nil
        render(nil,cr,w,theme.window_titlebar_height)
        assert(cr.status == 'SUCCESS', tostring(cr.status))
        local mask = theme.window_shape_fn(c)
        mask(cr,w,400*dpi)
        for _, x in ipairs({0.1, w/2, w-0.1}) do
            assert(cr:in_fill(x,400*dpi-0.1), 'Iron sill must have a continuous flat bottom')
        end
        for _, scene in ipairs({layout}) do
            local sizes = {}
            for _, gear in ipairs(scene.gears) do
                sizes[gear.teeth] = true
                if gear.parent then
                    local p = gear.parent
                    local dx,dy = gear.x-p.x, gear.y-p.y
                    assert(math.abs(math.sqrt(dx*dx+dy*dy)-gear.pitch-p.pitch) < 1e-7,
                        'Mesh centers must use pitch radii')
                    assert(gear.module == p.module, 'Meshing teeth need the same circular pitch')
                    local angle = math.atan(dy,dx)
                    local contact = ((angle-p.phase)*p.teeth
                        +(angle+math.pi-gear.phase)*gear.teeth) % (2*math.pi)
                    assert(math.abs(contact-math.pi) < 1e-7, 'A tooth must face a gap')
                end
            end
            local count = 0
            for _ in pairs(sizes) do count = count+1 end
            assert(count >= 2, 'Gear trains must have different wheel sizes')
        end
    end
end
''')
        self.assertEqual(result.returncode, 0, result.stderr)

    @unittest.skipUnless(shutil.which('lua5.3'), 'Lua 5.3 with lgi is required')
    def test_background_cache_reuses_focus_states_and_bounds_resize_growth(self):
        result = subprocess.run(['lua5.3', '-'], cwd=ROOT, text=True,
                                capture_output=True, input=r'''
package.path = 'config/awesome/?.lua;' .. package.path
local cairo = require('lgi').cairo
local shapes = require('theme.foundry_shapes')
local original_layout, builds = shapes.assembly_layout, 0
shapes.assembly_layout = function(...)
    builds = builds + 1
    return original_layout(...)
end
local surface = cairo.ImageSurface.create(cairo.Format.ARGB32, 1200, 100)
local cr = cairo.Context(surface)
local bar = shapes.bar_background(20)
bar(nil,cr,1200,74)
assert(builds == 1)
for i=1,50 do bar(nil,cr,1200,74) end
assert(builds == 1, 'Telemetry redraws must reuse a rendered surface')
local c = {}
client = {focus=c}
local window = shapes.window_background(c,20)
window(nil,cr,800,40)
client.focus = nil
window(nil,cr,800,40)
client.focus = c
window(nil,cr,800,40)
assert(builds == 1, 'Iron window sills must never construct gear assemblies')
-- Exceed the surface-count cap, then verify that the oldest size was evicted.
for width=900,930 do bar(nil,cr,width,74) end
local before = builds
bar(nil,cr,1200,74)
assert(builds == before+1, 'Resize surfaces must not accumulate without bound')
bar(nil,cr,0,74)
assert(builds == before+1, 'Zero-sized widgets must not allocate a surface')
assert(cr.status == 'SUCCESS', tostring(cr.status))
''')
        self.assertEqual(result.returncode, 0, result.stderr)

    def test_switcher_installs_foundry_variants(self):
        with tempfile.TemporaryDirectory() as directory:
            home = Path(directory)
            shutil.copytree(ROOT / 'config', home / '.config')
            (home / 'Pictures/wallpaper').mkdir(parents=True)
            shutil.copy2(ROOT / 'wallpaper/foundry.png', home / 'Pictures/wallpaper')
            stubs = home / 'stubs'
            stubs.mkdir()
            for name in ('pkill', 'dbus-send', 'gsettings', 'systemctl', 'feh',
                         'killall', 'tmux', 'sleep'):
                command = stubs / name
                command.write_text('#!/bin/sh\nexit 0\n')
                command.chmod(0o755)
            env = dict(os.environ, HOME=str(home), PATH=f'{stubs}:{os.environ["PATH"]}')
            result = subprocess.run(['bash', str(ROOT / 'bin/theme-toggle'), 'industrial'],
                                    env=env, capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertEqual((home / '.config/awesome/theme_mode').read_text().strip(), 'foundry')
            for folder, ext, active in (
                ('alacritty', 'toml', 'alacritty.toml'),
                ('kitty', 'conf', 'kitty.conf'), ('rofi', 'rasi', 'config.rasi'),
                ('picom', 'conf', 'picom.conf'), ('lxterminal', 'conf', 'lxterminal.conf'),
            ):
                self.assertEqual((home / '.config' / folder / active).read_bytes(),
                                 (ROOT / 'config' / folder / f'foundry.{ext}').read_bytes())
            self.assertIn('foundry.png', (home / '.fehbg').read_text())
            self.assertIn('color_theme = "foundry"', (home / '.config/btop/btop.conf').read_text())
            for path in (ROOT / 'config').glob('*foundry*.toml'):
                tomllib.loads(path.read_text())
            tomllib.loads((home / '.config/alacritty/alacritty.toml').read_text())


if __name__ == '__main__':
    unittest.main()
