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

local minimize = function(client)
    -- The client currently has the input focus, so it cannot be
    -- minimized, since minimized clients can't have the focus.
    client.minimized = true
end

local toggle_maximize = function(client)
    client.maximized = not client.maximized
    client:raise()
end

local toggle_maximize_vertical = function(client)
    client.maximized_vertical = not client.maximized_vertical
    client:raise()
end

local toggle_maximize_horizontal = function(client)
    client.maximized_horizontal = not client.maximized_horizontal
    client:raise()
end

return gears.table.join(
    awful.key({ modkey,           }, "f",      toggle_fullscreen,            { description = "toggle fullscreen",         group = "client" }),
    awful.key({ modkey, "Shift"   }, "c",      close_client,                 { description = "close",                     group = "client" }),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle, { description = "toggle floating",           group = "client" }),
    awful.key({ modkey, "Control" }, "Return", move_to_master,               { description = "move to master",            group = "client" }),
    awful.key({ modkey,           }, "o",      move_to_screen,               { description = "move to screen",            group = "client" }),
    awful.key({ modkey,           }, "t",      toggle_on_top,                { description = "toggle keep on top",        group = "client" }),
    awful.key({ modkey,           }, "n",      minimize,                     { description = "minimize",                  group = "client" }),
    awful.key({ modkey,           }, "m",      toggle_maximize,              { description = "(un)maximize",              group = "client" }),
    awful.key({ modkey, "Control" }, "m",      toggle_maximize_vertical,     { description = "(un)maximize vertically",   group = "client" }),
    awful.key({ modkey, "Shift"   }, "m",      toggle_maximize_horizontal,   { description = "(un)maximize horizontally", group = "client" })
)
