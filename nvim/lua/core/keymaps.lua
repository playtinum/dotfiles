local M = {}

-- Core keymap function with defaults and automatic description
function M.set(modes, lhs, rhs, desc, opts)
  opts = opts or {}
  if desc then opts.desc = desc end
  if type(modes) == "string" then modes = { modes } end
  
  for _, mode in ipairs(modes) do
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

-- Specialized mapping creators
function M.normal(lhs, rhs, desc, opts)
  M.set("n", lhs, rhs, desc, opts)
end

function M.visual(lhs, rhs, desc, opts)
  M.set("v", lhs, rhs, desc, opts)
end

function M.insert(lhs, rhs, desc, opts)
  M.set("i", lhs, rhs, desc, opts)
end

function M.terminal(lhs, rhs, desc, opts)
  M.set("t", lhs, rhs, desc, opts)
end

function M.multiple(modes, lhs, rhs, desc, opts)
  M.set(modes, lhs, rhs, desc, opts)
end

-- Create command maps
function M.cmd(modes, lhs, command, desc, opts)
  opts = opts or {}
  local rhs = "<cmd>" .. command .. "<cr>"
  M.set(modes, lhs, rhs, desc, opts)
end

-- Create leader maps more easily
function M.leader(lhs, rhs, desc, opts)
  opts = opts or {}
  M.set("n", "<leader>" .. lhs, rhs, desc, opts)
end

-- Leader command maps
function M.leader_cmd(lhs, command, desc, opts)
  opts = opts or {}
  M.cmd("n", "<leader>" .. lhs, command, desc, opts)
end

-- Window management shortcuts
function M.window_maps()
  -- Navigation
  M.normal("<C-h>", "<C-w>h", "Go to Left Window", { remap = true })
  M.normal("<C-j>", "<C-w>j", "Go to Lower Window", { remap = true })
  M.normal("<C-k>", "<C-w>k", "Go to Upper Window", { remap = true })
  M.normal("<C-l>", "<C-w>l", "Go to Right Window", { remap = true })
  
  -- Resizing
  M.normal("<C-Up>", "<cmd>resize +2<cr>", "Increase Window Height")
  M.normal("<C-Down>", "<cmd>resize -2<cr>", "Decrease Window Height")
  M.normal("<C-Left>", "<cmd>vertical resize -2<cr>", "Decrease Window Width")
  M.normal("<C-Right>", "<cmd>vertical resize +2<cr>", "Increase Window Width")
  
  -- Splitting
  M.leader("|", "<C-W>v", "Split Window Right", { remap = true })
  M.leader("-", "<C-W>s", "Split Window Below", { remap = true })
  M.leader("wd", "<C-W>c", "Delete Window", { remap = true })
end

-- Buffer management shortcuts
function M.buffer_maps()
  M.normal("<S-h>", "<cmd>bprevious<cr>", "Prev Buffer")
  M.normal("<S-l>", "<cmd>bnext<cr>", "Next Buffer")
  M.normal("[b", "<cmd>bprevious<cr>", "Prev Buffer")
  M.normal("]b", "<cmd>bnext<cr>", "Next Buffer")
  M.leader("bb", "<cmd>e #<cr>", "Switch to Other Buffer")
  M.leader("`", "<cmd>e #<cr>", "Switch to Other Buffer")
  
  -- Custom buffer delete functions
  M.leader("bd", function()
    require("utils").bufdelete()
  end, "Delete Buffer")
  
  M.leader("bo", function()
    require("utils").bufdelete.other()
  end, "Delete Other Buffers")
  
  M.leader_cmd("bD", ":bd", "Delete Buffer and Window")
end

-- Diagnostic navigation
function M.diagnostic_maps()
  local function goto_diagnostic(next, severity)
    local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
    severity = severity and vim.diagnostic.severity[severity] or nil
    return function()
      go({ severity = severity })
    end
  end
  
  M.normal("]d", goto_diagnostic(true), "Next Diagnostic")
  M.normal("[d", goto_diagnostic(false), "Prev Diagnostic")
  M.normal("]e", goto_diagnostic(true, "ERROR"), "Next Error")
  M.normal("[e", goto_diagnostic(false, "ERROR"), "Prev Error")
  M.normal("]w", goto_diagnostic(true, "WARN"), "Next Warning")
  M.normal("[w", goto_diagnostic(false, "WARN"), "Prev Warning")
  M.leader("cd", vim.diagnostic.open_float, "Line Diagnostics")
end

-- Line movement
function M.line_movement_maps()
  M.normal("<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", "Move Down")
  M.normal("<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", "Move Up")
  M.insert("<A-j>", "<esc><cmd>m .+1<cr>==gi", "Move Down")
  M.insert("<A-k>", "<esc><cmd>m .-2<cr>==gi", "Move Up")
  M.visual("<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", "Move Down")
  M.visual("<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", "Move Up")
end

-- Tab management
function M.tab_maps()
  M.leader_cmd("<tab>l", "tablast", "Last Tab")
  M.leader_cmd("<tab>f", "tabfirst", "First Tab")
  M.leader_cmd("<tab><tab>", "tabnew", "New Tab")
  M.leader_cmd("<tab>]", "tabnext", "Next Tab")
  M.leader_cmd("<tab>[", "tabprevious", "Previous Tab")
  M.leader_cmd("<tab>d", "tabclose", "Close Tab")
  M.leader_cmd("<tab>o", "tabonly", "Close Other Tabs")
end

-- Create toggle functions
function M.create_toggle(option, config)
  local toggle = require("utils").toggle
  
  if type(option) == "string" then
    return toggle.option(option, config)
  elseif type(option) == "function" then
    return toggle[option](config)
  end
end

