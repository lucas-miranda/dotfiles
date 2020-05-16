local dpi = require("beautiful.xresources").apply_dpi

local theme = {}

-- Font
theme.font      = "sans 8"

-- Backgrounds
theme.bg_normal  = "#3F3F3F"
theme.bg_focus   = theme.bg_normal
theme.bg_urgent  = "#4A1E1E"
theme.bg_minimize = theme.bg_normal
theme.bg_systray = theme.bg_normal

-- Foregrounds
theme.fg_normal  = "#DCDCCC"
theme.fg_focus   = "#F0DFAF"
theme.fg_urgent  = "#CC9393"
theme.fg_minimize  = theme.fg_normal

-- Client
theme.useless_gap   = dpi(0)
theme.border_width  = dpi(2)
theme.border_normal = "#3F3F3F"
theme.border_focus  = "#6F6F6F"
theme.border_marked = "#CC9393"

-- Title
theme.titlebar_bg_focus  = "#3F3F3F"
theme.titlebar_bg_normal = "#3F3F3F"

-- Wibar
theme.wibar_height = 21

-- Taglist
theme.taglist_bg_empty      = "#3F3F3F"
theme.taglist_bg_occupied   = theme.taglist_bg_empty
theme.taglist_bg_focus      = "#1E2320"
theme.taglist_bg_urgent     = theme.taglist_bg_empty
theme.taglist_fg_empty      = theme.fg_normal
theme.taglist_fg_occupied   = theme.taglist_fg_empty
theme.taglist_fg_focus      = "#CF58ED"
theme.taglist_fg_urgent     = "#E02F2F"

-- Prompt
theme.prompt_bg         = "#292929"
theme.prompt_fg         = "#DCDCCC"
theme.prompt_bg_cursor  = theme.prompt_bg
theme.prompt_fg_cursor  = "#CF58ED"

-- Others
theme.mouse_finder_color = "#CC9393"
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)

-- Sensors
theme.sensor_bg = "#2E2E2E"

-- Icons

-- Taglist
theme.taglist_squares_sel   = themes_dir .. "/dark/taglist/squarefz.png"
theme.taglist_squares_unsel = themes_dir .. "/dark/taglist/squarez.png"

-- Layout
theme.layout_tile       = themes_dir .. "/dark/layouts/tile.png"
theme.layout_tileleft   = themes_dir .. "/dark/layouts/tileleft.png"
theme.layout_tilebottom = themes_dir .. "/dark/layouts/tilebottom.png"
theme.layout_tiletop    = themes_dir .. "/dark/layouts/tiletop.png"
theme.layout_fairv      = themes_dir .. "/dark/layouts/fairv.png"
theme.layout_fairh      = themes_dir .. "/dark/layouts/fairh.png"
theme.layout_spiral     = themes_dir .. "/dark/layouts/spiral.png"
theme.layout_dwindle    = themes_dir .. "/dark/layouts/dwindle.png"
theme.layout_max        = themes_dir .. "/dark/layouts/max.png"
theme.layout_fullscreen = themes_dir .. "/dark/layouts/fullscreen.png"
theme.layout_magnifier  = themes_dir .. "/dark/layouts/magnifier.png"
theme.layout_floating   = themes_dir .. "/dark/layouts/floating.png"
theme.layout_cornernw   = themes_dir .. "/dark/layouts/cornernw.png"
theme.layout_cornerne   = themes_dir .. "/dark/layouts/cornerne.png"
theme.layout_cornersw   = themes_dir .. "/dark/layouts/cornersw.png"
theme.layout_cornerse   = themes_dir .. "/dark/layouts/cornerse.png"

-- Sensors
theme.sensor_harddisk   = "~/.local/share/icons/Arc-ICONS/devices/16/drive-harddisk.png"

return theme
