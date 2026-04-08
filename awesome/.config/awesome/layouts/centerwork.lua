local awful = require("awful")
local capi = {
    screen = screen,
}

local centerwork = {}

function arrange(param)
    local tag = param.tag or capi.screen[param.screen].selected_tag
    local useless_gap = tonumber(param.useless_gap) or 0

    local wa = param.workarea
    local clients = param.clients

    local width = math.floor(wa.width * tag.master_width_factor)
    local height = wa.height - 2 * useless_gap
    local x = wa.x + math.floor((wa.width - width) / 2)
    local y = wa.y + useless_gap

    for _, client in ipairs(clients) do
        client:geometry {
            x = x,
            y = y,
            width = width,
            height = height
        }
        client.floating = false
    end
end

centerwork.name = "centerwork"
centerwork.arrange = arrange

return centerwork
