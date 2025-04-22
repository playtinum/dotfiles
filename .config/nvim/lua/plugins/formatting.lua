return {
  'stevearc/conform.nvim',
  event = 'LazyFile',
  cmd = { 'ConformInfo' },
  keys = { {
    '<leader>cf',
    function()
      test()
      require('conform').format({ lsp_format = 'fallback', timeout_ms = 3000 })
    end,
    mode = { 'n', 'v' },
    desc = 'Format buffer',
  } },
  opts = {
    formatters_by_ft = {
      lua = { 'stylua' }
    }
  },
}
