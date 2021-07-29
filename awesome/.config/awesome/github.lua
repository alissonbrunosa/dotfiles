local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")
local spawn = require("awful.spawn")
local beautiful = require("beautiful")
local gfs = require("gears.filesystem")
local watch = require("awful.widget.watch")

local ICONS_DIR = gfs.get_configuration_dir() .. 'assets/'
local EVENTS_CMD = [[ sh -c "gh api notifications | jq 'length'" ]]


--- Utility function to show warning messages
local function show_warning(message)
    naughty.notify{
        preset = naughty.config.presets.critical,
        title = 'GitHub Activity Widget',
        text = message}
end

local github_widget = wibox.widget {
    {
        {
            {
                id = 'text',
                align  = 'center',
                valign = 'center',
                widget = wibox.widget.textbox
            },
            id = "m_text",
            left = 4,
            layout = wibox.container.margin
        },
        {
            {
                id = 'icon',
                image = ICONS_DIR .. 'github.png',
                widget = wibox.widget.imagebox
            },
            id = "m_icon",
            margins = 4,
            layout = wibox.container.margin
        },
        layout = wibox.layout.fixed.horizontal,
    },
    shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 4)
    end,
    widget = wibox.container.background,
    update_text = function(self, text)
        self:get_children_by_id("text")[1].markup = text
    end,
    update_icon = function(self, icon)
        self:get_children_by_id("icon")[1].image = icon
    end
}

github_widget:connect_signal("mouse::enter", function(c)
    c:set_bg(beautiful.bg_focus)
    c:set_fg(beautiful.fg_focus)
    c:update_icon(ICONS_DIR .. 'github.svg')
end)

github_widget:connect_signal("mouse::leave", function(c)
    c:set_bg(beautiful.bg_normal)
    c:set_fg(beautiful.fg_normal)
    c:update_icon(ICONS_DIR .. 'github.png')
end)

github_widget:buttons(
    awful.util.table.join(
        awful.button({}, 1, function() spawn.with_shell('xdg-open https://github.com/notifications') end)
    )
)

local five_minutes = 60 * 5

watch(EVENTS_CMD, five_minutes, function(_, stdout)
    github_widget:update_text(stdout)
end)

return github_widget
