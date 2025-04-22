-- plugins/lsp/keymaps.lua
local M = {}

-- Cache for keymaps
M._keys = nil

-- Get LSP keymaps
function M.get()
  if M._keys then
    return M._keys
  end

  -- Define the keymaps with server capability checks
  -- stylua: ignore
  M._keys = {
    -- Navigation
    { "gd",          vim.lsp.buf.definition,                                                                desc = "Go to Definition",        has = "definition" },
    { "gr",          vim.lsp.buf.references,                                                                desc = "Find References" },
    { "gI",          vim.lsp.buf.implementation,                                                            desc = "Go to Implementation",    has = "implementation" },
    { "gy",          vim.lsp.buf.type_definition,                                                           desc = "Go to Type Definition",   has = "typeDefinition" },
    { "gD",          vim.lsp.buf.declaration,                                                               desc = "Go to Declaration",       has = "declaration" },

    -- Documentation
    { "K",           vim.lsp.buf.hover,                                                                     desc = "Show Hover Documentation" },
    { "gK",          vim.lsp.buf.signature_help,                                                            desc = "Show Signature Help",     has = "signatureHelp" },
    { "<C-k>",       vim.lsp.buf.signature_help,                                                            mode = "i",                       desc = "Show Signature Help", has = "signatureHelp" },

    -- Code actions
    { "<leader>ca",  vim.lsp.buf.code_action,                                                               desc = "Code Action",             mode = { "n", "v" },          has = "codeAction" },
    { "<leader>cr",  vim.lsp.buf.rename,                                                                    desc = "Rename Symbol",           has = "rename" },

    -- Diagnostics
    { "<leader>cd",  vim.diagnostic.open_float,                                                             desc = "Line Diagnostics" },
    { "[d",          vim.diagnostic.goto_prev,                                                              desc = "Previous Diagnostic" },
    { "]d",          vim.diagnostic.goto_next,                                                              desc = "Next Diagnostic" },
    { "[e",          function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end, desc = "Previous Error" },
    { "]e",          function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end, desc = "Next Error" },

    -- Formatting
    { "<leader>cf",  function() require("plugins.lsp.handlers").format_document() end,                      desc = "Format Document",         has = "formatting" },

    -- Code lens (Neovim 0.10+)
    { "<leader>cl",  function() vim.lsp.codelens.run() end,                                                 desc = "Run Code Lens",           has = "codeLens" },

    -- Workspace
    { "<leader>cwa", vim.lsp.buf.add_workspace_folder,                                                      desc = "Add Workspace Folder" },
    { "<leader>cwr", vim.lsp.buf.remove_workspace_folder,                                                   desc = "Remove Workspace Folder" },
    { "<leader>cwl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,               desc = "List Workspace Folders" },
  }

  return M._keys
end

-- Check if a buffer has a specific LSP capability
function M.has(buffer, method)
  if type(method) == "table" then
    for _, m in ipairs(method) do
      if M.has(buffer, m) then
        return true
      end
    end
    return false
  end

  -- Add "textDocument/" prefix if not already present
  method = method:find("/") and method or "textDocument/" .. method

  -- Check if any client supports this method
  local clients = vim.lsp.get_clients({ bufnr = buffer })
  for _, client in ipairs(clients) do
    if client:supports_method(method) then
      return true
    end
  end

  return false
end

-- Attach keymaps to a buffer
function M.on_attach(client, buffer)
  local keymaps = M.get()

  for _, keys in pairs(keymaps) do
    -- Only set keymap if the capability is supported (or no capability required)
    local has_capability = not keys.has or M.has(buffer, keys.has)

    if has_capability then
      local opts = {
        desc = keys.desc,
        buffer = buffer,
        silent = true,
        noremap = true,
      }

      -- Get the key, function and mode
      local key = keys[1]
      local func = keys[2]
      local mode = keys.mode or "n"

      -- Set the keymap
      vim.keymap.set(mode, key, func, opts)
    end
  end
end

return M
