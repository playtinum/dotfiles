return {
  -- LSP Configuration & Plugins
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },

      -- Optional dependencies
      -- { "hrsh7th/cmp-nvim-lsp" }, -- Uncomment if you use nvim-cmp
    },
    config = function()
      -- Import the lsp modules
      local lsp = require("plugins.lsp.handlers")
      local keymaps = require("plugins.lsp.keymaps")

      -- 1. Set up LSP handlers, diagnostics, etc.
      lsp.setup()

      -- 2. Configure keymaps when an LSP attaches to a buffer
      lsp.on_attach(function(client, buffer)
        keymaps.on_attach(client, buffer)

        -- Add additional client-specific settings here if needed
        -- For example: document highlighting
        if client.supports_method("textDocument/documentHighlight") then
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = buffer,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = buffer,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end)

      -- 3. Set up inlay hints
      lsp.on_supports_method("textDocument/inlayHint", function(client, buffer)
        -- Only enable if the buffer has a file type
        if vim.api.nvim_buf_is_valid(buffer) and vim.bo[buffer].buftype == "" then
          vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
        end
      end)

      -- 4. Set up code lens support
      lsp.on_supports_method("textDocument/codeLens", function(client, buffer)
        vim.lsp.codelens.refresh()
        vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
          buffer = buffer,
          callback = vim.lsp.codelens.refresh,
        })
      end)

      -- 5. Server-specific configuration
      local servers = require('plugins.lsp.servers')

      -- Default capabilities
      local capabilities = vim.lsp.protocol.make_client_capabilities()

      -- Add cmp_nvim_lsp capabilities if available
      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if has_cmp then
        capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
      end

      -- 6. Setup mason and configure LSP servers
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })

      require("mason-lspconfig").setup({
        -- Automatically install configured servers
        automatic_installation = true,
        -- Ensure these servers are always installed
        ensure_installed = {
          "lua_ls",
          -- Add other servers you want always installed
        },
      })

      -- Setup all servers with their configurations
      require("mason-lspconfig").setup_handlers({
        -- Default handler for all servers
        function(server_name)
          local opts = {
            capabilities = capabilities,
          }

          -- Add server-specific settings if they exist
          if servers[server_name] then
            opts = vim.tbl_deep_extend("force", opts, servers[server_name])
          end

          -- Setup the server
          require("lspconfig")[server_name].setup(opts)
        end,

        -- Example of overriding the default handler for specific servers:
        -- ["rust_analyzer"] = function()
        --   require("rust-tools").setup({})
        -- end,
      })
    end,
  },

  -- Add mason as a separate plugin entry
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {},
  }
}
