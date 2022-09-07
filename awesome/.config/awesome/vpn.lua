local wibox = require("wibox")
local watch = require("awful.widget.watch")

vpn_widget = wibox.widget.textbox()

local function vpn(widget, stdout, stderr, exitreason, exitcode)
    if(stdout == '' or stdout==nil or stdout=='Device "tun0" does not exist.') then
        widget.text= "VPN(Off)"
    else
        widget.text= "VPN(On)"
    end
end

watch("ip addr show tun0", 2, vpn, vpn_widget)

return vpn_widget
