-- Punk Show: rack metal, channel switches, VU LEDs and seven-segment digits.
local cairo = require('lgi').cairo
local M = {}
local function ink(cr, hex, alpha)
    cr:set_source_rgba(tonumber(hex:sub(2,3),16)/255,
        tonumber(hex:sub(4,5),16)/255,tonumber(hex:sub(6,7),16)/255,alpha or 1)
end
function M.panel(cr,w,h)
    local c=math.min(3,w/4,h/4)
    cr:move_to(c,0);cr:line_to(w-c,0);cr:line_to(w,c);cr:line_to(w,h-c)
    cr:line_to(w-c,h);cr:line_to(c,h);cr:line_to(0,h-c);cr:line_to(0,c);cr:close_path()
end
local function label(cr,x,y,text,size,hex)
    ink(cr,hex or '#ddd7c0')
    cr:select_font_face('Liberation Mono',cairo.FontSlant.NORMAL,cairo.FontWeight.BOLD)
    cr:set_font_size(size);cr:move_to(x,y);cr:show_text(text)
end
function M.background(_,cr,w,h)
    if w<=0 or h<=0 then return end
    cr:save();M.panel(cr,w,h);cr:clip()
    local p=cairo.Pattern.create_linear(0,0,0,h)
    p:add_color_stop_rgb(0,0.25,0.25,0.23)
    p:add_color_stop_rgb(0.25,0.12,0.13,0.12)
    p:add_color_stop_rgb(1,0.06,0.07,0.06)
    cr:set_source(p);cr:paint()
    for y=3,h,4 do
        ink(cr,'#ddd7c0',0.025);cr:rectangle(20,y,math.max(0,w-40),1);cr:fill()
    end
    for x=30,w-30,47 do
        ink(cr,'#c5bda5',0.16);cr:set_line_width(0.7)
        local y=(x*13)%math.max(1,math.floor(h-6))+3
        cr:move_to(x,y);cr:line_to(math.min(w-20,x+10),y-2);cr:stroke()
    end
    -- Rack ears and slotted mounting screws.
    for _,x in ipairs({0,w-19}) do
        ink(cr,'#44443b');cr:rectangle(x,0,19,h);cr:fill()
        for _,y in ipairs({10,h-10}) do
            ink(cr,'#111310');cr:arc(x+9.5,y,4.5,0,math.pi*2);cr:fill()
            ink(cr,'#a19b87');cr:arc(x+9.5,y,3,0,math.pi*2);cr:fill()
            ink(cr,'#20231c');cr:set_line_width(1.3)
            cr:move_to(x+7,y+1);cr:line_to(x+12,y-1);cr:stroke()
        end
    end
    ink(cr,'#8f8b76',0.65);cr:rectangle(20,1,math.max(0,w-40),1);cr:fill()
    ink(cr,'#050705');cr:rectangle(20,h-2,math.max(0,w-40),2);cr:fill()
    cr:restore()
end
function M.channel(cr,w,h,index,selected,occupied,urgent)
    cr:save();cr:scale(w/32,h/40)
    ink(cr,'#080a08');cr:rectangle(1,1,30,38);cr:fill()
    ink(cr,selected and '#8e3335' or '#44473d');cr:rectangle(3,3,26,24);cr:fill()
    ink(cr,selected and '#d7655b' or '#7e8070');cr:rectangle(3,3,26,2);cr:fill()
    ink(cr,'#191c17');cr:rectangle(3,25,26,2);cr:fill()
    ink(cr,urgent and '#ef4148' or (selected and '#ef4148' or (occupied and '#91ad6e' or '#293124')))
    cr:arc(16,9,2,0,math.pi*2);cr:fill()
    label(cr,8,22,string.format('%02d',tonumber(index) or 0),11,selected and '#fff0d7' or '#d6d2b9')
    ink(cr,'#c7bfa2');cr:rectangle(3,30,26,7);cr:fill()
    label(cr,7,36,'CH',6,'#25271f')
    cr:restore()
end
function M.level(value)
    return math.min(12,math.max(0,math.ceil((tonumber(value) or 0)*12/100)))
end
function M.meter(cr,w,h,name,value)
    cr:save();cr:scale(w/112,h/40)
    ink(cr,'#090c08');cr:rectangle(0,0,112,40);cr:fill()
    label(cr,5,12,name,9,'#ddd7c0')
    label(cr,77,12,string.format('%3d',math.floor(math.min(100,math.max(0,tonumber(value) or 0)))),9,'#c7c4a8')
    local lit=M.level(value)
    for i=1,12 do
        local color=i>10 and '#ef4148' or (i>8 and '#d1ac63' or '#91ad6e')
        ink(cr,color,i<=lit and 1 or 0.13)
        cr:rectangle(5+(i-1)*8.5,18,6,14);cr:fill()
        if i<=lit then ink(cr,'#ffffff',0.16);cr:rectangle(5+(i-1)*8.5,18,6,2);cr:fill() end
    end
    cr:restore()
end
M.digits={['0']='abcdef',['1']='bc',['2']='abdeg',['3']='abcdg',['4']='bcfg',
    ['5']='acdfg',['6']='acdefg',['7']='abc',['8']='abcdefg',['9']='abcdfg'}
local segments={a={3,1,14,1},b={18,4,1,11},c={18,20,1,11},d={3,34,14,1},
    e={1,20,1,11},f={1,4,1,11},g={3,17,14,1}}
function M.clock(cr,w,h,time)
    cr:save();cr:scale(w/112,h/40)
    ink(cr,'#100909');cr:rectangle(0,0,112,40);cr:fill()
    local x=5
    for char in time:gmatch('.') do
        if char==':' then
            ink(cr,'#ef4148');cr:rectangle(x+1,13,3,3);cr:rectangle(x+1,25,3,3);cr:fill();x=x+9
        elseif M.digits[char] then
            for key,s in pairs(segments) do
                ink(cr,'#ff4149',M.digits[char]:find(key,1,true) and 1 or 0.08)
                cr:rectangle(x+s[1],2+s[2],s[3]+1,s[4]+1);cr:fill()
            end
            x=x+23
        end
    end
    cr:restore()
end
return M
