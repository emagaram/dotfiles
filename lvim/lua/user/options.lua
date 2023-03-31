lvim.log.level = "warn"
lvim.colorscheme = "tokyonight-moon"
vim.opt.relativenumber = true
vim.opt.background = "dark"
vim.opt.scrolloff = 8 -- is one of my fav
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
lvim.format_on_save = true
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false
lvim.builtin.nvimtree.setup.renderer.highlight_opened_files = "all"
lvim.builtin.nvimtree.setup.renderer.icons.glyphs.folder.arrow_closed = ""
lvim.builtin.nvimtree.setup.renderer.icons.glyphs.folder.arrow_open = ""
lvim.builtin.nvimtree.on_config_done = function()
  vim.cmd([[
  highlight NvimTreeIndentMarker guifg=#b1eb34
  highlight NvimTreeOpenedFile guifg=#ffffff
]])
end
-- lvim.builtin.nvimtree.setup.renderer.webdev_colors = true
