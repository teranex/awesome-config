-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget

local lain = require("lain")

local sharedtags = require("sharedtags")

-- local vicious = require("vicious")

-- Load Debian menu entries
-- require("debian.menu")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

naughty.config.defaults.icon_size = 48
naughty.config.defaults.timeout = 10
naughty.config.defaults.margin = 10
naughty.config.defaults.screen = screen.primary
naughty.config.presets.normal.opacity = 0.85
naughty.config.presets.low.opacity = 0.85
naughty.config.presets.critical.opacity = 0.85
naughty.config.padding = 6
naughty.config.spacing = 3
naughty.config.notify_callback = function(args)
   -- remove any buttons from the notification
   args.actions = nil
   return args
end
-- some icons are missing in notifications, this is a hack to at least fix the most important ones
table.insert(naughty.config.icon_dirs, '/usr/share/icons/elementary-xfce-dark/panel/48/')
table.insert(naughty.config.icon_dirs, '/usr/share/icons/hicolor/48x48/apps/')
table.insert(naughty.config.icon_dirs, '/usr/share/icons/elementary-xfce/panel/48/')
table.insert(naughty.config.icon_dirs, '/usr/share/icons/elementary-xfce/notifications/48/')


-- Handle runtime errors after startup
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
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
-- beautiful.init(awful.util.get_themes_dir() .. "zenburn/theme.lua")
beautiful.init(awful.util.getdir("config") .. "/themes/holo/arkham.lua")

-- This is used later as the default terminal and editor to run.
terminal = "terminator"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- set the modkey to alt when running on 'peppy', my chromebook which runs GalliumOS
hostname = io.popen("uname -n"):read()
if hostname == "chromebook" then
   modkey = "Mod1"
   -- also set the terminal as terminator has some drawing issues
   -- on peppy with awesome 4.0
   -- terminal = "xfce4-terminal"
end

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    -- awful.layout.suit.floating,
    awful.layout.suit.tile,
    -- lain.layout.cascade.tile,
    -- awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
    awful.layout.suit.corner.nw,
    awful.layout.suit.max,
}

-- lain.layout.cascade.tile.offset_x      = 0
-- lain.layout.cascade.tile.ncol          = 2

local default_layout = awful.layout.suit.tile
local wibox_height = 22
if hostname == "GPDPocket" then
   default_layout = awful.layout.suit.max
   wibox_height = 32
end

local tags = sharedtags({
    { name = "1", layout = default_layout },
    { name = "2", layout = awful.layout.suit.max },
    { name = "3", layout = default_layout },
    { name = "4", layout = default_layout },
    { name = "5", layout = default_layout },
    { name = "6", layout = default_layout },
    { name = "7", layout = default_layout },
    { name = "8", layout = default_layout },
    { name = "9", layout = default_layout },
    { name = "0", layout = default_layout, screen = 1 },
    { name = "-", layout = awful.layout.suit.fair, screen = 1 }, -- messaging, use corner layout
    { name = "=", layout = awful.layout.suit.max, screen = 1 }
})
for tag_id,tag in pairs(tags) do
   tag.master_width_factor = 0.66
end
-- }}}

-- {{{ Helper functions
-- local function client_menu_toggle_fn()
--     local instance = nil
--
--     return function ()
--         if instance and instance.wibox.visible then
--             instance:hide()
--             instance = nil
--         else
--             instance = awful.menu.clients({ theme = { width = 250 } })
--         end
--     end
-- end
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
-- myawesomemenu = {
--    { "hotkeys", function() return false, hotkeys_popup.show_help end},
--    { "manual", terminal .. " -e man awesome" },
--    { "edit config", editor_cmd .. " " .. awesome.conffile },
--    { "restart", awesome.restart },
--    { "quit", function() awesome.quit() end}
-- }

-- mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
--                                     { "Debian", debian.menu.Debian_menu.Debian },
--                                     { "open terminal", terminal }
--                                   }
--                         })

-- mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
--                                      menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
-- mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock(" %a %b %d, %H:%M ", 1)

-- Initialize widget
cpuwidget = wibox.widget.graph()
-- Graph properties
cpuwidget:set_width(50)
cpuwidget:set_background_color(theme.bg_normal)
cpuwidget:set_color(theme.fg_focus)
-- Register widget
-- vicious.register(cpuwidget, vicious.widgets.cpu, "$1", 1)
-- cpuwidget_mirrored = wibox.container.mirror(cpuwidget, { horizontal = true })
systray = wibox.widget.systray()
systray_container = wibox.container.margin(systray, 4, 4, 4, 4)

local battery_widget = require("awesome-wm-widgets.batteryarc-widget.batteryarc")
local battery_widget_wrap = wibox.container.margin(battery_widget, 5, 2, 2, 2)
local cpu_widget = require("awesome-wm-widgets.cpu-widget.cpu-widget")

