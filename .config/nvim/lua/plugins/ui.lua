return {
  {
    "snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
          ██████╗ ██╗      █████╗ ██╗   ██╗████████╗██╗███╗   ██╗██╗   ██╗███╗   ███╗          ✨
          ██╔══██╗██║     ██╔══██╗╚██╗ ██╔╝╚══██╔══╝██║████╗  ██║██║   ██║████╗ ████║      ✧    
          ██████╔╝██║     ███████║ ╚████╔╝    ██║   ██║██╔██╗ ██║██║   ██║██╔████╔██║   ★       
          ██╔═══╝ ██║     ██╔══██║  ╚██╔╝     ██║   ██║██║╚██╗██║██║   ██║██║╚██╔╝██║ ✦         
          ██║     ███████╗██║  ██║   ██║      ██║   ██║██║ ╚████║╚██████╔╝██║ ╚═╝ ██║           
          ╚═╝     ╚══════╝╚═╝  ╚═╝   ╚═╝      ╚═╝   ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝     ╚═╝           
   ]],
        },
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      opts.sections.lualine_z = {
        { "progress", separator = " ", padding = { left = 1, right = 0 } },
        { "location", padding = { left = 0, right = 1 } },
      }
      opts.sections.lualine_y = { "encoding", "fileformat", "filetype" }
    end,
  },
}
