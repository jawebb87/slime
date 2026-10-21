-- Run from the repository root with Lua 5.3 and lgi; no X server is needed.
-- This is a Cairo study of the actual edge renderers, not a desktop screenshot.
local cairo = require("lgi").cairo
package.path = "config/awesome/?.lua;" .. package.path
local foundry = require("theme.foundry_shapes")
local surface = cairo.ImageSurface.create(cairo.Format.ARGB32, 1440, 580)
local cr = cairo.Context(surface)

local function color(hex)
    cr:set_source_rgb(tonumber(hex:sub(2,3),16)/255,
        tonumber(hex:sub(4,5),16)/255, tonumber(hex:sub(6,7),16)/255)
end
local function text(x,y,label,size,hex)
    cr:select_font_face("monospace", cairo.FontSlant.NORMAL, cairo.FontWeight.NORMAL)
    cr:set_font_size(size)
    color(hex or "#dfd4b9")
    cr:move_to(x,y)
    cr:show_text(label)
end
local function box(x,y,w,h,hex)
    color(hex)
    cr:rectangle(x,y,w,h)
    cr:fill()
end
local function pill(x,y,w,label)
    box(x,y,w,24,"#232927")
    cr:rectangle(x+0.5,y+0.5,w-1,23)
    color("#685b42")
    cr:set_line_width(1)
    cr:stroke()
    text(x+10,y+16,label,11)
end

color("#111a17"); cr:paint()
text(24,34,"FOUNDRY / MECHANICAL ASSEMBLY STUDY",15,"#d3b77c")
text(24,58,"Cast housings, meshed gear ratios, supported line shafts and keyed axles",11,"#8f9382")
cr:save(); cr:translate(20,82)
foundry.bar_background(20)(nil,cr,1400,74)
-- Sample controls show the clear instrument area above the moving parts.
pill(15,7,172,"I   II   III   IV   V")
pill(205,7,350,"terminal   |   workshop   |   notes")
pill(780,7,87,"CPU 18%")
pill(877,7,78,"RAM 4G")
pill(965,7,100,"NET ONLINE")
pill(1075,7,93,"VOL 42%")
pill(1178,7,203,"TUE 20 OCT  11:40")
cr:restore()

local function window(x,y,w,h,focused)
    cr:save(); cr:translate(x,y)
    foundry.edge_shape(20,"window")(cr,w,h)
    cr:clip()
    box(0,0,w,h,"#171b1b")
    box(0,0,w,2,focused and "#ac9264" or "#4a4437")
    text(18,32,focused and "ENGINE ROOM / CONTROL CONSOLE" or "WORKSHOP / LOGBOOK",12,
        focused and "#d3b77c" or "#8f9382")
    text(18,64,"$ pressure --watch",12,"#91ae83")
    text(18,94,"boiler     nominal",11)
    text(18,116,"flywheel   engaged",11)
    text(18,138,"governor   steady",11)
    text(18,h-60,"line shaft ready",11,"#8f9382")
    local c = {}
    client = {focus = focused and c or nil}
    cr:translate(0,h-40)
    foundry.window_background(c,20)(nil,cr,w,40)
    cr:restore()
end
window(20,224,900,280,true)
window(950,224,470,280,false)
text(24,542,"Riveted iron window sills stay inside the existing bottom titlebar.",11,"#8f9382")
surface:write_to_png(arg[1] or "docs/previews/foundry-edges.png")
