-- Sparse watercolor washes and pencil strokes, confined to the bar background.
local M = {}
function M.paper(_, cr, w, h)
    cr:set_source_rgb(0.965, 0.937, 0.875)
    cr:paint()
    for i = 0, math.ceil(w / 180) do
        local x = i * 180
        cr:set_source_rgba(0.24, 0.57, 0.52, 0.065)
        cr:save()
        cr:translate(x + 42, h * 0.55)
        cr:scale(65, h * 0.8)
        cr:arc(0, 0, 1, 0, math.pi * 2)
        cr:fill()
        cr:restore()
        cr:set_source_rgba(0.22, 0.25, 0.23, 0.24)
        cr:set_line_width(0.7)
        cr:move_to(x + 8, h - 3)
        cr:line_to(x + 105, h - 2)
        cr:stroke()
        cr:move_to(x + 113, h - 3)
        cr:line_to(x + 133, h - 3.5)
        cr:stroke()
    end
end
return M
