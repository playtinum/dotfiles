-- Coding Plugins: LSP, completion, diagnostic, etc.
return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
{
  'saghen/blink.cmp',
  event = 'InsertEnter',
  dependencies = { 'rafamadriz/friendly-snippets', {
    'saghen/blink.compat', 
    optional = true, 
    version = '*'
  } },
  -- use a release tag to download pre-built binaries
  version = '*',
  build = 'cargo build --release',
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    appearance = {
      nerd_font_variant = 'normal'
    },
    completion = { 
      accept = { 
        auto_brackets = {
          enabled = true,
        },
      },
      menu = {
        draw = {
          treesitter = { 'lsp' },
        },
      },
      documentation = { 
        auto_show = true, 
        auto_show_delay_ms = 200, 
      },
      ghost_text = {
        enabled = true,
      },
    },
    sources = {
      -- Remove the 'compat = true' line
      default = { 'lsp', 'path', 'snippets', 'buffer', 'lazydev', },
      providers = {
        lazydev = {
          name = 'LazyDev',
          module = 'lazydev.integrations.blink',
          score_offset = 100,
        }
      }
    },
    cmdline = {
      enabled = false,
    },
    keymap = { 
      preset = 'enter',
      ['<C-y>'] = { 'select_and_accept' },
    },
  },
},
{
  'echasnovski/mini.pairs', 
  event = 'VeryLazy',
  opts = {
    modes = { insert = true, command = true, terminal = false },
    skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
    skip_ts = { 'string' },
    skip_unbalanced = true,
    markdown = true,
  }},
  {
    'echasnovski/mini.ai',
    event = 'VeryLazy',
    opts = function()
      local ai = require('mini.ai')
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            -- Codeblock
            a = { '@block.outer', '@conditional.outer', '@loop.outer', },
            i = { '@block.inner', '@conditional.inner', '@loop.inner', },
          }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
          d = { "%f[%d]%d+" }, -- digits
          e = { -- Word with case
            { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
            "^().*()$",
          },  
          u = ai.gen_spec.function_call(), -- u for "Usage"
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name,
        }
      }
    end,

  },
  {
    'folke/ts-comments.nvim',
    event = 'VeryLazy',
  }
}
