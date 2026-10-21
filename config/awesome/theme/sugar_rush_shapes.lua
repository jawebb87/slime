-- Sugar Rush: frosting, candy-chain teeth, jellybean tags, and sprinkle meters.
local cairo=require('lgi').cairo
local M={}
local function ink(cr,hex,a)
    cr:set_source_rgba(tonumber(hex:sub(2,3),16)/255,
        tonumber(hex:sub(4,5),16)/255,tonumber(hex:sub(6,7),16)/255,a or 1)
end
local function round(cr,x,y,w,h,r)
    r=math.min(r,w/2,h/2)
    cr:new_sub_path();cr:arc(x+w-r,y+r,r,-math.pi/2,0)
    cr:arc(x+w-r,y+h-r,r,0,math.pi/2)
    cr:arc(x+r,y+h-r,r,math.pi/2,math.pi)
    cr:arc(x+r,y+r,r,math.pi,math.pi*1.5);cr:close_path()
end
function M.panel(cr,w,h) round(cr,0,0,w,h,9) end
function M.shape(cr,w,h)
    if w<=0 or h<=0 then return end
    local r=math.min(18,h/4,w/4);local base=h-13
    cr:move_to(r,2);cr:line_to(w-r,2)
    cr:curve_to(w,2,w,base,w-r,base)
    local count=math.max(1,math.floor((w-2*r)/20))
    local tooth=(w-2*r)/count
    for i=0,count-1 do
        local x=w-r-i*tooth
        cr:curve_to(x-tooth*0.18,h+1,x-tooth*0.82,h+1,x-tooth,base)
    end
    cr:curve_to(0,base,0,2,r,2);cr:close_path()
end
local function heart(cr,x,y,size)
    cr:move_to(x,y+size)
    cr:curve_to(x-size*1.8,y,x-size*0.6,y-size,x,y-size*0.25)
    cr:curve_to(x+size*0.6,y-size,x+size*1.8,y,x,y+size)
    cr:close_path()
end
local function text(cr,x,y,s,size,color)
    ink(cr,color or '#603575');cr:select_font_face('DejaVu Sans',0,1)
    cr:set_font_size(size);cr:move_to(x,y);cr:show_text(s)
end
function M.background(_,cr,w,h)
    if w<=0 or h<=0 then return end
    cr:save();M.shape(cr,w,h);cr:clip()
    ink(cr,'#c6a3e8');cr:paint()
    round(cr,1,3,w-2,h-17,18)
    local p=cairo.Pattern.create_linear(0,3,0,h-14)
    p:add_color_stop_rgb(0,1,0.94,0.99);p:add_color_stop_rgb(1,0.96,0.77,0.92)
    cr:set_source(p);cr:fill()
    -- Fixed sprinkles stay on the frosting rim, clear of controls.
    local colors={'#acdbc8','#d49be4','#f2a8c5','#f4d98b'}
    for x=42,w-30,37 do
        local i=math.floor(x/37)%4+1
        ink(cr,colors[i]);cr:set_line_width(2);cr:set_line_cap(cairo.LineCap.ROUND)
        cr:move_to(x,7);cr:line_to(x+4,9);cr:stroke()
    end
    ink(cr,'#ffffff',0.75);cr:move_to(24,4);cr:line_to(w-24,4);cr:set_line_width(2);cr:stroke()
    -- Two eyes and a smile give the blade the wallpaper's absurdly cute face.
    ink(cr,'#603575')
    for _,x in ipairs({16,28}) do cr:arc(x,29,2,0,math.pi*2);cr:fill() end
    cr:arc(22,34,3,0,math.pi);cr:set_line_width(1.5);cr:stroke()
    cr:restore()
    M.shape(cr,w,h);ink(cr,'#9d6aac');cr:set_line_width(1.5);cr:stroke()
end
function M.channel(cr,w,h,index,selected,occupied,urgent)
    cr:save();cr:scale(w/32,h/40)
    local fill=urgent and '#f5c4dc' or (selected and '#eba2d2' or (occupied and '#c9eee0' or '#f9efff'))
    round(cr,2,6,28,29,11);ink(cr,fill);cr:fill_preserve()
    ink(cr,'#a572b7');cr:set_line_width(1);cr:stroke()
    if selected then
        heart(cr,16,10,5);ink(cr,'#af467f');cr:fill()
        text(cr,12,28,tostring(index),11,'#603575')
    else
        text(cr,12,26,tostring(index),11,'#76518a')
        ink(cr,'#ffffff',0.85);cr:arc(9,12,2,0,math.pi*2);cr:fill()
    end
    cr:restore()
end
function M.level(value) return math.min(12,math.max(0,math.ceil((tonumber(value) or 0)*12/100))) end
function M.meter(cr,w,h,name,value)
    cr:save();cr:scale(w/112,h/40)
    round(cr,0,2,112,36,10);ink(cr,'#fff2fc');cr:fill()
    text(cr,5,14,name,8,'#76518a')
    text(cr,81,14,string.format('%d',math.floor(math.min(100,math.max(0,tonumber(value) or 0)))),8,'#603575')
    local count=M.level(value)
    for i=1,12 do
        local col=i>10 and '#b74c85' or (i>8 and '#b68a39' or '#45836b')
        ink(cr,i<=count and col or '#e6d9ee')
        cr:arc(6+(i-1)*9,26,3,0,math.pi*2);cr:fill()
        if i<=count then ink(cr,'#ffffff',0.65);cr:arc(5.2+(i-1)*9,25.1,0.8,0,math.pi*2);cr:fill() end
    end
    cr:restore()
end
function M.clock(cr,w,h,time)
    cr:save();cr:scale(w/112,h/40)
    round(cr,0,1,112,38,13);ink(cr,'#e4cdf6');cr:fill_preserve()
    ink(cr,'#a572b7');cr:set_line_width(1);cr:stroke()
    text(cr,9,28,time,23,'#753e8c')
    cr:restore()
end
return M
