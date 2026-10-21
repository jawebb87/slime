"""Security dashboard rendering, live widget state, and theme switching."""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]


class SCPFacilityTests(unittest.TestCase):
    @unittest.skipUnless(shutil.which('lua5.3'), 'Lua 5.3 with lgi is required')
    def test_renderers_and_live_widget_updates(self):
        result = subprocess.run(['lua5.3', '-'], cwd=ROOT, text=True,
                                capture_output=True, input=r'''
package.path='config/awesome/?.lua;'..package.path
local cairo=require('lgi').cairo
local console=require('theme.scp_shapes')
assert(console.level(-10)==0 and console.level(0)==0)
assert(console.level(50)==6 and console.level(100)==12 and console.level(200)==12)
for _,scale in ipairs({1,1.5,2}) do
    local surface=cairo.ImageSurface.create(cairo.Format.ARGB32,1600*scale,80*scale)
    local cr=cairo.Context(surface)
    console.background(nil,cr,1600*scale,80*scale)
    for _,value in ipairs({0,12.5,50,83.7,100}) do
        console.meter(cr,112*scale,40*scale,'CPU / VU',value)
    end
    for _,time in ipairs({'00:00','12:34','56:78','09:59','23:59'}) do
        console.clock(cr,112*scale,40*scale,time)
    end
    console.channel(cr,40*scale,40*scale,3,true,true,false)
    console.channel(cr,40*scale,40*scale,4,false,false,true)
    assert(cr.status=='SUCCESS',tostring(cr.status))
end
local surface=cairo.ImageSurface.create(cairo.Format.ARGB32,1600,72)
local mask=cairo.Context(surface)
console.shape(mask,1600,72)
assert(mask:in_fill(800,30), 'Widgets must remain inside the console')
assert(not mask:in_fill(1,1), 'Outer corners must remain transparent')
assert(not mask:in_fill(800,71.8), 'Chassis edge must remain transparent')
assert(not mask:in_fill(4,4), 'Clipped corner must remain transparent')
local timers={}
package.preload['gears']=function() return {timer=function(t) table.insert(timers,t) end} end
package.preload['gears.filesystem']=function() return {file_readable=function() return true end} end
package.preload['beautiful.xresources']=function() return {apply_dpi=function(n) return n end} end
package.preload['wibox']=function() return {
    widget={base={make_widget=function() return {emit_signal=function(self) self.redrawn=true end} end}},
    container={background={},margin={}},layout={fixed={horizontal={}}}} end
local theme=dofile('config/awesome/themes/scp-facility.lua')
for _,factory in ipairs({theme.cpu_meter_widget,theme.memory_meter_widget}) do
    local widget=factory();widget:set_value(72.5)
    assert(widget.value==72.5 and widget.redrawn)
end
local old_date=os.date;local now='23:59';os.date=function() return now end
local clock=theme.clock_widget();assert(clock.time=='23:59')
now='00:00';timers[1].callback();assert(clock.time=='00:00' and clock.redrawn)
os.date=old_date
local channel=theme.taglist_template[1].widget()
local root={get_children_by_id=function() return {channel} end}
local tag={name='3',selected=true,clients=function() return {} end}
theme.taglist_template.create_callback(root,tag)
assert(channel.tag==tag and channel.redrawn)
channel.redrawn=false;tag.selected=false
 theme.taglist_template.update_callback(root,tag)
assert(channel.redrawn and not channel.tag.selected)
''')
        self.assertEqual(result.returncode, 0, result.stderr)

    def test_switcher_deploys_console_and_wallpaper(self):
        with tempfile.TemporaryDirectory() as directory:
            home = Path(directory)
            shutil.copytree(ROOT / 'config', home / '.config')
            (home / 'Pictures/wallpaper').mkdir(parents=True)
            shutil.copy2(ROOT / 'wallpaper/scp-facility.png', home / 'Pictures/wallpaper')
            stubs = home / 'stubs'
            stubs.mkdir()
            for name in ('pkill', 'dbus-send', 'gsettings', 'systemctl', 'feh',
                         'killall', 'tmux', 'sleep'):
                command = stubs / name
                command.write_text('#!/bin/sh\nexit 0\n')
                command.chmod(0o755)
            result = subprocess.run(['bash', str(ROOT / 'bin/theme-toggle'), 'scp'],
                                    env=dict(os.environ, HOME=str(home),
                                             PATH=f'{stubs}:{os.environ["PATH"]}'),
                                    capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertEqual((home / '.config/awesome/theme_mode').read_text().strip(), 'scp-facility')
            for folder, ext, active in (
                ('kitty', 'conf', 'kitty.conf'), ('alacritty', 'toml', 'alacritty.toml'),
                ('picom', 'conf', 'picom.conf'), ('rofi', 'rasi', 'config.rasi'),
            ):
                self.assertEqual((home / '.config' / folder / active).read_bytes(),
                                 (ROOT / 'config' / folder / f'scp-facility.{ext}').read_bytes())
            self.assertIn('scp-facility.png', (home / '.fehbg').read_text())
