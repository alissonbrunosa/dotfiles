local awful      = require('awful')
local wibox      = require('wibox')
local gears      = require('gears')
local beautiful  = require('beautiful')
local xresources = require('beautiful.xresources')
local dpi        = xresources.apply_dpi

local shape_func = function(cr, width, height)
    return gears.shape.rounded_rect(cr, width, height, 5)
end

local tasklist_buttons = gears.table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal("request::activate", "tasklist", { raise = true })
        end
    end),
    awful.button({ }, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
    end),
    awful.button({ }, 4, function ()
        awful.client.focus.byidx(1)
    end),
    awful.button({ }, 5, function ()
        awful.client.focus.byidx(-1)
    end)
)

local function worker(args)
    local taglist = awful.widget.tasklist {
        screen  = args.screen,
        filter  = args.filter or awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        style   = {
            shape = shape_func,
        },
        layout   = {
            spacing = dpi(10),
            widget = wibox.layout.fixed.horizontal
        },
        widget_template = {
            {
                id     = 'clienticon',
                widget = awful.widget.clienticon,
            },
            {
                wibox.widget.base.make_widget(),
                id            = 'background_role',
                widget        = wibox.container.background,
            },
            create_callback = function(self, c, index, objects) --luacheck: no unused args
                self:get_children_by_id('clienticon')[1].client = c
            end,
            layout = wibox.layout.align.vertical,
        },
    }

    local widget = wibox.widget {
        taglist,
        top = dpi(5),
        bottom = dpi(5),
        widget = wibox.container.margin,
    }

    return widget
end

return worker
