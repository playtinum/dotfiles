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

return M
