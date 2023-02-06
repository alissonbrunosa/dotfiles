local awful      = require('awful')
local wibox      = require('wibox')
local gears      = require('gears')
local beautiful  = require('beautiful')
local xresources = require('beautiful.xresources')
local dpi        = xresources.apply_dpi

local shape_func = function(cr, width, height)
  return gears.shape.rounded_rect(cr, width, height, 5)
end

local function worker(args)
  local taglist = awful.widget.taglist {
    screen  = args.screen,
    filter  = awful.widget.taglist.filter.all,
    style   = {
      shape = shape_func,
    },
    layout   = {
      spacing = dpi(10),
      widget = wibox.layout.fixed.horizontal
    },
    widget_template = {
      {
        {
          {
            id     = 'text_role',
            align  = 'center',
            valign  = 'center',
            widget = wibox.widget.textbox,
            forced_height = dpi(20),
            forced_width = dpi(20),
          },
          layout = wibox.layout.fixed.horizontal,
        },
        margins = dpi(10),
        widget = wibox.container.margin
      },
      id     = 'background_role',
      widget = wibox.container.background,
    },
    buttons = args.buttons
  }

  local widget = wibox.widget {
    taglist,
    top    = dpi(5),
    bottom = dpi(5),
    widget = wibox.container.margin,
  }

  return widget
end

return worker
