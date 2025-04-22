local M = {}
-- Lua LSP configuration
M.lua_ls = {
  settings = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      diagnostics = { globals = { "vim" } },
      completion = { callSnippet = "Replace" },
      codeLens = {
        enable = true,
      },
      doc = {
        privateName = { "^_" },
      },
      hint = {
        enable = true,
        setType = false,
        paramType = true,
        paramName = "Disable",
        semicolon = "Disable",
        arrayIndex = "Disable",
      },
    },
  },
}

-- Add more servers as needed:
-- M.pyright = {},
-- M.tsserver = {},

return M
