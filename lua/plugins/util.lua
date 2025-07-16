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



}