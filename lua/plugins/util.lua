return {
  { 'NMAC427/guess-indent.nvim', opts = {} }, -- Detecta indentação automaticamente
  {
    'vimwiki/vimwiki',
    init = function()
      vim.g.vimwiki_list = {
        {
          path = '~/GoogleDrive/vimwiki',
          syntax = 'markdown',
          ext = '.md',
        },
      }
    end,
  },
  {
    'rest-nvim/rest.nvim',
    ft = { 'http', 'rest' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('rest-nvim').setup({})
      -- Keymaps para rest.nvim
      local map = vim.keymap.set
      map('n', '<leader>rr', '<cmd>Rest run<CR>', { desc = '[R]est: Executar requisição' })
      map('n', '<leader>rp', '<cmd>Rest run last<CR>', { desc = '[R]est: Repetir última requisição' })
    end,
  },
}