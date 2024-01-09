lvim.log.level = "warn"
lvim.colorscheme = "tokyonight"
lvim.background = "dark"
lvim.format_on_save = false
lvim.builtin.alpha.mode = "dashboard"
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
vim.opt.relativenumber = true
-- vim.opt.background = "dark"
vim.opt.scrolloff = 8 -- is one of my fav
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.laststatus = 0

lvim.builtin.cmp.formatting = {
  format = require("tailwindcss-colorizer-cmp").formatter
}
require('tailwind-sorter').setup({
  on_save_enabled = false,                                                                                   -- If `true`, automatically enables on save sorting.
  on_save_pattern = { '*.html', '*.js', '*.jsx', '*.tsx', '*.twig', '*.hbs', '*.php', '*.heex', '*.astro' }, -- The file patterns to watch and sort.
  node_path = 'node',
})

-- lvim.builtin.nvimtree.setup.renderer.webdev_colors = true
-- os.setenv("MY_VARIABLE", "my_value")