-- Create a wibox for each screen and add it
local taglist_buttons = awful.util.table.join(
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

local tasklist_buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() and c.first_tag then
                                                      c.first_tag:view_only()
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 2, function (c) c:kill() end))
                     -- awful.button({ }, 3, client_menu_toggle_fn()),
                     -- awful.button({ }, 4, function ()
                     --                          awful.client.focus.byidx(1)
                     --                      end),
                     -- awful.button({ }, 5, function ()
                     --                          awful.client.focus.byidx(-1)
                     --                      end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    -- awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
    -- Assign tags to the newly connected screen here,
    -- if desired:
    if s ~= screen.primary then
      sharedtags.movetag(tags["0"], s)
      sharedtags.movetag(tags["-"], s)
      sharedtags.movetag(tags["="], s)
   end

   s.systray = systray
   -- s.systray.visible = false -- start hidden

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = wibox_height})

    -- Add widgets to the wibox
    -- TODO: make a distinction between first and next screens
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            -- mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            -- mykeyboardlayout,
            systray_container,
            {
               layout = awful.widget.only_on_screen,
               screen = "primary", -- Only display on primary screen
               cpu_widget,
            },
            {
               layout = awful.widget.only_on_screen,
               screen = "primary", -- Only display on primary screen
               battery_widget_wrap,
            },
            -- cpuwidget_mirrored,
            {
               layout = awful.widget.only_on_screen,
               screen = "primary", -- Only display on primary screen
               mytextclock,
            },
            s.mylayoutbox,
        },
    }
    -- s.mywibox.visible = false
end)
-- }}}

