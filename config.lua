--[[
lvim is the global options object
Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

-- general
lvim.log.level = "warn"
lvim.colorscheme = "tokyonight"
-- lvim.transparent_window = true
vim.opt.relativenumber = true
vim.opt.background = "dark"
-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false
vim.opt.termguicolors = true
-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
lvim.format_on_save = true
-- add your own keymapping


local keys = lvim.keys --for conciseness
-- keys.insert_mode
keys.normal_mode["<C-s>"] = ":w<cr>"
keys.insert_mode["<C-s>"] = "<ESC>:w<cr>"
keys.insert_mode["jj"] = "<ESC>"

-- keys.normal_mode[ "x", "_x") -- dont copy character delete into reg
keys.normal_mode["<leader>+"] = "<C-a>"       -- inc
keys.normal_mode["<leader>-"] = "<C-x>"       -- dec
keys.normal_mode["<leader>sv"] = "<C-w>v"     -- split vertically
keys.normal_mode["<leader>sh"] = "<C-w>s"     -- split horizontally
keys.normal_mode["<leader>se"] = "<C-w>="     -- make windows equal width
keys.normal_mode["<leader>sx"] = ":close<CR>" -- close current split window

keys.normal_mode["<C-M-x>"] = ":BufferKill<CR>"
keys.normal_mode["<S-L>"] = ":bnext<CR>"
keys.normal_mode["<S-H>"] = ":bprevious<CR>"
keys.normal_mode["<C-M-T>"] = ":tabnew<CR>"

-- lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
-- lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"
-- unmap a default keysping
-- vim.keys.del("n", "<C-Up>")
-- override a default keysping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>" -- or vim.keys.normal_mode[ "<C-q>", ":q<cr>" )

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
-- local _, actions = pcall(require, "telescope.actions")
-- lvim.builtin.telescope.defaults.mappings = {
--   -- for input mode
--   i = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--     ["<C-n>"] = actions.cycle_history_next,
--     ["<C-p>"] = actions.cycle_history_prev,
--   },
--   -- for normal mode
--   n = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--   },
-- }

-- Change theme settings
-- lvim.builtin.theme.options.dim_inactive = true
-- lvim.builtin.theme.options.style = "storm"

-- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.which_key.mappings["t"] = {
  name = "+Trouble",
  r = { "<cmd>Trouble lsp_references<cr>", "References" },
  f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
  d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
  q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
  l = { "<cmd>Trouble loclist<cr>", "LocationList" },
  w = { "<cmd>Trouble workspace_diagnostics<cr>", "Workspace Diagnostics" },
}
lvim.builtin.which_key.mappings["g"].v = { "<cmd>DiffviewOpen<cr>", "Open Diff View" }
lvim.builtin.which_key.mappings["g"].x = { "<cmd>DiffviewClose<cr>", "Close Diff View" }

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false
lvim.builtin.nvimtree.setup.renderer.highlight_opened_files = "all"
-- lvim.builtin.nvimtree.setup.renderer.webdev_colors = true
lvim.builtin.nvimtree.setup.renderer.icons.glyphs.folder.arrow_closed = ""
lvim.builtin.nvimtree.setup.renderer.icons.glyphs.folder.arrow_open = ""
lvim.builtin.nvimtree.on_config_done = function()
  vim.cmd([[
  highlight NvimTreeIndentMarker guifg=#b1eb34
  highlight NvimTreeOpenedFile guifg=#ffffff
]])
end
-- vim.cmd('highlight NvimTreeFolderIcon guifg=#ff0000')

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "tsx",
  "css",
  "rust",
  "java",
  "yaml",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enable = true


local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  --   { command = "black", filetypes = { "python" } },
  --   { command = "isort", filetypes = { "python" } },
  {
    --     -- each formatter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
    command = "prettier",
    --     ---@usage arguments to pass to the formatter
    --     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
    --     extra_args = { "--print-with", "100" },
    --     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
    filetypes = { "typescript", "typescriptreact" },
  },
}

