-- Tarnished steel and dry, matte oxblood deposits; stable texture on redraw.
local cairo=require('lgi').cairo
local M={}
local function ink(cr,c,a)
 cr:set_source_rgba(tonumber(c:sub(2,3),16)/255,tonumber(c:sub(4,5),16)/255,tonumber(c:sub(6,7),16)/255,a or 1)
end
local function grain(n) local x=math.sin(n*127.1)*43758.5453;return x-math.floor(x) end
local function text(cr,x,y,s,size,c)
 ink(cr,c or '#dbc3a0');cr:select_font_face('Liberation Mono',0,1);cr:set_font_size(size);cr:move_to(x,y);cr:show_text(tostring(s))
end
function M.panel(cr,w,h) cr:rectangle(0,0,w,h) end
function M.shape(cr,w,h)
 cr:move_to(2,h-8);cr:curve_to(15,h*0.52,31,13,57,8)
 cr:line_to(w-177,8);cr:line_to(w-177,3);cr:line_to(w-163,3)
 cr:line_to(w-163,13);cr:line_to(w-12,13);cr:line_to(w-3,20)
 cr:line_to(w-3,h-17);cr:line_to(w-12,h-10);cr:line_to(w-163,h-10)
 cr:line_to(w-163,h-3);cr:line_to(w-177,h-3);cr:line_to(w-177,h-12)
 cr:curve_to(w*0.55,h-5,w*0.2,h-5,2,h-8);cr:close_path()
end
function M.background(_,cr,w,h)
 cr:save();M.shape(cr,w,h);cr:clip()
 local steel=cairo.Pattern.create_linear(0,8,0,h-6)
 steel:add_color_stop_rgb(0,0.32,0.32,0.29);steel:add_color_stop_rgb(0.30,0.19,0.20,0.18)
 steel:add_color_stop_rgb(0.76,0.25,0.26,0.23);steel:add_color_stop_rgb(1,0.52,0.49,0.41)
 cr:set_source(steel);cr:paint()
 -- Long grinding marks and scattered pits, with a clear central reading lane.
 for i=1,math.floor(w*0.5) do
  local x=grain(i)*w;local y=9+grain(i+700)*(h-18)
  ink(cr,i%2==0 and '#cabda3' or '#121312',0.06+grain(i+80)*0.12)
  cr:set_line_width(0.4);cr:move_to(x,y);cr:line_to(x+3+grain(i+50)*28,y-0.5);cr:stroke()
 end
 -- Dry crust collects at the cutting edge, with sparse flakes toward the spine.
 for i=1,math.floor(w*1.1) do
  local x=grain(i+900)*math.max(1,w-175)
  local depth=grain(i+30)^2*12
  local y=h-8-depth
  if i%7==0 then y=9+grain(i+45)*7 end
  local c=({'#351311','#4a1915','#64241a','#7c3423','#22100e'})[i%5+1]
  ink(cr,c,0.65+grain(i+6)*0.35)
  local radius=0.6+grain(i+1)*3
  cr:move_to(x-radius,y)
  cr:line_to(x-radius*0.4,y-radius*0.7);cr:line_to(x+radius*0.8,y-radius*0.5)
  cr:line_to(x+radius,y+radius*0.3);cr:line_to(x,y+radius)
  cr:line_to(x-radius*0.7,y+radius*0.5);cr:close_path();cr:fill()
  if i%3==0 then
   ink(cr,'#171311',0.7);cr:set_line_width(0.5)
   cr:move_to(x-radius,y+0.5);cr:line_to(x+radius*0.5,y-0.5);cr:stroke()
  end
  if i%4==0 then
   ink(cr,'#ad7950',0.35);cr:rectangle(x,y,radius,0.5);cr:fill()
  end
 end
 -- Dark aged handle, steel guard, and two recessed rivets.
 ink(cr,'#211815');cr:rectangle(w-165,10,165,h-18);cr:fill()
 for x=w-158,w-10,5 do
  ink(cr,'#76503a',0.14+grain(x)*0.15);cr:set_line_width(1)
  cr:move_to(x,15);cr:line_to(x-3,h-13);cr:stroke()
 end
 ink(cr,'#777367');cr:rectangle(w-177,3,13,h-6);cr:fill()
 for _,x in ipairs({w-151,w-16}) do
  ink(cr,'#0d0c0b');cr:arc(x,h/2,4,0,math.pi*2);cr:fill()
  ink(cr,'#8c806a');cr:arc(x-0.5,h/2-0.5,2.5,0,math.pi*2);cr:fill()
 end
 cr:restore()
 M.shape(cr,w,h);ink(cr,'#998a70',0.6);cr:set_line_width(0.8);cr:stroke()
end
function M.channel(cr,w,h,index,selected,occupied,urgent)
 cr:save();cr:scale(w/32,h/40)
 ink(cr,selected and '#763329' or '#171715',selected and 1 or 0.7);cr:rectangle(2,6,28,28);cr:fill()
 ink(cr,urgent and '#d65a3d' or '#8c806a',0.8);cr:set_line_width(1);cr:rectangle(2,6,28,28);cr:stroke()
 text(cr,11,25,index,13,selected and '#f0d6b0' or '#c7b89e')
 if occupied then ink(cr,'#c38d52');cr:rectangle(12,30,8,2);cr:fill() end
 cr:restore()
end
function M.level(v) return math.min(12,math.max(0,math.ceil((tonumber(v) or 0)*12/100))) end
function M.meter(cr,w,h,name,v)
 cr:save();cr:scale(w/112,h/40)
 v=math.min(100,math.max(0,tonumber(v) or 0))
 text(cr,3,14,name,9);text(cr,79,14,math.floor(v)..'%',9)
 for i=1,12 do
  ink(cr,i<=M.level(v) and (i>9 and '#b63d30' or '#b29a70') or '#575348')
  cr:rectangle(3+(i-1)*9,23,6,9);cr:fill()
 end
 cr:restore()
end
function M.clock(cr,w,h,time)
 cr:save();cr:scale(w/112,h/40)
 ink(cr,'#171311',0.85);cr:rectangle(0,3,112,34);cr:fill()
 text(cr,7,28,time,23,'#d4a78a');cr:restore()
end
return M
