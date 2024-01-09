local keys = lvim.keys --for conciseness

lvim.leader = "space"

-- NORMAL MODE
keys.normal_mode["<C-s>"] = ":w<cr>"
keys.normal_mode["x"] = [["_x", {noremap=true, silent=true}]] -- dont copy character delete into reg
keys.normal_mode["<leader>rn"] = { "<cmd>lua vim.lsp.buf.rename()<CR>" }
keys.normal_mode["<leader>+"] = "<C-a>"                       -- inc
keys.normal_mode["<leader>-"] = "<C-x>"                       -- dec
keys.normal_mode["<leader>sv"] = "<C-w>v"                     -- split vertically
keys.normal_mode["<leader>sh"] = "<C-w>s"                     -- split horizontally
keys.normal_mode["<leader>se"] = "<C-w>="                     -- make windows equal width
keys.normal_mode["<leader>sx"] = ":close<CR>"                 -- close current split window
keys.normal_mode["ss"] = ":w<CR>"
keys.normal_mode["qq"] = ":q<CR>"
keys.normal_mode["qa"] = ":qa<CR>"

-- no arrow keys
lvim.keys.normal_mode["<up>"] = "<nop>"
lvim.keys.normal_mode["<down>"] = "<nop>"
lvim.keys.normal_mode["<left>"] = "<nop>"
lvim.keys.normal_mode["<right>"] = "<nop>"

-- make up and down half page jump centered
keys.normal_mode["<C-d>"] = "<C-d>zz"
keys.normal_mode["<C-u>"] = "<C-u>zz"


keys.normal_mode["<S-X>"] = ":BufferKill<CR>"
keys.normal_mode["<S-L>"] = ":bnext<CR>"
keys.normal_mode["<S-H>"] = ":bprevious<CR>"
keys.normal_mode["<S-T>"] = ":tabnew<CR>"

keys.normal_mode["<leader>sq"] = [["<cmd>lua vim.lsp.buf.signature_help()<CR>" , { noremap = true, silent = true }) ]]

-- INSERT MODE
keys.insert_mode["<C-s>"] = "<ESC>:w<cr>"
keys.insert_mode["jj"] = "<ESC>"
keys.insert_mode["jk"] = "<ESC>"
-- VISUAL MODE
keys.visual_mode["<leader>v"] = "\"_dP" -- paste over an area



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
vim.cmd [[
  function! Uncrustify()
    let l:current_file = expand('%:p')
    silent !uncrustify -f "l:current_file" -o "l:current_file" --no-backup
    e
  endfunction
]]

vim.cmd [[ command! Uncrustify :call Uncrustify() ]]

