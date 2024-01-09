-- Set the highlight namespace (this can be global or within some lua module)
-- Define your highlights
vim.api.nvim_set_hl(0, 'Visual', { bg='#474739', bold = false, underline = false })

-- Apply your highlights (making them active)
-- vim.api.nvim_hl_set(ns_id, 'Visual', { fg = '#ff00ff', bold = true, underline = false })
-- vim.api.nvim_hl_set(ns_id, 'VisualNC', { fg = '#00ffff', underline = false })

