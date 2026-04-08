local gears = require('gears')
local awful = require('awful')

local modkey = 'Mod4'

local toggle_fullscreen = function (client)
    client.fullscreen = not client.fullscreen
    client:raise()
end

local close_client = function(client)
    client:kill()
end

local move_to_master = function(client)
    client:swap(awful.client.getmaster())
end

local move_to_screen = function(client)
    client:move_to_screen()
end

local toggle_on_top = function(client)
    client.ontop = not client.ontop
end

return gears.table.join(
    awful.key({}                   , "F11",      toggle_fullscreen,          { description = "toggle fullscreen",         group = "client" }),
    awful.key({ modkey, "Shift"   }, "c",      close_client,                 { description = "close",                     group = "client" }),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle, { description = "toggle floating",           group = "client" }),
    awful.key({ modkey, "Control" }, "Return", move_to_master,               { description = "move to master",            group = "client" }),
    awful.key({ modkey,           }, "o",      move_to_screen,               { description = "move to screen",            group = "client" }),
    awful.key({ modkey,           }, "t",      toggle_on_top,                { description = "toggle keep on top",        group = "client" })
)
