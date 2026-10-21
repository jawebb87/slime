-- Render the production ramp and workspace art without an X server.
local cairo = require('lgi').cairo
package.path = 'config/awesome/?.lua;' .. package.path
local ramp = require('theme.halfpipe_shapes')
local width = tonumber(arg[2]) or 1600
local surface = cairo.ImageSurface.create(cairo.Format.ARGB32,width,220)
local cr = cairo.Context(surface)
cr:set_source_rgb(0.07,0.09,0.08);cr:paint()
cr:save();cr:translate(12,14)
ramp.background(nil,cr,width-24,94)
cr:restore()
local function text(x,y,label,size,color)
    cr:set_source_rgb(table.unpack(color or {0.9,0.9,0.83}))
    cr:select_font_face('Liberation Mono',cairo.FontSlant.NORMAL,cairo.FontWeight.BOLD)
    cr:set_font_size(size);cr:move_to(x,y);cr:show_text(label)
end
for i=1,9 do
    cr:save();cr:translate(104+(i-1)*34,67)
    ramp.deck(cr,30,34,i==3,i<6,false);cr:restore()
    text(105+(i-1)*34,74,tostring(i),8)
end
text(440,88,'SESSION / TERMINAL',12)
text(width-850,88,'CPU 12%   RAM 4.2G   NET ONLINE   VOL 65%   BAT 82%',11)
cr:set_source_rgb(0.06,0.09,0.07);cr:rectangle(width-220,67,110,34);cr:fill()
text(width-212,93,'21:48',25,{0.61,0.86,0.27})
text(30,155,'HALFPIPE / AFTER HOURS',18)
text(30,183,'Production Cairo artwork with representative widget placement.',12)
surface:write_to_png(arg[1] or 'docs/previews/halfpipe-bar.png')
