local wibox     = require("wibox")
local naughty   = require("naughty")
local menubar   = require("menubar")
local beautiful = require("beautiful")
local gears     = require("gears")
local dpi       = require("beautiful.xresources").apply_dpi
local clickable = require("widget.hand_cursor")

local obj = {}

local resolve_icon = function(n)
  local icon_source = n.icon or n.app_icon or n.image

  if icon_source and icon_source ~= '' then
    return wibox.widget {
      {
        image         = icon_source,
        resize        = true,
        forced_height = dpi(140),
        forced_width  = dpi(140),
        widget        = wibox.widget.imagebox
      },
      strategy = "center",
      widget   = wibox.container.place
    }
  end

  return nil
end

local resolve_header = function(n)
  local bg_colour = beautiful.bg_focus
  if n.urgency == "critical" then
    bg_colour = beautiful.bg_urgent
  end

  local app_name_str = (n.app_name == nil or n.app_name == '') and "Application" or n.app_name

  return wibox.widget {
    {
      {
        text   = app_name_str,
        font   = beautiful.font_name .. " Bold 14",
        align  = "center",
        widget = wibox.widget.textbox,
      },
      margins = dpi(8),
      widget  = wibox.container.margin,
    },
    bg     = bg_colour,
    fg     = beautiful.fg_focus or "#ffffff",
    widget = wibox.container.background,
  }
end

function obj.init()
  naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
      urgency = "critical",
      title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
      message = message
    }
  end)

  naughty.connect_signal("request::icon", function(n, context, hints)
    if context ~= "app_icon" then return end

    local path = menubar.utils.lookup_icon(hints.app_icon) or 
    menubar.utils.lookup_icon(hints.app_icon:lower())

    if path then n.icon = path end
  end)

  naughty.connect_signal("request::display", function(n)
    local title_widget = wibox.widget {
      {
        markup = n.title or "Notification",
        font   = beautiful.font_name .. " Bold 12",
        widget = wibox.widget.textbox,
      },
      margins = dpi(5),
      widget  = wibox.container.margin,
    }

    local message_widget = wibox.widget {
      {
        {
          markup = n.message or "",
          font   = beautiful.font_name .. " 11",
          wrap   = "word",
          align  = "left",
          widget = wibox.widget.textbox,
        },
        strategy     = "max",
        height       = dpi(300),
        forced_width = dpi(400),
        widget       = wibox.container.constraint
      },
      margins = dpi(5),
      widget  = wibox.container.margin,
    }

    local content = wibox.widget {
      {
        {
          resolve_icon(n),
          {
            title_widget,
            message_widget,
            naughty.list.actions,
            layout = wibox.layout.fixed.vertical,
          },
          layout = wibox.layout.align.horizontal,
          expand = "outside",
        },
        margins = dpi(10),
        widget  = wibox.container.margin
      },
      bg     = beautiful.bg_widget or "#222222",
      widget = wibox.container.background,
    }

    if #n.actions == 0 then
      clickable(content)
    end

    naughty.layout.box {
      notification = n,
      type = "notification",
      widget_template = {
        {
          {
            resolve_header(n),
            content,
            layout = wibox.layout.fixed.vertical,
          },
          id     = "background_role",
          widget = wibox.container.background,
        },
        margins = dpi(4),
        widget  = wibox.container.margin,
      },
    }
  end)
end

return obj
