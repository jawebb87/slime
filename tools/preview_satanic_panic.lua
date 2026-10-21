local cairo=require('lgi').cairo
package.path='config/awesome/?.lua;'..package.path
local console=require('theme.satanic_panic_shapes')
local w=1600
local surface=cairo.ImageSurface.create(cairo.Format.ARGB32,w,170)
local cr=cairo.Context(surface)
cr:set_source_rgb(0.08,0.06,0.05);cr:paint()
cr:save();cr:translate(12,12);console.background(nil,cr,w-24,70);cr:restore()
for i=1,9 do
    cr:save();cr:translate(40+(i-1)*36,24)
    console.channel(cr,32,40,i,i==3,i<6,false);cr:restore()
end
local function text(x,y,s,size)
    cr:set_source_rgb(0.86,0.76,0.63)
    cr:select_font_face('Liberation Mono',0,1);cr:set_font_size(size or 12)
    cr:move_to(x,y);cr:show_text(s)
end
text(400,49,'SATANIC PANIC / DO NOT PLAY')
for _,meter in ipairs({{800,'CPU',38},{926,'RAM',72}}) do
    cr:save();cr:translate(meter[1],24);console.meter(cr,112,40,meter[2],meter[3]);cr:restore()
end
text(1060,49,'NET ON  VOL 65  BAT 82')
cr:save();cr:translate(1420,24);console.clock(cr,112,40,'21:48');cr:restore()
text(30,115,'SATANIC PANIC',18)
text(30,143,'Production knife silhouette, tarnished steel, dry oxblood crust and aged handle.',12)
surface:write_to_png(arg[1] or 'docs/previews/satanic-panic-bar.png')
