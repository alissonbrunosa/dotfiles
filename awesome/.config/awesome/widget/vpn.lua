local gears      = require('gears')
local wibox      = require('wibox')
local watch      = require('awful.widget.watch')
local beautiful  = require('beautiful')
local xresources = require('beautiful.xresources')
local dpi        = xresources.apply_dpi

return function()
    local circle = wibox.widget {
        wibox.widget.base.empty_widget(),
        forced_width  = dpi(12),
        forced_height = dpi(12),
        shape         = gears.circle,
        widget        = wibox.container.background,
    }

    local function vpn(widget, stdout, stderr)
        if(stdout == '' or stdout == nil or string.find(stdout, 'does not exist')) then
            circle.bg = beautiful.one_quarter
        else
            circle.bg = beautiful.full
        end
    end

    watch('ip addr show tun0', 2, vpn, vpn_widget)

    return circle
end

