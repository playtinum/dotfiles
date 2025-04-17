-- plugins/lsp/handlers.lua
local M = {}

-- Keep track of all active LSP clients
M.clients = {}

-- General LSP setup
function M.setup()
  -- Configure diagnostic display
  vim.diagnostic.config({
    underline = true,
    update_in_insert = false,
    virtual_text = {
      spacing = 4,
      source = "if_many",
      prefix = "●",
    },
    severity_sort = true,
    float = {
      border = "rounded",
      source = "always",
    },
    signs = true,
  })

  -- Define diagnostic signs
  local signs = {
    { name = "DiagnosticSignError", text = "✘" },
    { name = "DiagnosticSignWarn", text = "▲" },
    { name = "DiagnosticSignHint", text = "⚑" },
    { name = "DiagnosticSignInfo", text = "ℹ" },
  }

  -- Set up diagnostic signs
  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  -- Configure hover and signature help
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover,
    { border = "rounded" }
  )

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    { border = "rounded" }
  )
end

-- Called when LSP attaches to a buffer
function M.on_attach(callback)
  -- Set up autocommand to call callback on LspAttach
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and buffer then
        callback(client, buffer)
      end
    end,
  })
end

-- Helper function to attach specific method handlers
function M.on_supports_method(method, callback)
  M.on_attach(function(client, buffer)
    if client.supports_method(method) then
      callback(client, buffer)
    end
  end)
end

-- Handle dynamic capability registration
function M.on_dynamic_capability(handler)
  for _, client in ipairs(vim.lsp.get_clients()) do
    if client.server_capabilities then
      handler(client, client.bufnr or 0)
    end
  end
end

-- Get active clients with optional filtering
function M.get_clients(opts)
  opts = opts or {}
  local ret = {}

  -- Get all clients or filter by buffer
  local clients = opts.bufnr and vim.lsp.get_clients({ bufnr = opts.bufnr }) or vim.lsp.get_clients()

  -- Additional filtering if needed
  for _, client in ipairs(clients) do
    if not opts.filter or opts.filter(client) then
      table.insert(ret, client)
    end
  end

  return ret
end

-- Format document using LSP
function M.format_document(opts)
  opts = opts or {}
  local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()

  -- Check for clients that support formatting
  local clients = M.get_clients({
    bufnr = bufnr,
    filter = function(client)
      return client.supports_method("textDocument/formatting")
    end,
  })

  if #clients == 0 then
    vim.notify("No LSP clients available for formatting", vim.log.levels.WARN)
    return
  end

  vim.lsp.buf.format({
    bufnr = bufnr,
    timeout_ms = opts.timeout_ms or 1000,
  })
end

-- Check if a specific server is enabled
function M.is_enabled(server_name)
  -- Simple implementation - you can extend this with config options later
  return true
end

-- Disable a server under certain conditions
function M.disable(server_name, condition)
  -- Implement if needed for your specific use case
end

return M
