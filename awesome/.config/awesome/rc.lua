pcall(require, "luarocks.loader")

require("awful.autofocus")
require("awful.hotkeys_popup.keys")

local beautiful = require("beautiful")
local gears     = require("gears")
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")

local context        = require('context')
local awful          = require("awful")
local wibox          = require("wibox")
local naughty        = require("naughty")
local menubar        = require("menubar")
local hotkeys_popup  = require("awful.hotkeys_popup")
local fun            = require("utils.functions")(context)
local dpi            = require("beautiful.xresources").apply_dpi
local clientkeys     = require('clientkeys')
local clientbuttons  = require('clientbuttons')
local rules          = require('rules')
local vpn_widget     = require('widget.vpn')
local infopanel      = require("infopanel")(context)
local audio_manager  = require("widget.audio_manager")
local clickable      = require("widget.hand_cursor")
local notification   = require("widget.notification")

notification.init(context)

local space_widget = {
  forced_width = dpi(10),
  widget = wibox.container.background,
}

do
  local in_error = false
  awesome.connect_signal("debug::error", function (err)
    -- Make sure we don't go into an endless error loop
    if in_error then return end
    in_error = true

    naughty.notify({ preset = naughty.config.presets.critical,
      title = "Oops, an error happened!",
      text = tostring(err) })
    in_error = false
  end)
end

local function open_terminal()
  local terminal_apps = { 'wezterm', 'alacritty', 'kitty', 'xterm' }
  for _, terminal in ipairs(terminal_apps) do
    local pid, snid = awful.spawn(terminal)
    if type(pid) == "number" and snid then
      break
    end
  end
end

-- Default modkey.
modkey = "Mod4"

-- Layouts
local TILE_LEFT_INDEX = 1
local MAX_INDEX = 2
tag.connect_signal("request::default_layouts", function()
  awful.layout.append_default_layouts({
    awful.layout.suit.tile,
    awful.layout.suit.max,
  })
end)


