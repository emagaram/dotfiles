local lualine = lvim.builtin.lualine
lualine.sections = {
  lualine_a = { 'mode' },
  lualine_b = { 'branch' }
}

lualine.options.theme = {
  normal = {
    a = {
      bg = "#00000000",
      gui = "bold"
    }
  },
}
lualine.style = "none"
-- -- get lualine nightfly theme
-- local lualine_nightfly = require("lualine.themes.nightfly")
-- -- new colors for theme
-- local new_colors = {
--   transparent = "#00000000",
--   white = "#FFFFFF"
-- }
-- -- change nightlfy theme colors
-- lualine_nightfly.normal.a.bg = new_colors.transparent
-- lualine_nightfly.insert.a.bg = new_colors.transparent
-- lualine_nightfly.visual.a.bg = new_colors.transparent
-- lualine_nightfly.replace.a.bg = new_colors.transparent

-- lualine_nightfly.normal.a.fg = new_colors.white
-- lualine_nightfly.insert.a.fg = new_colors.white
-- lualine_nightfly.visual.a.fg = new_colors.white
-- lualine_nightfly.replace.a.fg = new_colors.white
-- -- lualine_nightfly.insert.a.bg = new_colors.green
-- -- lualine_nightfly.visual.a.bg = new_colors.violet
-- lualine_nightfly.command = {
--   a = {
--     gui = "bold",
--     -- bg = new_colors.yellow,
--     -- fg = new_colors.black, -- black
--   },
-- }
-- lualine.style = "default"
-- lualine.options.theme = lualine_nightfly
-- lualine.sections.lualine_c = {}
-- lualine.sections.lualine_x = {}
-- lualine.sections.lualine_y = {}
-- lualine.sections.lualine_z = {}
