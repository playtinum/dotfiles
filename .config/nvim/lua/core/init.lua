-- Setup essentials before anything
-- NOTE: Do this first to make sure mapleader is set
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Setup keymaps
require('core.keymaps')

-- Setup options
require('core.options')

-- Setup auto-commands
require('core.autocmds')

-- Load Package Manager
require('core.pkgmgr')

-- Load utilities
require('utils')

-- Bootstrap our the plugin manager
require('lazy').setup({
  spec = {
    { import = 'plugins' },
  },
  install = {
    colorscheme = {
      'tokyonight-night',
      'habamax'
    }
  }
})
