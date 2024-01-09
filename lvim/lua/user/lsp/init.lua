require "user.lsp.languages.js-ts"

lvim.lsp.diagnostics.virtual_text = false
lvim.lsp.automatic_servers_installation = true
require("lvim.lsp.manager").setup("cssls", {
  settings = {
    css = {
      validate = true,
      lint = {
        unknownAtRules = "ignore"
      }
    },
    scss = {
      validate = true,
      lint = {
        unknownAtRules = "ignore"
      }
    },
    less = {
      validate = true,
      lint = {
        unknownAtRules = "ignore"
      }
    },
  },
})
require("lvim.lsp.manager").setup("tailwindcss", {})
require("lvim.lsp.manager").setup("html", {})
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  {
    command = "shfmt",
    args = { "-i", "4", "-ci", "-s" },
    filetypes = { "sh" },
  },
  {
    command = "clang-format",
    filetypes = { "c" }
  }
}

function CopyDiagnosticsAtCursorToClipboard()
  -- Get the current buffer number
  local bufnr = vim.api.nvim_get_current_buf()

  -- Get the cursor position
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local cursor_line = cursor_pos[1] - 1
  local cursor_col = cursor_pos[2]

  -- Get diagnostics for the current buffer and line
  local diagnostics = vim.diagnostic.get(bufnr, { lnum = cursor_line })

  -- Filter diagnostics at the cursor's position
  local cursor_diagnostics = {}
  for _, diagnostic in ipairs(diagnostics) do
    if cursor_col >= diagnostic.col and cursor_col <= diagnostic.end_col then
      table.insert(cursor_diagnostics, diagnostic.source .. ": " .. diagnostic.message)
    end
  end

  -- Copy diagnostics at the cursor to the clipboard
  if #cursor_diagnostics > 0 then
    local diagnostics_str = table.concat(cursor_diagnostics, "\n")
    vim.fn.setreg('+', diagnostics_str)
    print("Diagnostics copied to clipboard")
  else
    print("No diagnostics at cursor")
  end
end

lvim.lsp.on_attach_callback = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local opts = { noremap = true, silent = true }

  -- Set keybindings for navigating signatures
  buf_set_keymap("n", "<C-m>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  buf_set_keymap("n", "<C-e>", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  buf_set_keymap("n", "<C-y>", "<cmd>lua CopyDiagnosticsAtCursorToClipboard()<CR>", opts);
end


vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    -- Enable signs
    signs = true,
  }
)