-- {{{ Mouse bindings
-- root.buttons(awful.util.table.join(
--     awful.button({ }, 3, function () mymainmenu:toggle() end),
--     awful.button({ }, 4, awful.tag.viewnext),
--     awful.button({ }, 5, awful.tag.viewprev)
-- ))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey, "Shift"   }, "/",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),



    -- launch rofi when pressing mod1+space to launch anything
    awful.key({ modkey            }, "space",
               function()
                     awful.spawn( awful.util.getdir("config") .. "/scripts/rofi" )
               end,
              {description = "Launch Rofi", group = "launcher"}),
    -- also launch rofi when pressing alt-tab to switch windows
    awful.key({ "Mod1"            }, "Tab",
               function()
                     awful.spawn( awful.util.getdir("config") .. "/scripts/rofi window" )
               end,
              {description = "Switch to another client using Rofi", group = "launcher"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey }, "Delete",
        function ()
            awful.screen.focused().systray.visible = not awful.screen.focused().systray.visible
        end,
        {description = "Toggle systray visibility", group = "custom"}
    ),
    awful.key({ modkey, "Shift" }, "Delete",
        function ()
            naughty.toggle()
            -- for s in awful.screen.screen() do
            for s in screen do
               s.mywibox.visible = not s.mywibox.visible
            end
        end,
        {description = "Toggle wibar visibility", group = "custom"}
    ),
    -- awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
    --           {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey, "Shift"   }, "Return", function () awful.spawn(terminal) end,
    -- awful.key({ modkey, "Shift"   }, "Return",
    --           function ()
    --                 awful.spawn( awful.util.getdir("config") .. "/scripts/rofi-dirs2" )
    --           end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", function () awful.spawn("xfce4-session-logout") end,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),

    -- allow resizing of the slave windows
    awful.key({ modkey,           }, "Down",  function () awful.client.incwfact(-0.10)  end,
              {description = "decrease slave size", group = "layout"}),
    awful.key({ modkey,           }, "Up",    function () awful.client.incwfact( 0.10)  end,
              {description = "increase slave size", group = "layout"}),
    -- reset window facts
    awful.key({ modkey, "Shift"   }, "o",     function () awful.screen.focused().selected_tag.windowfact = {} end,
              {description = "reset the window facts", group = "layout"}),
    -- 'maximize' the client inside the current column
    awful.key({ modkey, "Control"   }, "o",     function () awful.client.setwfact(0.85) end,
              {description = "'maximize' the client inside the current column", group = "layout"}),

    awful.key({ modkey,           }, ",",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey,           }, ".",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, ",",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Shift"   }, ".",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ "Control",        }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ "Control", "Shift"}, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
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
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"})

    -- if I can't fix my muscle-memory, let's fix it with a shortcut:
    -- make <modkey>+volumeUp/Down also work (next to fn+volUp/Down on Logitech K810)
    -- awful.key({ modkey            }, "F9",    function () awful.spawn( "amixer set Master 2.5%-" ) end ),
    -- awful.key({ modkey            }, "F10",    function () awful.spawn( "amixer set Master 2.5%+" ) end )
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey,           }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "s",      function (c) c.sticky = not c.sticky          end,
              {description = "toggle sticky", group = "client"}),

    awful.key({ modkey, "Shift"   }, "h",     function (c) c.first_tag.master_width_factor = 0.33 end,
              {description = "set master to 33% of the screen", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function (c) c.first_tag.master_width_factor = 0.66 end,
              {description = "set master to 66% of the screen", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function (c) c.first_tag.master_width_factor = 0.50 end,
              {description = "set master to 50% of the screen", group = "layout"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
           local mwfact = c.first_tag.master_width_factor
           c.first_tag.master_width_factor = 0.85
           lain.util.magnify_client(c)
           c.first_tag.master_width_factor = mwfact
           c:raise()
        end,
        {description = "magnify", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "maximize", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 12 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        -- local tag = screen.tags[i]
                        local tag = tags[i]
                        if tag then
                           -- tag:view_only(tag, screen)
                           sharedtags.viewonly(tag, screen)
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      -- local tag = screen.tags[i]
                      local tag = tags[i]
                      if tag then
                         -- awful.tag.viewtoggle(tag)
                         sharedtags.viewtoggle(tag, screen)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          -- local tag = client.focus.screen.tags[i]
                          local tag = tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                              -- also jump to the target tag if it is not visible on any screen
                              -- if not tag.selected then
                              --    sharedtags.viewonly(tag)
                              -- end
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          -- local tag = client.focus.screen.tags[i]
                          local tag = tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     size_hints_honor = false,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
          "Arandr",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Wpa_gui",
          "pinentry",
          "veromix",
          "xtightvncviewer"},

        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          -- "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},


      { rule = { class = "Thunderbird", instance = "Mail" },
         properties = { tag = tags["1"] } },
      { rule = { class = "Thunderbird", instance = "Msgcompose" },
         properties = {}, callback = awful.client.setslave },
      { rule = { class = "Thunderbird", instance = "Calendar" },
         properties = {}, callback = awful.client.setslave },
      { rule = { class = "Thunderbird", instance = "Dialog" },
         properties = { placement = awful.placement.centered } },

      { rule = { class = "Hamster-indicator" },
         properties = {}, callback = awful.client.setslave },

      -- GPG Passphrase dialog
      { rule = { class = "Gcr-prompter" },
         properties = { floating = true,
                        placement = awful.placement.centered
         }
      },

      -- Remember the Milk Smart Add
      { rule = { class = "Remember The Milk", name = "Remember The Milk - Global Smart Add" },
        properties = { floating = true,
                       placement = awful.placement.centered,
                       border_width = 0,} },

      { rule = { class = "Speedcrunch" },
         properties = {}, callback = awful.client.setslave },

      -- Firefox, but only browser windows (Navigator), no dialogs etc
      -- { rule = { class = "Firefox", instance = "Navigator" },
         -- properties = { tag = tags["2"] } },
      -- Min Vid window
      -- { rule = { class = "Firefox", instance = "Toplevel" },
      { rule = { class = "mpv" },
        properties = { floating = true,
                       sticky = true,
                       ontop = true,
                       -- width = 700,
                       -- height = 394, -- 16:9 format
                       placement = awful.placement.bottom_right } },

      { rule = { class = "Pidgin" },
         properties = { tag = tags["-"] } },

      { rule = { class = "banshee" },
         properties = { tag = tags["="] } },
      { rule = { class = "[Ss]potify" },
         properties = { tag = tags["="] } },

      { rule = { class = "Shutter" },
         properties = { floating = true } },

      -- { rule = { class = "Xfce4-terminal" },
      --    properties = { floating = true } },
      --
      -- { rule = { class = "Gvim" },
      --    properties = { size_hints_honor = true } },

      -- { rule = { class = "Terminator", instance = "terminator" },
      --    properties = { floating = false } },
      -- Terminator is also started as a quake style terminal, bound to <F12>:
      -- `terminator --hidden --borderless --geometry 1920x920+0+21 --classname="quake-terminator" &`
      { rule = { class = "Terminator", name = "quake-terminator" },
         properties = { floating = true,
                        maximized_horizontal = true,
                        border_width = 0,
                        opacity = 0.85,
                        height = 920, 
                        y = 21 }
      },

      { rule = { class = "Xfce4-notifyd" },
         properties = { focus = false,
                        raise = false,
                        border_width = 0 } }

    -- Add titlebars to normal clients and dialogs
    -- { rule_any = {type = { "normal", "dialog" }
    --   }, properties = { titlebars_enabled = true }
    -- },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
   c.shape = function(cr, width ,height)
      gears.shape.rounded_rect(cr, width, height, 4)
   end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = awful.util.table.join(
        awful.button({ }, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
-- client.connect_signal("focus", function (c)
--    c.shape = function(cr, width ,height)
--       -- gears.shape.rounded_rect(cr, width, height, 20)
--       gears.shape.partially_rounded_rect(cr, width, height, true, false, false, false, 25)
--    end
--    -- c.opacity = 1
-- end)
--
-- client.connect_signal("unfocus", function (c)
--    c.shape = function(cr, width ,height)
--       gears.shape.rounded_rect(cr, width, height, 5)
--    end
--    -- c.opacity = 0.8
-- end)
