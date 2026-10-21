"""Autohide behavior with screen, pointer, and timer doubles; no desktop effects."""
from pathlib import Path
import shutil
import subprocess
import unittest

ROOT = Path(__file__).resolve().parents[1]


class BarAutohideTests(unittest.TestCase):
    @unittest.skipUnless(shutil.which('lua5.3'), 'Lua 5.3 is required')
    def test_reveal_delay_monitor_geometry_and_cleanup(self):
        result = subprocess.run(['lua5.3', '-'], cwd=ROOT, text=True,
                                capture_output=True, input=r'''
package.path='config/awesome/?.lua;'..package.path
local timers={}
package.preload['gears']=function() return {timer=function(options)
    local timer={callback=options.callback,started=false}
    function timer:start() self.started=true end
    function timer:stop() self.started=false end
    timers[#timers+1]=timer
    return timer
end} end
local function object(properties)
    local o=properties or {};o.signals={}
    function o:connect_signal(name,callback) self.signals[name]=callback end
    function o:disconnect_signal(name,callback)
        assert(self.signals[name]==callback);self.signals[name]=nil
    end
    function o:emit(name) if self.signals[name] then self.signals[name](self) end end
    return o
end
local function box(properties)
    local o=object(properties);o.g={}
    function o:geometry(g) if g then self.g=g end;return self.g end
    function o:struts(struts) self.reserved=struts end
    return o
end
package.preload['wibox']=function() return box end
local attach=require('ui.bar_autohide').attach
local time=0
local pointer={x=0,y=0}
local function options(floating)
    return {floating=floating,height=64,inset=12,offset=10,strip_height=2,
        now=function() return time end,pointer=function() return pointer end}
end
local left=object{geometry={x=-1920,y=200,width=1920}}
local right=object{geometry={x=0,y=0,width=2560}}
local b1,b2=box{},box{}
local a1=attach(left,b1,options(true))
local a2=attach(right,b2,options(false))
assert(not b1.visible and not b2.visible)
assert(a1.trigger.visible and a1.trigger.bg=='#00000000')
assert(a1.trigger.ontop and not a1.trigger.input_passthrough)
assert(a1.trigger.g.x==-1920 and a1.trigger.g.y==200)
assert(a1.trigger.g.width==1920 and a1.trigger.g.height==2)
assert(b1.g.x==-1908 and b1.g.y==210 and b1.g.width==1896)
assert(b2.g.x==0 and b2.g.y==0 and b2.g.width==2560)
assert(b1.reserved.top==0 and b2.reserved.top==0)
assert(a1.trigger.reserved.top==0)
assert(not timers[1].started and not timers[2].started)
pointer={x=-1000,y=200};a1.trigger:emit('mouse::enter')
assert(b1.visible and timers[1].started and not b2.visible)
-- Crossing the gap and transparent side insets must not start a hide countdown.
pointer={x=-1919,y=206};time=1;timers[1].callback()
time=2;timers[1].callback();assert(b1.visible)
pointer={x=-1000,y=240};timers[1].callback();assert(b1.visible)
-- Briefly leaving and returning cancels hiding.
pointer={x=-1000,y=400};time=3;timers[1].callback()
time=3.3;timers[1].callback();assert(b1.visible)
pointer={x=-1000,y=240};timers[1].callback()
pointer={x=-1000,y=400};time=4;timers[1].callback()
time=4.46;timers[1].callback();assert(not b1.visible and not timers[1].started)
-- Moving to another monitor hides this bar; each screen reveals independently.
pointer={x=-1000,y=200};a1.trigger:emit('mouse::enter')
pointer={x=100,y=0};a2.trigger:emit('mouse::enter')
time=5;timers[1].callback();timers[2].callback()
time=5.5;timers[1].callback();assert(not b1.visible and b2.visible)
-- Monitor geometry changes update both overlays without reserving workarea.
right.geometry={x=1920,y=-300,width=1600};right:emit('property::geometry')
assert(b2.g.x==1920 and b2.g.y==-300 and b2.g.width==1600)
assert(a2.trigger.g.x==1920 and a2.trigger.g.y==-300)
assert(a2.trigger.g.width==1600 and b2.reserved.top==0)
right:emit('removed')
assert(not b2.visible and not a2.trigger.visible and not timers[2].started)
assert(not right.signals['property::geometry'])
assert(not a2.trigger.signals['mouse::enter'])
a2.dispose() -- Cleanup is safe to repeat.
''')
        self.assertEqual(result.returncode, 0, result.stderr)
