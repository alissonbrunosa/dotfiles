local os           = os
local setmetatable = setmetatable
local awful        = require("awful")
local gobject      = require("gears.object")
local gtable       = require("gears.table")
local gshape       = require("gears.shape")
local wibox        = require("wibox")
local beautiful    = require("beautiful")
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

    local current_date = os.date("*t")

    for _, day in ipairs({ "Su", "Mo", "Tu", "We", "Th", "Fr", "Sa" }) do
        self.days:add(day_name_widget(day))
    end

    local first_day = os.date("*t", os.time({ year = date.year, month = date.month, day = 1 }))
    local last_day = os.date("*t", os.time(previous_day_of(date)))

    local month = os.date("%B %Y", os.time(date))
    self.month:set_text(month)

    local start_padding = first_day.wday - 1
    local end_padding = 42 - monthLength[first_day.month] - start_padding

    for day = (last_day.day - start_padding + 1), last_day.day do
        self.days:add(date_widget(day, false, true))
    end

    for day = 1, monthLength[first_day.month] do
        local is_current = day == current_date.day and date.month == current_date.month and date.year == current_date.year
        self.days:add(date_widget(day, is_current, false))
    end

    for day = 1, end_padding do
        self.days:add(date_widget(day, false, true))
    end
end

function calendar:reset()
    self:set_date(os.date("*t"))
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
        nil,
        {
            ret.month,
            fg     = beautiful.fg_title,
            widget = wibox.container.background,
        },
        nil,
        expand = 'none',
        layout = wibox.layout.align.horizontal,
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

    context:on('calendar:reset', function()
        ret:reset()
    end)

    widget:buttons(
        awful.util.table.join(
            awful.button({}, 4, updateMonth(1)),
            awful.button({}, 5, updateMonth(-1))
        )
    )

    ret:reset()

    gtable.crush(widget, calendar, true)
    return widget
end

function calendar.mt:__call(...)
  return new(...)
end

return setmetatable(calendar, calendar.mt)