-- Setup toggle maps
function M.setup_toggles()
  local LazyVim = require("lazyvim")
  local Snacks = require("snacks")
  
  -- Format toggles
  LazyVim.format.snacks_toggle():map("<leader>uf")
  LazyVim.format.snacks_toggle(true):map("<leader>uF")
  
  -- Option toggles
  M.create_toggle("spell", { name = "Spelling" }):map("<leader>us")
  M.create_toggle("wrap", { name = "Wrap" }):map("<leader>uw")
  M.create_toggle("relativenumber", { name = "Relative Number" }):map("<leader>uL")
  
  -- Function toggles
  Snacks.toggle.diagnostics():map("<leader>ud")
  Snacks.toggle.line_number():map("<leader>ul")
  
  -- Complex option toggles
  Snacks.toggle.option("conceallevel", { 
    off = 0, 
    on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, 
    name = "Conceal Level" 
  }):map("<leader>uc")
  
  -- Additional toggles
  Snacks.toggle.zoom():map("<leader>wm"):map("<leader>uZ")
  Snacks.toggle.zen():map("<leader>uz")
  
  -- Inlay hints toggle (conditional based on availability)
  if vim.lsp.inlay_hint then
    Snacks.toggle.inlay_hints():map("<leader>uh")
  end
end

-- Git integration
function M.setup_git()
  local Snacks = require("snacks")
  local LazyVim = require("lazyvim")
  
  if vim.fn.executable("lazygit") == 1 then
    M.leader("gg", function() 
      Snacks.lazygit({ cwd = LazyVim.root.git() }) 
    end, "Lazygit (Root Dir)")
    
    M.leader("gG", function() 
      Snacks.lazygit() 
    end, "Lazygit (cwd)")
    
    M.leader("gf", function() 
      Snacks.picker.git_log_file() 
    end, "Git Current File History")
    
    M.leader("gl", function() 
      Snacks.picker.git_log({ cwd = LazyVim.root.git() }) 
    end, "Git Log")
    
    M.leader("gL", function() 
      Snacks.picker.git_log() 
    end, "Git Log (cwd)")
  end
  
  M.leader("gb", function() 
    Snacks.picker.git_log_line() 
  end, "Git Blame Line")
  
  M.multiple({"n", "x"}, "<leader>gB", function() 
    Snacks.gitbrowse() 
  end, "Git Browse (open)")
  
  M.multiple({"n", "x"}, "<leader>gY", function()
    Snacks.gitbrowse({ 
      open = function(url) vim.fn.setreg("+", url) end, 
      notify = false 
    })
  end, "Git Browse (copy)")
end

-- Terminal integration
function M.setup_terminal()
  local Snacks = require("snacks")
  local LazyVim = require("lazyvim")
  
  M.leader("fT", function() 
    Snacks.terminal() 
  end, "Terminal (cwd)")
  
  M.leader("ft", function() 
    Snacks.terminal(nil, { cwd = LazyVim.root() }) 
  end, "Terminal (Root Dir)")
  
  M.normal("<c-/>", function() 
    Snacks.terminal(nil, { cwd = LazyVim.root() }) 
  end, "Terminal (Root Dir)")
  
  M.normal("<c-_>", function() 
    Snacks.terminal(nil, { cwd = LazyVim.root() }) 
  end, "which_key_ignore")
  
  M.terminal("<C-/>", "<cmd>close<cr>", "Hide Terminal")
  M.terminal("<c-_>", "<cmd>close<cr>", "which_key_ignore")
end

-- Setup all mappings
function M.setup()
  -- Better movement
  M.multiple({"n", "x"}, "j", "v:count == 0 ? 'gj' : 'j'", "Down", { expr = true, silent = true })
  M.multiple({"n", "x"}, "<Down>", "v:count == 0 ? 'gj' : 'j'", "Down", { expr = true, silent = true })
  M.multiple({"n", "x"}, "k", "v:count == 0 ? 'gk' : 'k'", "Up", { expr = true, silent = true })
  M.multiple({"n", "x"}, "<Up>", "v:count == 0 ? 'gk' : 'k'", "Up", { expr = true, silent = true })
  
  -- Undo break points
  M.insert(",", ",<c-g>u")
  M.insert(".", ".<c-g>u")
  M.insert(";", ";<c-g>u")
  
  -- Save file
  M.multiple({"i", "x", "n", "s"}, "<C-s>", "<cmd>w<cr><esc>", "Save File")
  
  -- Better indenting
  M.visual("<", "<gv")
  M.visual(">", ">gv")
  
  -- Clear search, escape snippet
  M.multiple({"i", "n", "s"}, "<esc>", function()
    vim.cmd("noh")
    require("lazyvim").cmp.actions.snippet_stop()
    return "<esc>"
  end, "Escape and Clear hlsearch", { expr = true })
  
  -- Setup all map groups
  M.window_maps()
  M.buffer_maps()
  M.diagnostic_maps()
  M.line_movement_maps()
  M.tab_maps()
  M.setup_toggles()
  M.setup_git()
  M.setup_terminal()
  
  -- Additional mappings
  M.leader_cmd("l", "Lazy", "Lazy")
  M.leader_cmd("fn", "enew", "New File")
  M.leader_cmd("qq", "qa", "Quit All")
  M.leader("cf", function()
    require("lazyvim").format({ force = true })
  end, "Format")
  
  -- Other misc mappings
  M.normal("<leader>ui", vim.show_pos, "Inspect Pos")
  M.leader("K", "<cmd>norm! K<cr>", "Keywordprg")
  
  -- Redraw / clear search
  M.normal("<leader>ur", "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>", 
    "Redraw / Clear hlsearch / Diff Update")
  
  -- LazyVim Changelog
  M.leader("L", function() require("lazyvim").news.changelog() end, "LazyVim Changelog")
end

return M
