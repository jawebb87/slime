"""Headless validation of the ramp mask and production Cairo renderers."""
from pathlib import Path
import shutil
import subprocess
import unittest

ROOT = Path(__file__).resolve().parents[1]


class HalfpipeTests(unittest.TestCase):
    @unittest.skipUnless(shutil.which('lua5.3'), 'Lua 5.3 with lgi is required')
    def test_ramp_keeps_controls_inside_mask_and_sky_above_flat(self):
        result = subprocess.run(['lua5.3', '-'], cwd=ROOT, text=True,
                                capture_output=True, input=r'''
package.path = 'config/awesome/?.lua;' .. package.path
local cairo = require('lgi').cairo
local ramp = require('theme.halfpipe_shapes')
for _, scale in ipairs({1,1.5,2}) do
    for _, width in ipairs({240,640,1366,1920,3840}) do
        local w,h = width*scale,94*scale
        local surface = cairo.ImageSurface.create(cairo.Format.ARGB32,w,h)
        local cr = cairo.Context(surface)
        ramp.shape(cr,w,h)
        assert(not cr:in_fill(w/2,20*scale), 'Sky must remain transparent')
        assert(cr:in_fill(w/2,54*scale), 'Controls must stay on concrete')
        assert(cr:in_fill(5*scale,10*scale), 'Quarterpipe ends must rise')
        assert(cr:in_fill(w-5*scale,10*scale), 'Both ends must rise')
        assert(cr:in_fill(w/2,90*scale), 'Base must be continuous')
        cr:new_path()
        ramp.background(nil,cr,w,h)
        for _, selected in ipairs({false,true}) do
            cr:save();cr:translate(90*scale,53*scale)
            ramp.deck(cr,30*scale,34*scale,selected,true,false)
            cr:restore()
        end
        assert(cr.status == 'SUCCESS', tostring(cr.status))
    end
end
package.preload['gears'] = function() return {shape={rounded_rect=function() end}} end
package.preload['gears.filesystem'] = function() return {file_readable=function() return false end} end
package.preload['beautiful.xresources'] = function() return {apply_dpi=function(n) return n end} end
package.preload['wibox'] = function()
    return {widget={base={make_widget=function()
        return {emit_signal=function(self) self.redrawn=true end}
    end}},container={background={}},layout={fixed={horizontal={}}}}
end
local theme = dofile('config/awesome/themes/halfpipe.lua')
local deck = theme.taglist_template[1].widget()
local root = {get_children_by_id=function() return {deck} end}
local tag = {name='3',selected=true,clients=function() return {} end}
theme.taglist_template.create_callback(root,tag)
assert(deck.tag == tag and deck.redrawn, 'Tag creation must redraw the skater')
deck.redrawn=false;tag.selected=false
theme.taglist_template.update_callback(root,tag)
assert(deck.redrawn and not deck.tag.selected, 'Tag switching must redraw the deck')
assert(theme.bar_margin_top > 48 and theme.bar_margin_top+34 <= 94-theme.bar_margin_bottom)
assert(theme.wallpaper == false, 'Missing wallpaper must use solid backdrop')
ramp.background(nil,cairo.Context(cairo.ImageSurface.create(cairo.Format.ARGB32,1,1)),0,0)
''')
        self.assertEqual(result.returncode, 0, result.stderr)
