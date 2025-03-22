local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

config.font = wezterm.font("JetbrainsMono Nerd Font")
config.font_size = 15

config.set_environment_variables = {
	COLORTERM = "truecolor",
}

config.enable_tab_bar = false
config.color_scheme = "OneDark (base16)"

config.keys = {
	{ key = "LeftArrow", mods = "OPT", action = act.SendString("\x1bb") },
	{ key = "RightArrow", mods = "OPT", action = act.SendString("\x1bf") },
	{ key = "f", mods = "CTRL|CMD", action = wezterm.action.ToggleFullScreen },
}
config.native_macos_fullscreen_mode = true

return config