-- import lualine plugin safely
local lualine = lvim.builtin.lualine
-- get lualine nightfly theme
local lualine_nightfly = require("lualine.themes.nightfly")
-- new colors for theme
local new_colors = {
  blue = "#65D1FF",
  green = "#3EFFDC",
  violet = "#006bed",
  yellow = "#FFDA7B",
  black = "#000000",
}
-- change nightlfy theme colors
lualine_nightfly.normal.a.bg = new_colors.blue
lualine_nightfly.insert.a.bg = new_colors.green
lualine_nightfly.visual.a.bg = new_colors.violet
lualine_nightfly.command = {
  a = {
    gui = "bold",
    bg = new_colors.yellow,
    fg = new_colors.black, -- black
  },
}
lualine.style = "default"
lualine.options.theme = lualine_nightfly
-- configure lualine with modified theme
-- lualine.setup({
--   options = {
--     theme = lualine_nightfly,
--   },
-- })

lvim.plugins = {
  {
    "folke/trouble.nvim",
    requires = "nvim-tree/nvim-web-devicons",
    config = function()
      require("trouble").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  },
  {
    "sindrets/diffview.nvim",
    requires = 'nvim-lua/plenary.nvim'
  },
  -- {
  --   "levouh/tint.nvim"
  -- },
  {
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    setup = function() vim.g.mkdp_filetypes = { "markdown" } end,
    ft = { "markdown" },
  },
  { "nyoom-engineering/oxocarbon.nvim" },
  {
    "neanias/everforest-nvim",
    -- Optional; default configuration will be used if setup isn't called.
    config = function()
      require("everforest").setup()
    end,
  }, {
  "windwp/nvim-ts-autotag",
  config = function()
    require("nvim-ts-autotag").setup()
  end,
},
}

-- require("tint").setup({
--   tint = -20, -- Darken colors, use a positive value to brighten
--   -- saturation = 0.6, -- Saturation to preserve
--   -- transforms = require("tint").transforms.SATURATE_TINT, -- Showing default behavior, but value here can be predefined set of transforms
--   -- tint_background_colors = true, -- Tint background portions of highlight groups
--   -- highlight_ignore_patterns = { "WinSeparator", "Status.*" }, -- Highlight group patterns to ignore, see `string.find`

-- })
-- generic LSP settings

-- -- make sure server will always be installed even if the server is in skipped_servers list
-- lvim.lsp.installer.setup.ensure_installed = {
--     "sumneko_lua",
--     "jsonls",
-- }
-- -- change UI setting of `LspInstallInfo`
-- -- see <https://github.com/williamboman/nvim-lsp-installer#default-configuration>
-- lvim.lsp.installer.setup.ui.check_outdated_servers_on_open = false
-- lvim.lsp.installer.setup.ui.border = "rounded"
-- lvim.lsp.installer.setup.ui.keyss = {
--     uninstall_server = "d",
--     toggle_server_expand = "o",
-- }

-- ---@usage disable automatic installation of servers
-- lvim.lsp.installer.setup.automatic_installation = false

-- ---configure a server manually. !!Requires `:LvimCacheReset` to take effect!!
-- ---see the full default list `:lua print(vim.inspect(lvim.lsp.automatic_configuration.skipped_servers))`
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pyright", opts)

-- ---remove a server from the skipped list, e.g. eslint, or emmet_ls. !!Requires `:LvimCacheReset` to take effect!!
-- ---`:LvimInfo` lists which server(s) are skipped for the current filetype
-- lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
--   return server ~= "emmet_ls"
-- end, lvim.lsp.automatic_configuration.skipped_servers)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

-- -- set a formatter, this will override the language server formatting capabilities (if it exists)

-- -- set additional linters
-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup {
--   { command = "flake8", filetypes = { "python" } },
--   {
--     -- each linter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
--     command = "shellcheck",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     extra_args = { "--severity", "warning" },
--   },
--   {
--     command = "codespell",
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "javascript", "python" },
--   },
-- }

-- Additional Plugins

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
-- vim.api.nvim_create_autocmd("BufEnter", {
--   pattern = { "*.json", "*.jsonc" },
--   -- enable wrap mode for json files only
--   command = "setlocal wrap",
-- })
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "zsh",
--   callback = function()
--     -- let treesitter use bash highlight for zsh files as well
--     require("nvim-treesitter.highlight").attach(0, "bash")
--   end,
-- })
