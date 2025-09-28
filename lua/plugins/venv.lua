-- lua/plugins/venv.lua

return {
  'linux-cultist/venv-selector.nvim',
  dependencies = { 'neovim/nvim-lspconfig', 'nvim-telescope/telescope.nvim' },
  -- event = 'VeryLazy',
  opts = {
    -- Nomes dos diretórios de venv que ele vai procurar
    -- O importante é que ele pode ser configurado para encontrar ambientes do pyenv
    -- mas geralmente a detecção automática já funciona bem.
  },
  keys = {
    -- Atalho principal para selecionar um venv para o projeto atual
    { '<leader>vs', '<cmd>VenvSelect<cr>',       desc = '[V]env [S]elect' },
    -- Atalho para selecionar um dos venvs usados recentemente
    { '<leader>vc', '<cmd>VenvSelectCached<cr>', desc = '[V]env [C]ached' },
  },
}
