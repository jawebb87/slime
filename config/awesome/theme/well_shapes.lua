-- Moonlit masonry and tentacles. Decoration stays outside the control lane.
local cairo = require('lgi').cairo
local M = {}
local function ink(cr, c, a)
    cr:set_source_rgba(tonumber(c:sub(2,3),16)/255,
        tonumber(c:sub(4,5),16)/255, tonumber(c:sub(6,7),16)/255, a or 1)
end
local function line(cr, x,y, xx,yy, c,a,width)
    ink(cr,c,a); cr:set_line_width(width or 1)
    cr:move_to(x,y); cr:line_to(xx,yy); cr:stroke()
end
local function text(cr,x,y,s,size,c)
    ink(cr,c or '#d9e7ec'); cr:select_font_face('Liberation Mono',0,1)
    cr:set_font_size(size); cr:move_to(x,y); cr:show_text(tostring(s))
end
function M.panel(cr,w,h)
    local cut=math.min(4,w/4,h/4)
    cr:move_to(cut,0); cr:line_to(w-cut,0); cr:line_to(w,cut)
    cr:line_to(w,h-cut); cr:line_to(w-cut,h); cr:line_to(cut,h)
    cr:line_to(0,h-cut); cr:line_to(0,cut); cr:close_path()
end
local function hull(cr,w)
    cr:move_to(18,4)
    for x=62,w-32,83 do
        cr:line_to(x,4); cr:line_to(x+4,7); cr:line_to(x+9,4)
    end
    cr:line_to(w-18,4); cr:line_to(w-4,14); cr:line_to(w-4,50)
    cr:line_to(w-18,60)
    for x=w-65,32,-97 do
        cr:line_to(x,60); cr:line_to(x-5,57); cr:line_to(x-11,60)
    end
    cr:line_to(18,60); cr:line_to(4,50); cr:line_to(4,14); cr:close_path()
end
function M.shape(cr,w,h)
    if w<=0 or h<=0 then return end
    cr:save(); cr:scale(h/64,h/64); hull(cr,w*64/h); cr:restore()
end
local function tentacle(cr,x,y,mirror)
    cr:save(); cr:translate(x,y); cr:scale(mirror,1)
    cr:move_to(0,0); cr:curve_to(28,-17,66,13,91,1)
    cr:curve_to(110,-10,98,-24,88,-15)
    cr:curve_to(80,-8,91,-5,93,-11)
    cr:curve_to(89,-7,87,-13,91,-15)
    cr:curve_to(100,-19,103,-7,91,-4)
    cr:curve_to(64,4,34,-24,0,-10); cr:close_path()
    ink(cr,'#332e3b'); cr:fill_preserve()
    ink(cr,'#7f94a4',0.7); cr:set_line_width(0.8); cr:stroke()
    for i=1,7 do
        local xx=i*10; local yy=-8+math.sin(i*0.75)*4
        ink(cr,'#ac9da9',0.6); cr:arc(xx,yy,1.6,0,math.pi*2); cr:fill()
    end
    cr:restore()
end
function M.background(_,cr,w,h)
    if w<=0 or h<=0 then return end
    cr:save(); local scale=h/64; cr:scale(scale,scale); w=w/scale
    hull(cr,w); cr:clip()
    local stone=cairo.Pattern.create_linear(0,0,0,64)
    stone:add_color_stop_rgb(0,0.17,0.23,0.26)
    stone:add_color_stop_rgb(0.26,0.055,0.09,0.11)
    stone:add_color_stop_rgb(0.73,0.035,0.065,0.08)
    stone:add_color_stop_rgb(1,0.12,0.19,0.20)
    cr:set_source(stone); cr:paint()
    for _,y in ipairs({12,52}) do
        line(cr,7,y,w-7,y,'#9bb9cb',0.23)
        for x=20,w-10,57 do
            local xx=x+(y==52 and 24 or 0)
            line(cr,xx,y,xx+3,y==12 and 4 or 60,'#03080b',0.8,2)
            line(cr,xx+4,y,xx+6,y==12 and 4 or 60,'#b9d4df',0.17)
        end
    end
    -- Fixed wet stone flecks and sparse moss on the rim, never behind labels.
    for i=1,math.floor(w/9) do
        local x=(i*37)%(w-16)+8; local y=i%2==0 and 7 or 56
        ink(cr,i%5==0 and '#9bb789' or '#b9d4df',i%5==0 and 0.35 or 0.18)
        cr:rectangle(x,y+(i%3),1+i%3,1); cr:fill()
    end
    tentacle(cr,7,24,1); tentacle(cr,w-7,57,-1)
    -- A pair of eyes at each end, emerging from the shaft.
    for _,x in ipairs({17,w-23}) do
        ink(cr,'#79c9c3',0.12); cr:arc(x+3,34,7,0,math.pi*2); cr:fill()
        for _,dx in ipairs({0,6}) do
            ink(cr,'#a9eee2',0.95); cr:arc(x+dx,34,1.2,0,math.pi*2); cr:fill()
        end
    end
    cr:restore()
end
function M.channel(cr,w,h,index,selected,occupied,urgent)
    cr:save(); cr:scale(w/32,h/40)
    local c=urgent and '#cd8792' or (selected and '#79c9c3' or '#4c6871')
    ink(cr,'#050b0f'); cr:arc(16,20,13,0,math.pi*2); cr:fill()
    ink(cr,c,selected and 1 or 0.8); cr:set_line_width(2)
    cr:arc(16,20,13,0,math.pi*2); cr:stroke()
    for i=0,7 do
        local a=i*math.pi/4
        line(cr,16+11*math.cos(a),20+11*math.sin(a),
            16+15*math.cos(a),20+15*math.sin(a),'#92a6ae',0.55)
    end
    if selected then
        ink(cr,'#79c9c3',0.16); cr:arc(16,20,9,0,math.pi*2); cr:fill()
    end
    text(cr,12,24,index,12,selected and '#f0f7fa' or '#92a6ae')
    if occupied then line(cr,12,37,20,37,'#9bb789',1,2) end
    cr:restore()
end
function M.level(v)
    return math.min(12,math.max(0,math.ceil((tonumber(v) or 0)*12/100)))
end
function M.meter(cr,w,h,name,v)
    cr:save(); cr:scale(w/112,h/40)
    v=math.min(100,math.max(0,tonumber(v) or 0))
    text(cr,3,13,name,9,'#b9d4df'); text(cr,77,13,math.floor(v)..'%',9)
    for i=1,12 do
        local c=i>9 and '#cd8792' or '#79c9c3'
        ink(cr,i<=M.level(v) and c or '#354c54',i<=M.level(v) and 0.9 or 0.6)
        cr:arc(6+(i-1)*9,27,2.6,0,math.pi*2); cr:fill()
    end
    line(cr,3,34,108,34,'#9bb9cb',0.25)
    cr:restore()
end
function M.clock(cr,w,h,time)
    cr:save(); cr:scale(w/112,h/40)
    M.panel(cr,112,40); ink(cr,'#080f13',0.8); cr:fill()
    line(cr,8,3,104,3,'#9bb9cb',0.6)
    line(cr,8,37,104,37,'#79c9c3',0.4)
    text(cr,8,28,time,23,'#d9e7ec'); cr:restore()
end
return M
