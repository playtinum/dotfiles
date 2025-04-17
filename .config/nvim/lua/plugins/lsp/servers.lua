local M = {}
-- Lua LSP configuration
M.lua_ls = {
  settings = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      diagnostics = { globals = { "vim" } },
      hint = { enable = true },
      completion = { callSnippet = "Replace" },
    },
  },
}

-- Add more servers as needed:
-- M.pyright = {},
-- M.tsserver = {},

return M
