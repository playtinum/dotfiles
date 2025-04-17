local map = require("utils.keymap")

-- Navigation
map.normal("<C-h>", "<C-w>h", "Go to Left Window", { remap = true })
map.normal("<C-j>", "<C-w>j", "Go to Lower Window", { remap = true })
map.normal("<C-k>", "<C-w>k", "Go to Upper Window", { remap = true })
map.normal("<C-l>", "<C-w>l", "Go to Right Window", { remap = true })

-- Resizing
map.normal("<C-Up>", "<cmd>resize +2<cr>", "Increase Window Height")
map.normal("<C-Down>", "<cmd>resize -2<cr>", "Decrease Window Height")
map.normal("<C-Left>", "<cmd>vertical resize -2<cr>", "Decrease Window Width")
map.normal("<C-Right>", "<cmd>vertical resize +2<cr>", "Increase Window Width")

-- Splitting
map.leader("|", "<C-W>v", "Split Window Right", { remap = true })
map.leader("-", "<C-W>s", "Split Window Below", { remap = true })
map.leader("wd", "<C-W>c", "Delete Window", { remap = true })
