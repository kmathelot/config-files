-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- main theme
require("theme.default")

-- Main configuration
require("main.user_vars")
require("main.error_handlers")
require("main.rules")

-- Global bindings
require("bindings.global_keys")
require("bindings.global_buttons")
require("bindings.tags")

-- status bar and
require("statusbar.mainbar")
require("main.signals")