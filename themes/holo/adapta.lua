
--[[
                                
     Holo Awesome WM config 2.0 
     github.com/copycat-killer  
                                
--]]
--
--
-- Blue:     #00bcd4
-- Green:    #4db6ac
-- DarkGrey: #29353b
-- Darkest:  #263238

local rounded_shape = function(cr, width, height)
     require("gears.shape").rounded_rect(cr, width, height, 6)
end

theme                               = {}

theme.notification_shape            = rounded_shape
theme.notification_margin           = 10

theme.icon_dir                      = os.getenv("HOME") .. "/.config/awesome/themes/holo/icons"
theme.layouts_dir                   = os.getenv("HOME") .. "/.config/awesome/themes/holo/layouts"

-- theme.wallpaper                     = os.getenv("HOME") .. "/.config/awesome/themes/holo/wall.png"

theme.topbar_path                   = "png:" .. theme.icon_dir .. "/topbar/"

-- theme.font                          = "Tamsyn 10.5"
theme.font          = "Cantarell 9"
-- theme.taglist_font                  = "Tamsyn 8"
theme.fg_normal                     = "#FFFFFF"
theme.fg_focus                      = "#00bcd4"
theme.bg_normal                     = "#29353b"
theme.fg_urgent                     = "#FD971F"
theme.bg_urgent                     = "#263238"
-- theme.bg_minimize                   = theme.bg_normal
-- theme.fg_minimize                   = "#688696"
theme.bg_minimize                   = "#00bcd4"
theme.fg_minimize                   = theme.fg_normal
theme.useless_gap                   = 7
theme.border_width                  = 2
-- theme.border_normal                 = "#252525"
-- theme.border_normal                 = "#CECECE"
theme.border_normal                 = "#29353b"
theme.border_focus                  = "#00bcd4"
theme.taglist_fg_focus              = "#FFFFFF"
theme.taglist_bg_focus              = "png:" .. theme.icon_dir .. "/adapta_taglist_bg_focus_21px.png"
theme.tasklist_bg_normal            = "#29353b"
theme.tasklist_fg_focus             = "#4db6ac"
-- theme.tasklist_bg_focus             = "png:" .. theme.icon_dir .. "/bg_focus_noline_21px.png"
theme.textbox_widget_margin_top     = 1
theme.awful_widget_height           = 14
theme.awful_widget_margin_top       = 2
theme.menu_height                   = "20"
theme.menu_width                    = "400"

theme.widget_bg                     = theme.icon_dir .. "/bg_focus_noline.png"
theme.awesome_icon                  = theme.icon_dir .. "/awesome_icon.png"
theme.vol_bg                        = theme.icon_dir .. "/vol_bg.png"
theme.submenu_icon                  = theme.icon_dir .. "/submenu.png"
theme.taglist_squares_sel           = theme.icon_dir .. "/adapta_square_sel2.png"
theme.taglist_squares_unsel         = theme.icon_dir .. "/adapta_square_sel2.png"
theme.last                          = theme.icon_dir .. "/last.png"
theme.spr                           = theme.icon_dir .. "/spr.png"
theme.spr_small                     = theme.icon_dir .. "/spr_small.png"
theme.spr_very_small                = theme.icon_dir .. "/spr_very_small.png"
theme.spr_right                     = theme.icon_dir .. "/spr_right.png"
theme.spr_bottom_right              = theme.icon_dir .. "/spr_bottom_right.png"
theme.spr_left                      = theme.icon_dir .. "/spr_left.png"
theme.bar                           = theme.icon_dir .. "/bar.png"
theme.bottom_bar                    = theme.icon_dir .. "/bottom_bar.png"
theme.mpd                           = theme.icon_dir .. "/mpd.png"
theme.mpd_on                        = theme.icon_dir .. "/mpd_on.png"
theme.prev                          = theme.icon_dir .. "/prev.png"
theme.nex                           = theme.icon_dir .. "/next.png"
theme.stop                          = theme.icon_dir .. "/stop.png"
theme.pause                         = theme.icon_dir .. "/pause.png"
theme.play                          = theme.icon_dir .. "/play.png"
theme.clock                         = theme.icon_dir .. "/clock.png"
theme.calendar                      = theme.icon_dir .. "/cal.png"
theme.cpu                           = theme.icon_dir .. "/cpu.png"
theme.net_up                        = theme.icon_dir .. "/net_up.png"
theme.net_down                      = theme.icon_dir .. "/net_down.png"
theme.widget_mail_notify            = theme.icon_dir .. "/mail_notify.png"

-- titlebar_[bg|fg]_[normal|focus]
theme.titlebar_bg_normal = "#29353b"
theme.titlebar_bg_focus  = "#00bcd4"

