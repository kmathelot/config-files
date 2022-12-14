-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- 
require("main.error_handlers")

local awful = require("awful")
local beautiful = require("beautiful")
local menubar = require("menubar")
local gears = require("gears")

-- user configuration
user = {
    -- This is used later as the default terminal and editor to run.
    terminal = "alacritty",
    editor = os.getenv("EDITOR") or "nano",

    -- Default modkey.
    -- Usually, Mod4 is the key with a logo between Control and Alt.
    -- If you do not like this or do not have such a key,
    -- I suggest you to remap Mod4 to another key using xmodmap or other tools.
    -- However, you can use another modifier like Mod1, but it may interact with others.
    modkey = "Mod4",
}

-- Menubar configuration
menubar.utils.terminal = user.terminal -- Set the terminal for applications that require it
-- }}}

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    -- awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.floating,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}

-- Themes define colours, icons, font and wallpapers.
beautiful.init(os.getenv("HOME") .. "/.config/awesome/themes/default/theme.lua")

-- rules 
require("rules")

-- Global bindings
require("bindings.global_keys")
require("bindings.global_buttons")
require("bindings.tags")

-- status bar and tools
require("components.mainbar")

-- Signals
require("main.signals")