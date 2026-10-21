-- Screen-relative geometry for a detached top bar, including its workarea gap.
local function geometry(screen, height, inset, offset, clearance)
    inset = math.min(inset, math.max(0, math.floor((screen.width - 1) / 2)))
    return {
        x = screen.x + inset,
        y = screen.y + offset,
        width = math.max(1, screen.width - 2 * inset),
        height = height,
    }, offset + height + clearance
end

return geometry
