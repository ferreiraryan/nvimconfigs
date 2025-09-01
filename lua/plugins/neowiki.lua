return {
  'echaya/neowiki.nvim',
  -- Opcional: descomente as linhas abaixo para configurar
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
  },
  opts = {
    wiki_dirs = {
      -- neowiki.nvim supports both absolute and tilde-expanded paths
      path = vim.fn.expand '~/GoogleDrive/vimwiki',
      { name = 'Local Wiki', path = '~/local/local' },
      { name = 'Personal',   path = 'personal/wiki' },
    },
  },
  keys = {
    { '<leader>ww', "<cmd>lua require('neowiki').open_wiki()<cr>",          desc = 'Open Wiki' },
    { '<leader>wW', "<cmd>lua require('neowiki').open_wiki_floating()<cr>", desc = 'Open Wiki in Floating Window' },
    { '<leader>wT', "<cmd>lua require('neowiki').open_wiki_new_tab()<cr>",  desc = 'Open Wiki in Tab' },
  },
}