-- theme.layout_tile                   = theme.icon_dir .. "/tile.png"
-- theme.layout_tilegaps               = theme.icon_dir .. "/tilegaps.png"
-- theme.layout_tileleft               = theme.icon_dir .. "/tileleft.png"
-- theme.layout_tilebottom             = theme.icon_dir .. "/tilebottom.png"
-- theme.layout_tiletop                = theme.icon_dir .. "/tiletop.png"
-- theme.layout_fairv                  = theme.icon_dir .. "/fairv.png"
-- theme.layout_fairh                  = theme.icon_dir .. "/fairh.png"
-- theme.layout_spiral                 = theme.icon_dir .. "/spiral.png"
-- theme.layout_dwindle                = theme.icon_dir .. "/dwindle.png"
-- theme.layout_max                    = theme.icon_dir .. "/max.png"
-- theme.layout_fullscreen             = theme.icon_dir .. "/fullscreen.png"
-- theme.layout_magnifier              = theme.icon_dir .. "/magnifier.png"
-- theme.layout_floating               = theme.icon_dir .. "/floating.png"
-- theme.layout_fairh = theme.icon_dir .. "/layouts/fairhw.png"
-- theme.layout_fairv = theme.icon_dir .. "/layouts/fairvw.png"
-- theme.layout_floating  = theme.icon_dir .. "/layouts/floatingw.png"
-- theme.layout_magnifier = theme.icon_dir .. "/layouts/magnifierw.png"
-- theme.layout_max = theme.icon_dir .. "/layouts/maxw.png"
-- theme.layout_fullscreen = theme.icon_dir .. "/layouts/fullscreenw.png"
-- theme.layout_tilebottom = theme.icon_dir .. "/layouts/tilebottomw.png"
-- theme.layout_tileleft   = theme.icon_dir .. "/layouts/tileleftw.png"
-- theme.layout_tile = theme.icon_dir .. "/layouts/tilew.png"
-- theme.layout_tiletop = theme.icon_dir .. "/layouts/tiletopw.png"
-- theme.layout_spiral  = theme.icon_dir .. "/layouts/spiralw.png"
-- theme.layout_dwindle = theme.icon_dir .. "/layouts/dwindlew.png"

theme.tasklist_disable_icon         = true
-- theme.tasklist_floating             = ""
-- theme.tasklist_maximized_horizontal = ""
-- theme.tasklist_maximized_vertical   = ""

-- lain related
-- theme.useless_gap_width             = 5
-- theme.layout_uselesstile            = theme.icon_dir .. "/layouts/tilew.png"
-- theme.layout_uselesstileleft        = theme.icon_dir .. "/layouts/uselesstileleft.png"
-- theme.layout_uselesstiletop         = theme.icon_dir .. "/uselesstiletop.png"
-- theme.layout_uselesstilebottom      = theme.icon_dir .. "/layouts/tilebottomw.png"
-- theme.layout_uselessfair            = theme.icon_dir .. "/layouts/fairvw.png"
-- theme.layout_uselessfairh           = theme.icon_dir .. "/layouts/fairhw.png"
-- theme.layout_termfair               = theme.icon_dir .. "/layouts/termfairw.png"

-- You can use your own layout icons like this:
theme.layout_fairh = theme.layouts_dir .. "/fairhw.png"
theme.layout_fairv = theme.layouts_dir .. "/fairvw.png"
theme.layout_floating  = theme.layouts_dir .. "/floatingw.png"
theme.layout_magnifier = theme.layouts_dir .. "/magnifierw.png"
theme.layout_max = theme.layouts_dir .. "/maxw.png"
theme.layout_fullscreen = theme.layouts_dir .. "/fullscreenw.png"
theme.layout_tilebottom = theme.layouts_dir .. "/tilebottomw.png"
theme.layout_tileleft   = theme.layouts_dir .. "/tileleftw.png"
theme.layout_tile = theme.layouts_dir .. "/tilew.png"
theme.layout_tiletop = theme.layouts_dir .. "/tiletopw.png"
theme.layout_spiral  = theme.layouts_dir .. "/spiralw.png"
theme.layout_dwindle = theme.layouts_dir .. "/dwindlew.png"
theme.layout_cornernw = theme.layouts_dir .. "/cornernww.png"
theme.layout_cornerne = theme.layouts_dir .. "/cornernew.png"
theme.layout_cornersw = theme.layouts_dir .. "/cornersww.png"
theme.layout_cornerse = theme.layouts_dir .. "/cornersew.png"
theme.layout_cascadetile = theme.layouts_dir .. "/cascade.png"

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil


-- GPD Pocet specific
local hostname = io.popen("uname -n"):read()
if hostname == "GPDPocket" then
    theme.font          = "Cantarell 20"
    theme.taglist_bg_focus              = "png:" .. theme.icon_dir .. "/taglist_bg_focus_32px.png"
    theme.taglist_squares_sel           = theme.icon_dir .. "/square_sel_hidpi.png"
    theme.taglist_squares_unsel         = theme.icon_dir .. "/square_unsel_hidpi.png"
end

return theme
