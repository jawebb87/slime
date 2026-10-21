-- Holographic glass, fractured wireframe edges, and fixed VHS interference.
local cairo=require('lgi').cairo
local M={}
local function ink(cr,c,a)
 cr:set_source_rgba(tonumber(c:sub(2,3),16)/255,tonumber(c:sub(4,5),16)/255,tonumber(c:sub(6,7),16)/255,a or 1)
end
local function line(cr,x,y,xx,yy,c,a,width)
 ink(cr,c,a);cr:set_line_width(width or 1);cr:move_to(x,y);cr:line_to(xx,yy);cr:stroke()
end
local function text(cr,x,y,s,size,c)
 ink(cr,c or '#f0ddff');cr:select_font_face('Liberation Mono',0,1)
 cr:set_font_size(size);cr:move_to(x,y);cr:show_text(tostring(s))
end
local function outline(cr,w,h)
 local cut=math.min(7,w/4,h/4)
 cr:move_to(cut,0);cr:line_to(w-cut,0);cr:line_to(w,cut)
 cr:line_to(w,h-cut);cr:line_to(w-cut,h);cr:line_to(cut,h)
 cr:line_to(0,h-cut);cr:line_to(0,cut);cr:close_path()
end
function M.panel(cr,w,h) outline(cr,w,h) end
local function hull(cr,w)
 cr:move_to(15,4);cr:line_to(w*0.27,4);cr:line_to(w*0.27+5,7)
 cr:line_to(w*0.27+39,7);cr:line_to(w*0.27+43,3)
 cr:line_to(w-19,3);cr:line_to(w-4,14);cr:line_to(w-4,44)
 cr:line_to(w-10,44);cr:line_to(w-10,51);cr:line_to(w-22,60)
 cr:line_to(w*0.68+25,60);cr:line_to(w*0.68+21,56)
 cr:line_to(w*0.68,56);cr:line_to(w*0.68-4,60)
 cr:line_to(16,60);cr:line_to(4,50);cr:line_to(4,16);cr:close_path()
end
function M.shape(cr,w,h)
 cr:save();local scale=h/64;cr:scale(scale,scale);hull(cr,w/scale);cr:restore()
end
function M.background(_,cr,w,h)
 if w<=0 or h<=0 then return end
 cr:save();local scale=h/64;cr:scale(scale,scale);w=w/scale
 hull(cr,w);cr:clip()
 local glass=cairo.Pattern.create_linear(0,0,w,64)
 glass:add_color_stop_rgb(0,0.16,0.07,0.25)
 glass:add_color_stop_rgb(0.48,0.07,0.05,0.17)
 glass:add_color_stop_rgb(1,0.05,0.17,0.24)
 cr:set_source(glass);cr:paint()
 -- Horizon wireframe lives along the rim, leaving the control lane quiet.
 for x=12,w-8,28 do
  line(cr,x,5,x+12,13,'#ff55c8',0.28,0.65)
  line(cr,x,59,x+12,51,'#61e5f5',0.28,0.65)
 end
 for _,y in ipairs({6,10,54,58}) do
  line(cr,8,y,w-8,y,y<20 and '#ff55c8' or '#61e5f5',0.20,0.65)
 end
 -- Scanlines remain static and faint, with no flashing or animated displacement.
 for y=15,50,3 do line(cr,6,y,w-6,y,'#b68bf3',0.045,0.65) end
 -- Separate color channels along broken portions of the hologram's perimeter.
 for _,edge in ipairs({{18,0.18},{w*0.21,0.42},{w*0.49,0.73},{w*0.80,0.97}}) do
  local x=edge[1];local xx=w*edge[2]
  line(cr,x,5,xx,5,'#ff55c8',0.15,5)
  line(cr,x,5,xx,5,'#ff55c8',0.9,1.2)
  line(cr,x+4,7,xx+4,7,'#61e5f5',0.55,0.7)
 end
 for x=22,w-35,89 do
  line(cr,x,59,x+58,59,'#61e5f5',0.8,1)
  line(cr,x+9,57,x+65,57,'#ff55c8',0.4,0.7)
 end
 line(cr,5,17,5,48,'#ff55c8',0.85,1)
 line(cr,w-5,15,w-5,42,'#61e5f5',0.9,1)
 -- Displaced little tiles echo the dissolving pyramid in the supplied wallpaper.
 for i=1,math.floor(w/110) do
  local x=31+i*107;local y=i%2==0 and 8 or 52
  ink(cr,i%3==0 and '#ffba8c' or '#bc87ff',0.48)
  cr:rectangle(x,y,9+(i%4)*3,1.5);cr:fill()
  ink(cr,'#61e5f5',0.32);cr:rectangle(x+19,y+2,4,3);cr:fill()
 end
 cr:restore()
end
function M.channel(cr,w,h,index,selected,occupied,urgent)
 cr:save();cr:scale(w/32,h/40)
 local color=urgent and '#ff719f' or (selected and '#ff55c8' or '#61e5f5')
 outline(cr,32,40);ink(cr,selected and '#46205e' or '#17102e',0.9);cr:fill()
 -- Pyramid outline and offset color ghost, with a numeral on the front face.
 line(cr,3,32,16,7,color,selected and 1 or 0.48)
 line(cr,16,7,29,32,color,selected and 1 or 0.48)
 line(cr,3,32,29,32,color,selected and 1 or 0.48)
 line(cr,17,8,30,33,'#bc87ff',0.4)
 text(cr,12,28,index,11,selected and '#fff0fd' or '#d6c5f0')
 if occupied then line(cr,11,36,22,36,'#61e5f5',0.9,1.5) end
 if selected then line(cr,5,39,28,39,'#ff55c8',1,1.5) end
 cr:restore()
end
function M.level(v) return math.min(12,math.max(0,math.ceil((tonumber(v) or 0)*12/100))) end
function M.meter(cr,w,h,name,v)
 cr:save();cr:scale(w/112,h/40)
 v=math.min(100,math.max(0,tonumber(v) or 0))
 text(cr,3,13,name,9,'#b1e5ff');text(cr,77,13,math.floor(v)..'%',9)
 for i=1,12 do
  local color=i>9 and '#ff55c8' or '#61e5f5'
  ink(cr,i<=M.level(v) and color or '#493166',i<=M.level(v) and 0.9 or 0.6)
  cr:rectangle(3+(i-1)*9,24,6,8);cr:fill()
  if i<=M.level(v) then line(cr,3+(i-1)*9,22,9+(i-1)*9,22,color,0.3) end
 end
 cr:restore()
end
function M.clock(cr,w,h,time)
 cr:save();cr:scale(w/112,h/40)
 outline(cr,112,40);ink(cr,'#17102e',0.9);cr:fill()
 line(cr,8,2,101,2,'#ff55c8',0.8)
 line(cr,11,38,104,38,'#61e5f5',0.8)
 text(cr,8,28,time,23,'#f0ddff');cr:restore()
end
return M
