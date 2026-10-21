-- Security console: static chassis, live workspace indicators and telemetry.
local cairo = require('lgi').cairo
local M = {}
local function ink(cr,c,a)
    cr:set_source_rgba(tonumber(c:sub(2,3),16)/255,
        tonumber(c:sub(4,5),16)/255,tonumber(c:sub(6,7),16)/255,a or 1)
end
local function line(cr,x,y,xx,yy,c,a,width)
    ink(cr,c,a); cr:set_line_width(width or 1)
    cr:move_to(x,y); cr:line_to(xx,yy); cr:stroke()
end
local function text(cr,x,y,s,size,c)
    ink(cr,c or '#d8e1e5'); cr:select_font_face('Liberation Mono',0,1)
    cr:set_font_size(size); cr:move_to(x,y); cr:show_text(tostring(s))
end
function M.panel(cr,w,h)
    local cut=math.min(3,w/4,h/4)
    cr:move_to(cut,0); cr:line_to(w-cut,0); cr:line_to(w,cut)
    cr:line_to(w,h-cut); cr:line_to(w-cut,h); cr:line_to(cut,h)
    cr:line_to(0,h-cut); cr:line_to(0,cut); cr:close_path()
end
local function hull(cr,w)
    cr:move_to(10,3); cr:line_to(w-10,3); cr:line_to(w-3,10)
    cr:line_to(w-3,70); cr:line_to(w-10,77); cr:line_to(10,77)
    cr:line_to(3,70); cr:line_to(3,10); cr:close_path()
end
function M.shape(cr,w,h)
    if w<=0 or h<=0 then return end
    cr:save(); cr:scale(h/80,h/80); hull(cr,w*80/h); cr:restore()
end
function M.background(_,cr,w,h)
    if w<=0 or h<=0 then return end
    cr:save(); local scale=h/80; cr:scale(scale,scale); w=w/scale
    hull(cr,w); cr:clip()
    local metal=cairo.Pattern.create_linear(0,0,0,80)
    metal:add_color_stop_rgb(0,0.17,0.21,0.24)
    metal:add_color_stop_rgb(0.3,0.055,0.075,0.09)
    metal:add_color_stop_rgb(0.8,0.04,0.055,0.07)
    metal:add_color_stop_rgb(1,0.12,0.15,0.17)
    cr:set_source(metal); cr:paint()
    ink(cr,'#1a2228'); cr:rectangle(3,3,w-6,18); cr:fill()
    line(cr,12,21,w-12,21,'#526570',0.8)
    line(cr,12,66,w-12,66,'#526570',0.8)
    -- Header and footer are outside the forty-pixel interactive control lane.
    text(cr,22,15,'SCP / SECURITY OPERATIONS',9,'#d8e1e5')
    if w>850 then text(cr,w/2-72,15,'SECURE. CONTAIN. PROTECT.',8,'#93a3ad') end
    if w>520 then text(cr,w-210,15,'AUTHORIZED PERSONNEL ONLY',8,'#d5af58') end
    text(cr,22,74,'CAMERA MATRIX / WORKSPACES',7,'#93a3ad')
    if w>700 then text(cr,w-275,74,'LOCAL TELEMETRY  /  STATION TIME',7,'#93a3ad') end
    -- Hazard markings confined to the ends; no blinking or fake status readouts.
    for _,x in ipairs({5,w-10}) do
        for y=25,60,8 do
            line(cr,x,y,x+4,y+4,'#d5af58',0.7,2)
        end
    end
    for _,x in ipairs({11,w-11}) do
        for _,y in ipairs({11,70}) do
            ink(cr,'#526570'); cr:arc(x,y,2,0,math.pi*2); cr:fill()
            line(cr,x-1,y,x+1,y,'#06090b',1)
        end
    end
    line(cr,280,4,math.max(282,w-240),4,'#d6584d',0.75,2)
    cr:restore()
end
function M.channel(cr,w,h,index,selected,occupied,urgent)
    cr:save(); cr:scale(w/40,h/40)
    local c=urgent and '#d5af58' or (selected and '#d6584d' or '#526570')
    M.panel(cr,40,40); ink(cr,selected and '#321b1c' or '#10181d'); cr:fill_preserve()
    ink(cr,c); cr:set_line_width(1); cr:stroke()
    text(cr,4,9,'CAM',6,'#93a3ad')
    local number=tonumber(index)
    text(cr,7,28,number and string.format('%02d',number) or index,17,
        selected and '#f0f4f5' or '#b9cbd2')
    -- Green means occupied, red selected, amber urgent; never a fictional feed.
    ink(cr,urgent and '#d5af58' or (occupied and '#8cba99' or '#3b4b55'))
    cr:arc(33,7,2,0,math.pi*2); cr:fill()
    line(cr,5,35,35,35,c,selected and 1 or 0.4,2)
    cr:restore()
end
function M.level(v)
    return math.min(12,math.max(0,math.ceil((tonumber(v) or 0)*12/100)))
end
function M.meter(cr,w,h,name,v)
    cr:save(); cr:scale(w/112,h/40)
    v=math.min(100,math.max(0,tonumber(v) or 0))
    M.panel(cr,112,40); ink(cr,'#0b0f12',0.9); cr:fill()
    text(cr,5,12,name,9,'#8dbdc9'); text(cr,79,12,math.floor(v)..'%',9)
    for i=1,12 do
        local c=i>10 and '#ff7564' or (i>8 and '#d5af58' or '#8dbdc9')
        ink(cr,i<=M.level(v) and c or '#26333b')
        cr:rectangle(5+(i-1)*8.5,20,6,10); cr:fill()
    end
    line(cr,5,34,106,34,'#526570',0.6)
    cr:restore()
end
function M.clock(cr,w,h,time)
    cr:save(); cr:scale(w/112,h/40)
    M.panel(cr,112,40); ink(cr,'#0b0f12'); cr:fill()
    line(cr,1,2,1,38,'#d6584d',1,2)
    text(cr,9,9,'STATION / LOCAL',6,'#93a3ad')
    text(cr,8,32,time,23,'#d8e1e5'); cr:restore()
end
return M
