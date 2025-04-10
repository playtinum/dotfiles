-- Setup essentials 
-- Set mapleader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Setup keymaps 
-- NOTE: Do this first to make sure mapleader is set
require('core.keymaps')

-- Setup options 
require('core.options')

-- Setup auto-commands
require('core.autocmds')

-- Bootstrap our the plugin manager
require('lazy').setup('plugins')
