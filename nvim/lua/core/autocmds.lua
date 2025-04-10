-- Autocommand helper fn
local function augroup(name)
  return vim.api.nvim_create_augroup('playtinum_' .. name, { clear = true })
end

-- Check if file reload is needed when it changed
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  group = augroup('checktime'),
  callback = function() 
    if vim.o.buftype ~= 'nofile' then
      vim.cmd('checktime')
    end
  end,
})

-- Yank highlight - should be default in vim 🤷‍♂️
vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup('highlight_yank'),
  callback = function()
    (vim.hl or vim.highlight).on_yank()
  end,
})
