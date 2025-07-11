-- lua/core/autocmds.lua

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Grupo para evitar duplicação de autocomandos
local my_augroup = augroup('MyAutocommands', { clear = true })

-- Highlight ao copiar texto (yank)
autocmd('TextYankPost', {
  group = my_augroup,
  desc = 'Highlight ao copiar (yank)',
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Configurações específicas para Markdown
autocmd('FileType', {
  group = my_augroup,
  pattern = 'markdown',
  desc = 'Habilitar quebra de linha visual para Markdown',
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
    vim.opt_local.showbreak = '↪ '
  end,
})