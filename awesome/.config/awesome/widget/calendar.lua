local os           = os
local setmetatable = setmetatable
local awful        = require("awful")
local gobject      = require("gears.object")
local gtable       = require("gears.table")
local gshape       = require("gears.shape")
local wibox        = require("wibox")
local beautiful    = require("beautiful")
local hand_cursor   = require("widget.hand_cursor")
local dpi          = beautiful.xresources.apply_dpi

local calendar = { mt = {} }

local function day_name_widget(name)
  return wibox.widget {
    {
      halign = "center",
      align  = "center",
      text   = name,
      font   = beautiful.font_name .. ' Bold 11',
      widget = wibox.widget.textbox
    },
    fg            = beautiful.fg_subtitle,
    widget        = wibox.container.background,
    forced_width  = dpi(30),
    forced_height = dpi(30),
  }
end

local function date_widget(date, is_current, is_another_month)
  local shape            = nil
  local background_color = beautiful.bg_widget
  local foreground_color = beautiful.fg_normal

  if is_current then
    shape            = gshape.circle
    background_color = beautiful.bg_focus
    foreground_color = beautiful.fg_focus
  end

  if is_another_month then
    foreground_color = beautiful.sub_text
  end

  return wibox.widget({
    {
      halign = "center",
      align  = "center",
      font   = beautiful.font_name .. ' 10',
      text   = date,
      widget = wibox.widget.textbox
    },
    forced_width  = dpi(30),
    forced_height = dpi(30),
    shape         = shape,
    widget        = wibox.container.background,
    fg            = foreground_color,
    bg            = background_color,
  })
end

local adjust_date = function(date)
  if date.month < 1 then
    date.month = 12
    date.year = date.year - 1
  end

  if date.month > 12 then
    date.month = 1
    date.year = date.year + 1
  end

  return date
end

local monthLength = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }
local previous_day_of = function(date)
  local year = date.year
  if (year % 4 == 0 and year % 100 ~=0) or year % 400 == 0 then
    monthLength[2] = 29
  end

  local last_month = date.month - 1
  if last_month < 1 then
    last_month = 1
    year = year - 1
  end

  return { day = monthLength[last_month], month = last_month, year = year }
end

function calendar:set_date(date)
  self.date = adjust_date(date)
  self.days:reset()

  local today = os.date("*t")
  local time_handle = os.time(date)

  for _, name in ipairs({ "Su", "Mo", "Tu", "We", "Th", "Fr", "Sa" }) do
    self.days:add(day_name_widget(name))
  end

  local first_of_month = os.date("*t", os.time({ year = date.year, month = date.month, day = 1 }))
  local last_of_prev  = os.date("*t", os.time({ year = date.year, month = date.month, day = 0 }))
  local days_in_month = os.date("*t", os.time({ year = date.year, month = date.month + 1, day = 0 })).day

  self.month:set_text(os.date("%B %Y", time_handle))

  local start_padding = first_of_month.wday - 1
  for day = (last_of_prev.day - start_padding + 1), last_of_prev.day do
    self.days:add(date_widget(day, false, true)) -- is_current=false, is_another_month=true
  end

  for day = 1, days_in_month do
    local is_today = (day == today.day and date.month == today.month and date.year == today.year)

    self.days:add(date_widget(day, is_today, false))
  end

  local remaining_slots = 42 - (start_padding + days_in_month)
  for day = 1, remaining_slots do
    self.days:add(date_widget(day, false, true))
  end
end

function calendar:reset()
  self:set_date(os.date("*t"))
end

local create_arrow_button = function(direction, callback)
  local btn =  wibox.widget {
    text   = direction == "left" and "" or "",
    align  = direction == "left" and "left" or "right",
    font   = beautiful.icon_font('Regular', 13),
    widget = wibox.widget.textbox,
  }

  hand_cursor(btn)

  btn:buttons(
    awful.util.table.join(
      awful.button({}, 1, callback)
    )
  )

  return btn
end

local new = function(context)
  local ret = gobject({})
  gtable.crush(ret, calendar, true)

  ret.month = wibox.widget {
    text   = os.date("%B %Y"),
    font   = beautiful.font_name .. ' 16',
    widget = wibox.widget.textbox
  }

  local updateMonth = function(n)
    return function()
      local date = ret.date
      ret:set_date({ year = date.year, month = date.month + n, day = date.day })
    end
  end

  local month = wibox.widget {
    {
      create_arrow_button("left", updateMonth(-1)),
      {
        widget = ret.month,
        align  = "center",
      },
      create_arrow_button("right", updateMonth(1)),
      expand = "outside",
      layout = wibox.layout.align.horizontal
    },
    fg     = beautiful.fg_title,
    widget = wibox.container.background,
  }

  ret.days = wibox.widget {
    expand          = true,
    homogeneous     = true,
    spacing         = dpi(5),
    forced_num_rows = 6,
    forced_num_cols = 7,
    widget          = wibox.layout.grid,
  }

  local widget = wibox.widget {
    month,
    ret.days,
    spacing = dpi(10),
    widget  = wibox.layout.fixed.vertical,
  }

  context:on('info_panel::hide', function()
    ret:reset()
  end)

  ret:reset()

  gtable.crush(widget, calendar, true)
  return widget
end

function calendar.mt:__call(...)
  return new(...)
end

return setmetatable(calendar, calendar.mt)
