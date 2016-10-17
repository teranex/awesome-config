-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
-- local naughty = require("naughty")
local menubar = require("menubar")

local lain = require("lain")

local sharedtags = require("sharedtags")

local vicious = require("vicious")

-- require("cheeky")

-- Load Debian menu entries
require("debian.menu")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
-- beautiful.init("/usr/share/awesome/themes/default/theme.lua")
-- beautiful.init(awful.util.getdir("config") .. "/themes/default/theme.lua")
beautiful.init(awful.util.getdir("config") .. "/themes/holo/theme.lua")

-- This is used later as the default terminal and editor to run.
-- terminal = "x-terminal-emulator"
terminal = "terminator"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- if we are running on ChromeOS use alt as the modkey as it obviously
-- does not have a windows key
if io.open("/usr/local/bin/croutonversion", "r") then
   modkey = "Mod1"
end

-- also set the modkey to alt when running on 'peppy', my chrombook which runs GalliumOS
hostname = io.popen("uname -n"):read()
if hostname == "peppy" then
   modkey = "Mod1"
end

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    -- awful.layout.suit.tile,
    lain.layout.uselesstile,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    lain.layout.uselesstile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    lain.layout.uselessfair,
    lain.layout.uselessfair.horizontal,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.floating,
    awful.layout.suit.max,
    lain.layout.termfair,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
-- tags = {}
-- for s = 1, screen.count() do
--     -- Each screen has its own tag table.
--     tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
-- end
local tags = sharedtags({
    { name = "1", layout = layouts[1] },
    { name = "2", layout = layouts[1] },
    { name = "3", layout = layouts[1] },
    { name = "4", layout = layouts[1] },
    { name = "5", layout = layouts[1] },
    { name = "6", layout = layouts[1] },
    { name = "7", layout = layouts[1] },
    { name = "8", layout = layouts[1] },
    { name = "9", layout = layouts[1] },
    { name = "0", layout = layouts[1], screen = 2 },
    { name = "-", layout = layouts[4], screen = 2 }, -- messaging, use fair layout
    { name = "=", layout = layouts[1], screen = 2 }
})
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
-- myawesomemenu = {
--    { "manual", terminal .. " -e man awesome" },
--    { "edit config", editor_cmd .. " " .. awesome.conffile },
--    { "restart", awesome.restart },
--    { "quit", awesome.quit }
-- }

-- mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
--                                     { "Debian", debian.menu.Debian_menu.Debian },
--                                     { "open terminal", terminal }
--                                   }
--                         })

-- mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
--                                      menu = mymainmenu })

-- Menubar configuration
menubar.app_folders = { "/usr/share/applications/", "/home/jeroen/scripts/desktop/applications/" }
menubar.cache_entries = true
menubar.show_categories = false
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock(" %a %b %d, %H:%M ", 1)
mytextclock:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("orage -t") end)
))

widget_spacer = wibox.widget.textbox(" ")

-- Initialize widget
cpuwidget = awful.widget.graph()
-- Graph properties
cpuwidget:set_width(50)
cpuwidget:set_background_color(theme.bg_normal)
cpuwidget:set_color(theme.fg_focus)
-- Register widget
vicious.register(cpuwidget, vicious.widgets.cpu, "$1", 1)
cpuwidget_mirrored = wibox.layout.mirror(cpuwidget, { vertical = true })

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 2, function (c) c:kill() end),
                     -- awful.button({ }, 3, function ()
                     --                          if instance then
                     --                              instance:hide()
                     --                              instance = nil
                     --                          else
                     --                              instance = awful.menu.clients({
                     --                                  theme = { width = 250 }
                     --                              })
                     --                          end
                     --                      end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s, height = 21 })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    -- left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then
        right_layout:add(cpuwidget_mirrored)
        right_layout:add(widget_spacer)
        right_layout:add(widget_spacer)
        right_layout:add(wibox.widget.systray())
        right_layout:add(mytextclock)
    end
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    -- awful.button({ }, 3, function () mymainmenu:toggle() end),
    -- awful.button({ }, 4, awful.tag.viewnext),
    -- awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

function tag_view_empty(direction, sc)
   local s = sc or mouse.screen or 1
   local scr = screen[s]

   for i = 1, #awful.tag.gettags(s) do
       awful.tag.viewidx(direction,s)
       if #awful.client.visible(s) == 0 then
           return
       end
   end