-- Wibar
local taglist_buttons = gears.table.join(
  awful.button({ }, 1, function(t) t:view_only() end),
  awful.button({ modkey }, 1, function(t)
    if client.focus then
      client.focus:move_to_tag(t)
    end
  end),
  awful.button({ }, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, function(t)
    if client.focus then
      client.focus:toggle_tag(t)
    end
  end),
  awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
  awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

-- Wallpaper
local wallpaper_handler = function(s)
  awful.wallpaper {
    screen = s,
    widget = {
      {
        image     = beautiful.wallpaper,
        upscale   = true,
        downscale = true,
        widget    = wibox.widget.imagebox,
      },
      valign = "center",
      halign = "center",
      tiled  = false,
      widget = wibox.container.tile,
    }
  }
end

screen.connect_signal("request::wallpaper", wallpaper_handler)

screen.connect_signal("request::desktop_decoration", function(s)
  -- Each screen has its own tag table.
  local tag_names = { "I", "II", "III", "IV", "V", "VI" }
  local tag_layouts = {
    awful.layout.layouts[MAX_INDEX],
    awful.layout.layouts[TILE_LEFT_INDEX],
    awful.layout.layouts[MAX_INDEX],
    awful.layout.layouts[MAX_INDEX],
    awful.layout.layouts[MAX_INDEX],
  }

  awful.tag(tag_names, s, tag_layouts)

  -- Create a promptbox for each screen
  s.mypromptbox = awful.widget.prompt()
  -- Create an imagebox widget which will contain an icon indicating which widget we're using.

  -- Create a taglist widget
  s.mytaglist = require('widget.taglist')({
    screen  = s,
    filter  = awful.widget.taglist.filter.all,
    buttons = taglist_buttons,
  })

  s.mytasklist = require('widget.tasklist')({
    screen  = s,
    filter  = awful.widget.tasklist.filter.currenttags,
  })

  -- Create the wibox
  s.mywibox = awful.wibar({ position = "top", screen = s, height = dpi(40) })

  -- Add widgets to the wibox
  s.mywibox:setup {
    layout = wibox.layout.align.horizontal,
    expand = "none",
    { -- Left widgets
      space_widget,
      s.mytaglist,
      space_widget,
      s.mypromptbox,
      layout = wibox.layout.fixed.horizontal,
    },
    s.mytasklist, -- Middle widget
    { -- Right widgets
      audio_manager(context, 'source'),
      audio_manager(context, 'sink'),
      space_widget,
      infopanel,
      space_widget,
      vpn_widget(),
      layout = wibox.layout.fixed.horizontal,
    },
  }
end)


-- Key bindings
globalkeys = gears.table.join(
  awful.key({ modkey }, "s",      hotkeys_popup.show_help,   { description ="show help", group ="awesome" }),
  awful.key({ modkey }, "Left",   awful.tag.viewprev,        { description = "view previous", group = "tag" }),
  awful.key({ modkey }, "Right",  awful.tag.viewnext,        { description = "view next", group = "tag" }),
  awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),
  awful.key({ modkey }, "j",      fun.focus_client_at(1),    { description = "focus next by index", group = "client" }),
  awful.key({ modkey }, "k",      fun.focus_client_at(-1),   { description = "focus previous by index", group = "client" }),
  awful.key({ modkey }, "w",      infopanel.toggle,          { description = "show info panel", group = "awesome" }),

  -- widget manipulation
  awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end, { description = "swap with next client by index", group = "client" }),
  awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end, { description = "swap with previous client by index", group = "client" }),
  awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end, { description = "focus the next screen", group = "screen" }),
  awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end, { description = "focus the previous screen", group = "screen" }),
  awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,                      { description = "jump to urgent client", group = "client" }),
  awful.key({ modkey,           }, "Tab",
    function ()
      awful.client.focus.history.previous()
      if client.focus then
        client.focus:raise()
      end
    end,
    {description = "go back", group = "client"}),

  -- Standard program
  awful.key({ modkey,           }, "Return", open_terminal,                                       { description = "open a terminal", group = "launcher" }),
  awful.key({ modkey, "Control" }, "r",      awesome.restart,                                     { description = "reload awesome", group = "awesome" }),
  awful.key({ modkey, "Shift"   }, "q",      awesome.quit,                                        { description = "quit awesome", group = "awesome" }),
  awful.key({ modkey,           }, "l",      function () awful.tag.incmwfact( 0.05)          end, { description = "increase master width factor", group = "layout" }),
  awful.key({ modkey,           }, "h",      function () awful.tag.incmwfact(-0.05)          end, { description = "decrease master width factor", group = "layout" }),
  awful.key({ modkey, "Shift"   }, "h",      function () awful.tag.incnmaster( 1, nil, true) end, { description = "increase the number of master clients", group = "layout" }),
  awful.key({ modkey, "Shift"   }, "l",      function () awful.tag.incnmaster(-1, nil, true) end, { description = "decrease the number of master clients", group = "layout" }),
  awful.key({ modkey, "Control" }, "h",      function () awful.tag.incncol( 1, nil, true)    end, { description = "increase the number of columns", group = "layout" }),
  awful.key({ modkey, "Control" }, "l",      function () awful.tag.incncol(-1, nil, true)    end, { description = "decrease the number of columns", group = "layout" }),
  awful.key({ modkey,           }, "space",  function () awful.layout.inc( 1)                end, { description = "select next", group = "layout" }),
  awful.key({ modkey, "Shift"   }, "space",  function () awful.layout.inc(-1)                end, { description = "select previous", group = "layout" }),

  -- Prompt
  awful.key({ modkey }, "r", function () awful.screen.focused().mypromptbox:run() end,
    {description = "run prompt", group = "launcher"}),

  awful.key({ modkey }, "x",
    function ()
      awful.prompt.run {
        prompt       = "Run Lua code: ",
        textbox      = awful.screen.focused().mypromptbox.widget,
        exe_callback = awful.util.eval,
        history_path = awful.util.get_cache_dir() .. "/history_eval"
      }
    end,
    { description = "lua execute prompt", group = "awesome" }),
  -- Menubar
  awful.key({ modkey }, "d", fun.run_launcher, { description = "show the app launcher", group = "launcher" }),

  -- Multimedia
  awful.key({        }, "XF86AudioMute",        fun.mute_audio,             { description = "mute", group = "Multimedia" }),
  awful.key({        }, "XF86AudioLowerVolume", fun.dec_volume,             { description = "lows volume", group = "Multimedia" }),
  awful.key({        }, "XF86AudioRaiseVolume", fun.inc_volume,             { description = "raises volume", group = "Multimedia" }),
  awful.key({        }, "XF86AudioMicMute",     fun.mute_microphone,        { description = "mute mic", group = "Multimedia" }),
  awful.key({        }, "F4",                   fun.mute_microphone,        { description = "mute mic", group = "Multimedia" }),
  awful.key({ modkey }, "m",                    fun.open_music_application, { description = "Launch music application", group = "Multimedia" }),

  -- Monitors
  awful.key({ }, "XF86MonBrightnessUp",   fun.inc_brightness, { description = "increase brightness", group = "Montitors" }),
  awful.key({ }, "XF86MonBrightnessDown", fun.dec_brightness, { description = "decrease brightness", group = "Montitors" }),

  -- Utils
  awful.key({ },                   "XF86Tools", fun.lock_screen,               { description = "lock screen", group = "Utils" }),
  awful.key({ },                   "F12",       fun.lock_screen,               { description = "lock screen", group = "Utils" }),
  awful.key({ },                   "Print",     fun.take_screnshot('gui'),     { description = "takes a screenshot all monitors", group = "Utils" }),
  awful.key({ modkey },            "Print",     fun.take_screnshot('screen'), { description = "takes a screenshot focused monitor", group = "Utils" }),
  awful.key({ modkey, "Control" }, "Print",     fun.take_screnshot('full'),    { description = "takes a screenshot cropped area", group = "Utils" }),
  awful.key({ modkey,           }, "e", function () awful.spawn('emoji-picker') end, { description = "Emoji picker", group = "Utils" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 5.
for i = 1, 6 do
  globalkeys = gears.table.join(globalkeys,
    -- View tag only.
    awful.key({ modkey }, "#" .. i + 9,
      function ()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          tag:view_only()
        end
      end,
      {description = "view tag #"..i, group = "tag"}),
    -- Toggle tag display.
    awful.key({ modkey, "Control" }, "#" .. i + 9,
      function ()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          awful.tag.viewtoggle(tag)
        end
      end,
      {description = "toggle tag #" .. i, group = "tag"}),
    -- Move client to tag.
    awful.key({ modkey, "Shift" }, "#" .. i + 9,
      function ()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:move_to_tag(tag)
          end
        end
      end,
      {description = "move focused client to tag #"..i, group = "tag"}),
    -- Toggle tag on focused client.
    awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
      function ()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:toggle_tag(tag)
          end
        end
      end,
      {description = "toggle focused client on tag #" .. i, group = "tag"})
  )
end


root.keys(globalkeys)

awful.rules.rules = rules(clientkeys, clientbuttons)

-- Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
  -- Set the windows at the slave,
  -- i.e. put it at the end of others instead of setting it master.
  if not awesome.startup then awful.client.setslave(c) end

  if awesome.startup
    and not c.size_hints.user_position
    and not c.size_hints.program_position then
    -- Prevent clients from being unreachable after screen count changes.
    awful.placement.no_offscreen(c)
  end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
  c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c)
  c.border_color = beautiful.border_focus
end)

client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

context:emit('context::loaded')
awful.spawn.with_shell('autostart')
