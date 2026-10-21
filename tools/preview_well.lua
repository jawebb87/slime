local cairo=require('lgi').cairo
package.path='config/awesome/?.lua;'..package.path
local console=require('theme.well_shapes')
local w=1600
local surface=cairo.ImageSurface.create(cairo.Format.ARGB32,w,170)
local cr=cairo.Context(surface)
cr:set_source_rgb(0.03,0.055,0.07);cr:paint()
cr:save();cr:translate(12,12);console.background(nil,cr,w-24,64);cr:restore()
for i=1,9 do
    cr:save();cr:translate(40+(i-1)*36,24)
    console.channel(cr,32,40,i,i==3,i<6,false);cr:restore()
end
local function text(x,y,s,size)
    cr:set_source_rgb(0.85,0.91,0.93)
    cr:select_font_face('Liberation Mono',0,1);cr:set_font_size(size or 12)
    cr:move_to(x,y);cr:show_text(s)
end
text(400,49,'THE WELL / SOMETHING ANSWERED')
for _,meter in ipairs({{800,'CPU',38},{926,'RAM',72}}) do
    cr:save();cr:translate(meter[1],24);console.meter(cr,112,40,meter[2],meter[3]);cr:restore()
end
text(1060,49,'NET ON  VOL 65  BAT 82')
cr:save();cr:translate(1420,24);console.clock(cr,112,40,'21:48');cr:restore()
text(30,115,'THE MOONLIT WELL',18)
text(30,143,'Wet stone rim, well-ring workspaces, spectral eyes and curling tentacles.',12)
surface:write_to_png(arg[1] or 'docs/previews/moonlit-well-bar.png')
