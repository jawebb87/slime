-- Native Cairo ramp, coping, deck markers, and a grinding skater.
local cairo = require('lgi').cairo
local M = {}
function M.panel(cr, w, h)
    local cut = math.min(4, w/4, h/4)
    cr:move_to(cut,0);cr:line_to(w,0);cr:line_to(w,h-cut)
    cr:line_to(w-cut,h);cr:line_to(0,h);cr:line_to(0,cut);cr:close_path()
end
local function ink(cr, hex, alpha)
    cr:set_source_rgba(tonumber(hex:sub(2,3),16)/255,
        tonumber(hex:sub(4,5),16)/255, tonumber(hex:sub(6,7),16)/255, alpha or 1)
end
function M.dimensions(w, h)
    local scale = h / 94
    return math.min(84 * scale, w * 0.22), 48 * scale, 14 * scale
end
function M.coping(cr, w, h)
    local lip, flat, edge = M.dimensions(w,h)
    cr:move_to(0, 3)
    cr:line_to(edge, 3)
    cr:curve_to(edge, flat, lip*0.5, flat, lip, flat)
    cr:line_to(w-lip, flat)
    cr:curve_to(w-lip*0.5, flat, w-edge, flat, w-edge, 3)
    cr:line_to(w, 3)
end
function M.shape(cr, w, h)
    if w <= 0 or h <= 0 then return end
    M.coping(cr,w,h)
    cr:line_to(w,h)
    cr:line_to(0,h)
    cr:close_path()
end
function M.background(_, cr, w, h)
    if w <= 0 or h <= 0 then return end
    cr:save()
    M.shape(cr,w,h); cr:clip()
    local p = cairo.Pattern.create_linear(0,0,0,h)
    p:add_color_stop_rgb(0,0.38,0.41,0.40)
    p:add_color_stop_rgb(1,0.16,0.19,0.19)
    cr:set_source(p); cr:paint()
    -- Fixed deterministic aggregate flecks; no timer or random paint jitter.
    for x=7,w,23 do
        for y=9,h,13 do
            local n = (x*17+y*31)%11
            ink(cr, n<5 and '#d4d2bf' or '#101615',0.10)
            cr:rectangle(x+(n%4),y,1+(n%3),1); cr:fill()
        end
    end
    M.coping(cr,w,h); ink(cr,'#111817'); cr:set_line_width(7); cr:stroke()
    M.coping(cr,w,h); ink(cr,'#c5cbbb'); cr:set_line_width(2); cr:stroke()
    local lip = M.dimensions(w,h)
    -- Worn diagonal safety paint stays in the curved end zones.
    for _, x in ipairs({18,w-38}) do
        cr:save(); cr:translate(x,h-20); cr:rotate(-0.6)
        ink(cr,'#d7b958',0.85); cr:rectangle(0,0,7,21); cr:fill(); cr:restore()
    end
    ink(cr,'#ccd0c3',0.20); cr:set_line_width(1)
    cr:move_to(lip+15,h-3);cr:line_to(w-lip-15,h-3);cr:stroke()
    cr:restore()
end
function M.deck(cr, w, h, selected, occupied, urgent)
    cr:save()
    local sy=h/34; cr:scale(w/30,sy)
    if selected then
        -- Coping rail, board, wheels, and a crouched skater in silhouette.
        ink(cr,'#c8d0bd');cr:set_line_width(1)
        cr:move_to(1,28);cr:line_to(29,28);cr:stroke()
        ink(cr,'#9cdb45');cr:set_line_width(2)
        cr:move_to(4,25);cr:curve_to(10,27,20,27,26,24);cr:stroke()
        ink(cr,'#ecebdc'); cr:arc(12,6,2.6,0,math.pi*2);cr:fill()
        cr:set_line_width(2.5); cr:set_line_cap(cairo.LineCap.ROUND)
        cr:move_to(12,10);cr:line_to(17,14);cr:line_to(12,18);cr:line_to(9,23)
        cr:move_to(17,14);cr:line_to(21,18);cr:line_to(21,23)
        cr:move_to(14,11);cr:line_to(21,10);cr:line_to(26,13)
        cr:move_to(13,11);cr:line_to(7,14);cr:stroke()
    else
        ink(cr,urgent and '#df6094' or (occupied and '#bdc9b0' or '#697d76'))
        cr:move_to(9,11);cr:curve_to(0,11,0,23,9,23)
        cr:line_to(21,23);cr:curve_to(30,23,30,11,21,11);cr:close_path();cr:fill()
        ink(cr,'#17201d');cr:rectangle(8,13,14,8);cr:fill()
        ink(cr,'#d7b958');cr:rectangle(12,15,6,2);cr:fill()
    end
    ink(cr,'#d8d8c6')
    for _, x in ipairs({9,22}) do cr:arc(x,28,1.4,0,math.pi*2);cr:fill() end
    cr:restore()
end
return M
