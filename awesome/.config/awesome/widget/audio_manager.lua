local awful      = require('awful')
local watch      = require('awful.widget.watch')
local wibox      = require('wibox')
local gears      = require('gears')
local gfs        = require('gears.filesystem')
local beautiful  = require('beautiful')
local xresources = require('beautiful.xresources')
local dpi        = xresources.apply_dpi

local shape       = require('widget.shape')
local hand_cursor = require('widget.hand_cursor')

local icons = {
  source = '',
  sink   = '',
}

function truncate(str, max_len)
  if #str <= max_len then
    return str
  else
    return string.sub(str, 1, max_len - 3) .. "..."
  end
end

local function parse_output(output, device_type)
  local devices = {}

  for line in output:gmatch("[^\n]+") do
    if line:match("%S") and not line:match("Monitor") then
      local index, name, desc = line:match("^(%d+)%s*(%S+)%s*(.*)$")

      if desc then
        desc = desc:match("^%s*(.-)%s*$")
      end

      table.insert(devices, {
        index = index,
        name = name,
        desc = desc,
        type = device_type
      })
    end
  end

  return devices
end

local radio_button = function(active)
  return wibox.widget {
    {
      {
        bg     = active and beautiful.two_quarter or beautiful.bg_normal,
        shape  = gears.shape.circle,
        widget = wibox.container.background,
      },
      margins = dpi(4),
      widget  = wibox.container.margin,
    },
    forced_width  = dpi(18),
    forced_height = dpi(18),
    shape         = gears.shape.circle,
    border_width  = dpi(2),
    border_color  = beautiful.border_normal,
    widget        = wibox.container.background
  }
end

local function create_row_widget(context, device_info, is_default)
  local radio = radio_button(is_default)
  local row = wibox.widget {
    {
      {
        radio,
        {
          text = truncate(device_info.desc, 30),
          align = 'left',
          font   = beautiful.font_name .. ' Bold 11',
          widget = wibox.widget.textbox
        },
        spacing = 10,
        layout = wibox.layout.fixed.horizontal
      },
      margins = 10,
      layout = wibox.container.margin
    },
    bg = beautiful.bg_normal,
    shape  = shape.rounded_rect,
    widget = wibox.container.background
  }

  row:connect_signal("mouse::enter", function(c)
    c:set_bg(beautiful.sub_text)
  end)

  row:connect_signal("mouse::leave", function(c)
    c:set_bg(beautiful.bg_normal)
  end)

  hand_cursor(row)

  row:buttons(
    awful.util.table.join(
      awful.button({}, 1, function()
        awful.spawn.easy_async('pa-cli ' .. device_info.type .. ' set-default ' .. device_info.name, function()
          context:emit(device_info.type .. ':changed')
        end)
      end)
    )
  )

  return row
end

local create_panel = function(context, device)
  local widget = wibox.widget {
    {
      {
        id = "vbox",
        layout = wibox.layout.fixed.vertical,
        spacing = 4,
      },
      margins = 8,
      widget = wibox.container.margin,
    },
    widget = wibox.container.background,
    refresh = function(self, callback)
      local vbox = self:get_children_by_id('vbox')[1]

      awful.spawn.easy_async('pa-cli ' .. device .. ' get-default', function(stdout)
        local default_device = stdout:gsub("%s+", "")

        awful.spawn.easy_async('pa-cli ' .. device .. ' list', function(stdout)
          devices = parse_output(stdout, device)

          vbox:reset()
          for _, dev in ipairs(devices) do
            local row = create_row_widget(context, dev, default_device == dev.name)
            vbox:add(row)
          end

          callback()
        end)
      end)
    end
  }

  return widget
end

local function builder(context, device)
  local main_widget = create_panel(context, device)

  local popup = awful.popup {
    ontop        = true,
    visible      = false,
    border_width = dpi(1),
    shape        = shape.rounded_rect,
    offset       = { y = dpi(5) },
    widget       = main_widget,
  }

  popup:connect_signal("mouse::leave", function()
    popup.visible = false
  end)

  local settings_widget = wibox.widget {
    {
      {
        id     = 'icon',
        text   = icons[device],
        font   = beautiful.icon_font('Regular'),
        widget = wibox.widget.textbox,
      },
      margins = dpi(2),
      widget  = wibox.container.margin
    },
    forced_width = dpi(30),
    widget = wibox.container.background,
  }

  function settings_widget:toggle()
    if popup.visible then
      popup.visible = not popup.visible
    else
      context:emit('popup:show', popup)
      main_widget:refresh(function()
        popup:move_next_to(mouse.current_widget_geometry)
      end)
    end
  end

  context:on('popup:show', function(obj)
    if obj ~= popup then
      popup.visible = false
    end
  end)

  context:on(device .. ':changed', function()
    settings_widget:toggle()
  end)

  hand_cursor(settings_widget)
  settings_widget:buttons(
    awful.util.table.join(
      awful.button({}, 1, settings_widget.toggle)
    )
  )

  return settings_widget
end

return builder
