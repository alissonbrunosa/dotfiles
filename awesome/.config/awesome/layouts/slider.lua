local awful = require("awful")
local capi = { 
    screen = screen,
    client = client 
}
local scroll_layout = { name = "scroll" }

function scroll_layout.arrange(param)
    local tag = param.tag or capi.screen[param.screen].selected_tag
    local wa = param.workarea
    local cls = param.clients
    local focused = capi.client.focus or cls[1]
    
    if not focused or #cls == 0 then return end

    local gap = tag.useless_gap or 0
    local mwfact = tag.master_width_factor

    local total_ribbon_width = 0
    for _, c in ipairs(cls) do
        if not c.scroll_width then
            c.scroll_width = math.floor(wa.width * 0.5)
        end

        if c == focused and mwfact ~= 0.5 then
            local delta = mwfact - 0.5
            c.scroll_width = c.scroll_width + math.floor(wa.width * delta)
            c.scroll_width = math.max(100, math.min(c.scroll_width, wa.width))
            tag.master_width_factor = 0.5 
        end
        total_ribbon_width = total_ribbon_width + c.scroll_width + gap
    end

    local current_x = wa.x + gap

    if total_ribbon_width > wa.width then
        local focused_idx = 1
        for i, c in ipairs(cls) do
            if c == focused then focused_idx = i break end
        end

        local focused_x = wa.x + wa.width - focused.scroll_width - gap
        if focused_idx == 1 then
            focused_x = wa.x + gap
        end

        local offset_from_start = 0
        for i = 1, focused_idx - 1 do
            offset_from_start = offset_from_start + cls[i].scroll_width + gap
        end
        current_x = focused_x - offset_from_start
    end

    for _, c in ipairs(cls) do
        c:geometry({
            x      = math.floor(current_x),
            y      = wa.y + gap,
            width  = math.max(1, c.scroll_width - (2 * gap)),
            height = math.max(1, wa.height - (2 * gap))
        })
        current_x = current_x + c.scroll_width + gap
    end
end

return scroll_layout
