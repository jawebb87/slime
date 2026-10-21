-- Deterministic broken wax strokes: no animation or random flicker on redraw.
local cairo=require('lgi').cairo
local M={}
local colors={'#c64976','#c77623','#b69c13','#43812e','#246d9b','#79508e'}
local function ink(cr,c,a)
 cr:set_source_rgba(tonumber(c:sub(2,3),16)/255,tonumber(c:sub(4,5),16)/255,tonumber(c:sub(6,7),16)/255,a or 1)
end
-- Coordinate-seeded grain keeps the wax deposits stable between redraws.
local function grain(n)
 local v=math.sin(n*127.1+311.7)*43758.5453
 return v-math.floor(v)
end
local function wax(cr,x,y,xx,yy,c,width)
 local dx,dy=xx-x,yy-y
 local length=math.sqrt(dx*dx+dy*dy)
 if length==0 then return end
 local nx,ny=-dy/length,dx/length
 local seed=x*17+y*31+xx*3+yy*7
 cr:set_line_cap(cairo.LineCap.ROUND)
 -- Three distinct pencil passes, each with its own pressure and missing patches.
 for pass=1,3 do
  local offset=(pass-2)*width*0.52+(grain(seed+pass)-0.5)*0.8
  local position=grain(seed+pass*11)*1.8
  local step=0
  while position<length do
   step=step+1
   local n=seed+pass*97+step*13
   local deposit=math.min(length-position,0.7+grain(n)*3.8)
   if grain(n+1)>0.17 then
    local pressure=0.18+grain(n+2)*0.48
    local side=offset+(grain(n+3)-0.5)*width*0.55
    ink(cr,c,pressure);cr:set_line_width(width*(0.16+grain(n+4)*0.27))
    cr:move_to(x+dx*position/length+nx*side,y+dy*position/length+ny*side)
    cr:line_to(x+dx*(position+deposit)/length+nx*side,y+dy*(position+deposit)/length+ny*side)
    cr:stroke()
    -- Isolated crumbs beside the broad deposits leave exposed paper between them.
    local fleck=side+(grain(n+5)-0.5)*width*1.6
    ink(cr,c,pressure*0.7)
    cr:arc(x+dx*position/length+nx*fleck,y+dy*position/length+ny*fleck,
     0.18+grain(n+6)*0.36,0,math.pi*2);cr:fill()
   end
   position=position+deposit+0.25+grain(n+7)*1.8
  end
 end
end
local function hatch(cr,x,y,w,h,c,density)
 -- Short overlapping diagonal passes deliberately overshoot the nominal outline.
 for row=0,math.floor(h/6) do
  for col=0,math.floor(w/5) do
   local n=x*13+y*7+row*101+col*29
   if grain(n)>0.16 then
    local px=x+col*5+(grain(n+1)-0.5)*3
    local py=y+row*6+(grain(n+2)-0.5)*3
    local reach=4+grain(n+3)*6
    wax(cr,px-1,py+3,px+reach*0.7,py-reach*0.65,c,density)
   end
  end
 end
end
local function label(cr,x,y,s,size,c)
 ink(cr,c or '#39382f');cr:select_font_face('DejaVu Sans',cairo.FontSlant.NORMAL,cairo.FontWeight.BOLD)
 cr:set_font_size(size);cr:move_to(x,y);cr:show_text(tostring(s))
end
function M.panel(cr,w,h)
 cr:move_to(4,1);cr:line_to(w-5,0);cr:line_to(w,h-4);cr:line_to(w-4,h);cr:line_to(1,h-1);cr:close_path()
end
function M.shape(cr,w,h)
 cr:move_to(7,3)
 for x=20,w-8,18 do cr:line_to(x,3+math.sin(x*0.19)*1.2) end
 cr:line_to(w-5,4);cr:line_to(w-3,h-6)
 for x=w-8,7,-18 do cr:line_to(x,h-4+math.sin(x*0.17)*1.3) end
 cr:line_to(3,h-6);cr:close_path()
end
function M.background(_,cr,w,h)
 cr:save();M.shape(cr,w,h);cr:clip();ink(cr,'#fffbed');cr:paint()
 -- Paper grain and wax fibers stay fixed across repaints.
 for x=2,w,5 do for y=2,h,5 do
  ink(cr,'#8a806a',0.035+0.025*math.sin(x*7+y*13));cr:rectangle(x,y,1,1);cr:fill()
 end end
 hatch(cr,10,7,w-22,2,'#246d9b',1.1)
 hatch(cr,10,h-8,w-22,2,'#43812e',1.1)
 wax(cr,8,7,w-9,7,'#246d9b',3)
 wax(cr,9,h-8,w-10,h-8,'#43812e',4)
 wax(cr,7,9,7,h-9,'#b69c13',4);wax(cr,w-8,9,w-8,h-9,'#c77623',4)
 cr:restore()
end
function M.channel(cr,w,h,index,selected,occupied,urgent)
 cr:save();cr:scale(w/32,h/40)
 local c=urgent and '#b84435' or colors[((tonumber(index) or 1)-1)%#colors+1]
 if selected or occupied then
  hatch(cr,5,9,21,22,c,selected and 2.5 or 1.1)
 end
 wax(cr,3,6,28,5,c,2);wax(cr,28,5,29,34,c,2)
 wax(cr,29,34,4,35,c,2);wax(cr,4,35,3,6,c,2)
 label(cr,11,26,index,14,'#263b42')
 if selected then wax(cr,6,39,27,38,'#263b42',2) end
 cr:restore()
end
function M.level(value) return math.min(12,math.max(0,math.ceil((tonumber(value) or 0)*12/100))) end
function M.meter(cr,w,h,name,value)
 cr:save();cr:scale(w/112,h/40)
 value=math.min(100,math.max(0,tonumber(value) or 0))
 label(cr,3,13,name,9);label(cr,77,13,math.floor(value)..'%',9)
 for i=1,12 do
  wax(cr,4+(i-1)*9,33,9+(i-1)*9,21,i<=M.level(value) and (i>10 and '#b84435' or '#43812e') or '#d8d5c4',3)
 end
 cr:restore()
end
function M.clock(cr,w,h,time)
 cr:save();cr:scale(w/112,h/40)
 wax(cr,3,4,109,3,'#79508e',2);wax(cr,3,37,109,36,'#79508e',2)
 label(cr,8,28,time,23,'#246d9b');cr:restore()
end
return M
