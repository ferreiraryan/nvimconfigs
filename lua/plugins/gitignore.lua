return {
  'wintermute-cell/gitignore.nvim',
  dependencies = { 'nvim-telescope/telescope.nvim' }, -- Usa o Telescope como interface
  config = function()
    require 'gitignore'
  end,
  keys = {
    { '<leader>gi', '<cmd>Gitignore<cr>', desc = 'Gerar Gitignore' },
  },
}
