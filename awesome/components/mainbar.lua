local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local hotkeys_popup = require("awful.hotkeys_popup")
local lain = require("lain")

-- Widget and layout library
local wibox = require("wibox")

local volume_widget = require("awesome-wm-widgets.volume-widget.volume")

local volume = lain.widget.pulse {
    settings = function()
        vlevel = volume_now.left .. "-" .. volume_now.right .. "% | " .. volume_now.device
        if volume_now.muted == "yes" then
            vlevel = vlevel .. " M"
        end
        widget:set_markup(lain.util.markup("#7493d2", vlevel))
    end
}

local cpu = lain.widget.cpu {
    settings = function()
        widget:set_markup("Cpu " .. cpu_now.usage)
    end
}

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")


local modkey = user.modkey
local terminal = user.terminal
local editor_cmd = terminal .. " -e " .. user.editor

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
  { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
  { "manual", terminal .. " -e man awesome" },
  { "edit config", editor_cmd .. " " .. awesome.conffile },
  { "restart", awesome.restart },
  { "quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- Create item separator
textseparator = wibox.widget.textbox()
textseparator.text = " |"

local w = wibox.widget {
    orientation = 'vertical',
    widget = wibox.widget.separator,
}

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
-- Create a wibox for each screen and add it
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

local tasklist_buttons = gears.table.join(
                  awful.button({ }, 1, function (c)
                                           if c == client.focus then
                                               c.minimized = true
                                           else
                                               c:emit_signal(
                                                   "request::activate",
                                                   "tasklist",
                                                   {raise = true}
                                               )
                                           end
                                       end),
                  awful.button({ }, 3, function()
                                           awful.menu.client_list({ theme = { width = 250 } })
                                       end),
                  awful.button({ }, 4, function ()
                                           awful.client.focus.byidx(1)
                                       end),
                  awful.button({ }, 5, function ()
                                           awful.client.focus.byidx(-1)
                                       end))

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

    awful.popup {
        widget = awful.widget.tasklist {
            screen   = screen[1],
            filter   = awful.widget.tasklist.filter.allscreen,
            buttons  = tasklist_buttons,
            style    = {
                shape = gears.shape.rounded_rect,
            },
            layout   = {
                spacing = 5,
                forced_num_rows = 2,
                layout = wibox.layout.grid.horizontal
            },
            widget_template = {
                {
                    {
                        id     = 'clienticon',
                        widget = awful.widget.clienticon,
                    },
                    margins = 4,
                    widget  = wibox.container.margin,
                },
                id              = 'background_role',
                forced_width    = 48,
                forced_height   = 48,
                widget          = wibox.container.background,
                create_callback = function(self, c, index, objects) --luacheck: no unused
                    self:get_children_by_id('clienticon')[1].client = c
                end,
            },
        },
        border_color = '#777777',
        border_width = 2,
        ontop        = false,
        placement    = awful.placement.centered,
        shape        = gears.shape.rounded_rect
    }

    -- Each screen has its own tag table.
    awful.tag({ "爵 www", " term", " dev", " medias", " files", " games", " " }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({}, 1, function() awful.layout.inc(1) end),
        awful.button({}, 3, function() awful.layout.inc(-1) end),
        awful.button({}, 4, function() awful.layout.inc(1) end),
        awful.button({}, 5, function() awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    s.mytasklist1 = awful.widget.tasklist {
        screen   = s,
        filter   = awful.widget.tasklist.filter.currenttags,
        buttons  = tasklist_buttons,
        layout   = {
            spacing_widget = {
                {
                    forced_width  = 5,
                    forced_height = 24,
                    thickness     = 1,
                    color         = '#777777',
                    widget        = wibox.widget.separator
                },
                valign = 'center',
                halign = 'center',
                widget = wibox.container.place,
            },
            spacing = 1,
            layout  = wibox.layout.fixed.horizontal
        },
        -- Notice that there is *NO* wibox.wibox prefix, it is a template,
        -- not a widget instance.
        widget_template = {
            {
                wibox.widget.base.make_widget(),
                forced_height = 5,
                id            = 'background_role',
                widget        = wibox.container.background,
            },
            {
                {
                    id     = 'clienticon',
                    widget = awful.widget.clienticon,
                },
                margins = 5,
                widget  = wibox.container.margin
            },
            nil,
            create_callback = function(self, c, index, objects) --luacheck: no unused args
                self:get_children_by_id('clienticon')[1].client = c
            end,
            layout = wibox.layout.align.vertical,
        },
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            s.mypromptbox,
        },
        nil, -- Middle widget,
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            volume_widget(),
            textseparator,
            cpu.widget,
            textseparator,
            mykeyboardlayout,
            textseparator,
            mytextclock,
            textseparator,
            wibox.widget.systray(),
            s.mylayoutbox,
        },
    }
end)
-- }}}