end

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    -- jump to the next non-empty workspace
    awful.key({ modkey, "Control" }, "Right", function () lain.util.tag_view_nonempty(1) end),
    -- jump to the next empty workspace
    awful.key({ modkey, "Shift" }, "Right", function () tag_view_empty(1) end),

    -- launch rofi when pressing mod1+space to launch anything
    awful.key({ modkey            }, "space",
        function()
            awful.util.spawn_with_shell( awful.util.getdir("config") .. "/scripts/rofi" )
        end),
    -- also launch rofi when pressing alt-tab to switch windows
    awful.key({ "Mod1"            }, "Tab",
        function()
            awful.util.spawn_with_shell( awful.util.getdir("config") .. "/scripts/rofi window" )
            -- local offset = screen[mouse.screen].workarea
            -- cheeky.util.switcher({
            --     show_tag = true,
            --     show_screen = true,
            --     notification_hide = true,
            --     coords = { x = (offset.width - 650) / 2 + offset.x , y = 300 },
            --     menu_theme = { height = 30, width = 650 },
            -- })
        end),

    awful.key({          }, "F11",
        function()
            awful.util.spawn_with_shell( awful.util.getdir("config") .. "/scripts/vimwiki" )
        end),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    -- awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey, "Shift"   }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    -- awful.key({ modkey, "Shift"   }, "q", awesome.quit),
    awful.key({ modkey, "Shift"   }, "q", function () awful.util.spawn_with_shell( "xfce4-session-logout" ) end),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    -- awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.setmwfact(0.33)     end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.setmwfact(0.66)     end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.tag.setmwfact(0.50)     end),
    awful.key({ modkey            }, ",",     function () awful.tag.incnmaster( 1)      end),
    -- awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey            }, ".",     function () awful.tag.incnmaster(-1)      end),
    -- awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Shift"   }, ",",     function () awful.tag.incncol( 1)         end),
    -- awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey, "Shift"   }, ".",     function () awful.tag.incncol(-1)         end),
    awful.key({ "Control",        }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ "Control", "Shift"}, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end),

    -- if I can't fix my muscle-memory, let's fix it with a shortcut:
    -- make <modkey>+volumeUp/Down also work (next to fn+volUp/Down on Logitech K810)
    awful.key({ modkey            }, "F9",    function () awful.util.spawn_with_shell( "amixer set Master 2.5%-" ) end ),
    awful.key({ modkey            }, "F10",    function () awful.util.spawn_with_shell( "amixer set Master 2.5%+" ) end ),

    -- auto detect displays
    awful.key({ modkey, "Shift"   }, "s",     function () awful.util.spawn_with_shell( "disper -e -tleft" ) end ),
    -- suspend
    -- awful.key({ "Control" , "Mod1"}, "s",  function () awful.util.spawn_with_shell( awful.util.getdir("config") .. "/scripts/suspend" ) end )
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey,           }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "s",      function (c) c.sticky = not c.sticky          end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
            if c.maximized_vertical then
               c:raise()
            end
        end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 12 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        -- local screen = mouse.screen
                        -- local tag = awful.tag.gettags(screen)[i]
                        local tag = tags[i]
                        if tag then
                           -- awful.tag.viewonly(tag)
                           sharedtags.viewonly(tag)
                        end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      -- local screen = mouse.screen
                      -- local tag = awful.tag.gettags(screen)[i]
                      local tag = tags[i]
                      if tag then
                         -- awful.tag.viewtoggle(tag)
                         sharedtags.viewtoggle(tag)
                      end
                  end),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          -- local tag = awful.tag.gettags(client.focus.screen)[i]
                          local tag = tags[i]
                          if tag then
                              awful.client.movetotag(tag)
                              -- also jump to the target tag if it is not visible on any screen
                              if not tag.selected then
                                 sharedtags.viewonly(tag)
                              end
                          end
                     end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          -- local tag = awful.tag.gettags(client.focus.screen)[i]
                          local tag = tags[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end))
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
                     size_hints_honor = false,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },

    { rule = { class = "Thunderbird", instance = "Mail" },
      properties = { tag = tags[1] } },

    -- GPG Passphrase dialog
    { rule = { class = "Gcr-prompter" },
      properties = { floating = true },
      callback = function (c)
          awful.placement.centered(c, nil)
      end
    },

    -- Firefox, but only browser windows (Navigator), on dialogs etc
    { rule = { class = "Firefox", instance = "Navigator" },
      properties = { tag = tags[2] } },

    { rule = { class = "Pidgin" },
      properties = { tag = tags[11] } },

    { rule = { class = "banshee" },
      properties = { tag = tags[12] } },
    { rule = { class = "Spotify" },
      properties = { tag = tags[12] } },

    { rule = { class = "Gvim" },
      properties = { size_hints_honor = false } },

    { rule = { class = "Gvim", name = "vimwiki-tdrop" },
      properties = { floating = true, x = 192, y = 23 } },

    -- Google Calendar should float by default
    { rule = { class = "google-chrome-beta", instance = "calendar.google.com" },
      properties = { floating = true } },

    -- { rule = { class = "Hamster-indicator" },
    --   properties = { floating = true } },

    { rule = { class = "Shutter" },
      properties = { floating = true } },

    { rule = { class = "Terminator", instance = "terminator" },
      properties = { floating = false } },
    -- Terminator is also started as a quake style terminal, bound to <F12>:
    -- `terminator --hidden --borderless --geometry 1920x920+0+21 --classname="quake-terminator" &`
    { rule = { class = "Terminator", instance = "quake-terminator" },
      properties = { floating = true,
                     maximized_horizontal = true,
                     border_width = 0,
                     opacity = 0.95 },
      callback = function (c)
                    c:geometry({ y = 21, height = 920 })
                 end
    },

    { rule = { class = "Xfce4-notifyd" },
      properties = { focus = false,
                     raise = false,
                     border_width = 0 } },

    { rule = { class = "Xfdesktop" },
      properties = { border_width = 0 } },

    { rule = { class = "Orage" },
      properties = { floating = true },
      callback = function (c)
                    local win_x = screen[c.screen].workarea.width - 268
                    c:geometry({ width = 248, height = 177, y = 21, x = win_x })
                 end
    },
 
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    elseif not c.size_hints.user_position and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count change
        awful.placement.no_offscreen(c)
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
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

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
