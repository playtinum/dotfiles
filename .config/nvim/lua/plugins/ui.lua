return {
  -- {
  --   "nvim-lualine/lualine.nvim",
  --   event = "VeryLazy",
  --   opts = {
  --     theme = 'auto',
  --     globalstatus = vim.o.laststatus == 3,
  --     disable_filetypes = { statusline = { 'snacks_dashboard' } },
  --   }
  --   -- TODO: add better filepath
  -- },
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        styles = {
          comments = { italic = false }, -- Disable italics in comments
        },
      }

      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },
  {
    'echasnovski/mini.statusline',
    version = false,
    event = 'VeryLazy',
    opts = {
      use_icons = true,
      section_location = function()
        return '%2l:%-2v'
      end
    },
  },
  -- {
  --   'echasnovski/mini.icons',
  --   version = false,
  --   lazy = true,
  -- },
  { "MunifTanjim/nui.nvim", lazy = true },
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = false },
      dashboard = { enabled = false },
      indent = { enabled = false },
      input = { enabled = false },
      picker = { enabled = true },
      notifier = { enabled = false },
      quickfile = { enabled = false },
      scope = { enabled = false },
      scroll = { enabled = false },
      statuscolumn = { enabled = false },
      words = { enabled = false },
    },
  },
  -- Explorer
  {
    'folke/snacks.nvim',
    opts = {
      explorer = { enabled = true },
    },
    keys = {
      {
        "<leader>fe",
        function()
          Snacks.explorer({ cwd = LazyVim.root() })
        end,
        desc = "Explorer Snacks (root dir)",
      },
      {
        "<leader>fE",
        function()
          Snacks.explorer()
        end,
        desc = "Explorer Snacks (cwd)",
      },
      { "<leader>e", "<leader>fe", desc = "Explorer Snacks (root dir)", remap = true },
      { "<leader>E", "<leader>fE", desc = "Explorer Snacks (cwd)",      remap = true },
    },
  }
}
