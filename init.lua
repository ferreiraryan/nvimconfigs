-- init.lua

-- Define a tecla líder ANTES de carregar qualquer outra coisa
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Carrega as configurações principais
require 'core.options'
require 'core.keymaps'
require 'core.autocmd'

-- Instala e inicializa o gerenciador de plugins `lazy.nvim`
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Erro ao clonar lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Configura o Lazy para carregar os plugins da pasta lua/plugins/
require('lazy').setup {
  spec = {
    -- Importa automaticamente todos os arquivos .lua do diretório de plugins
    { import = 'plugins' },
  },
  -- Configurações da UI do Lazy
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
    rocks = {
      enabled = true,
      hererocks = true,
    },
  },
}

