lvim.builtin.alpha.active = true
lvim.builtin.lualine.active = false

lvim.plugins = {
  {
    {
      'laytan/tailwind-sorter.nvim',
      requires = { 'nvim-treesitter/nvim-treesitter', 'nvim-lua/plenary.nvim' },
      config = function() require('tailwind-sorter').setup() end,
      run = 'cd formatter && npm i && npm run build',
    },
    "roobert/tailwindcss-colorizer-cmp.nvim",
    "jose-elias-alvarez/typescript.nvim",
    "rafamadriz/neon",
    "bluz71/vim-nightfly-colors",
    as = "nightfly",
    "luisiacc/gruvbox-baby",
    "catppuccin/nvim",
    "sainnhe/gruvbox-material",
    "christoomey/vim-tmux-navigator",
    "justinmk/vim-sneak",
    "levouh/tint.nvim",
    "nyoom-engineering/oxocarbon.nvim",
    "MunifTanjim/nui.nvim"
  },
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end
  },
  -- Packer
  -- {
  --   "jackMort/ChatGPT.nvim",
  --   config = function()
  --     require("chatgpt").setup(
  --     -- optional configuration
  --     )
  --   end,
  --   requires = {
  --     "MunifTanjim/nui.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "nvim-telescope/telescope.nvim"
  --   }
  -- },
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
  {
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    setup = function() vim.g.mkdp_filetypes = { "markdown" } end,
    ft = { "markdown" },
  },
  -- { "ellisonleao/gruvbox.nvim" },
  {
    "neanias/everforest-nvim",
    -- Optional; default configuration will be used if setup isn't called.
    config = function()
      require("everforest").setup()
    end,
  },
  {
    "tpope/vim-surround",
    -- setup = function()
    --  vim.o.timeoutlen = 500
    -- end
  }
}
