-- Mostra atalhos pendentes
return {
  'folke/which-key.nvim',
  event = 'VimEnter',
  opts = {
    delay = 0,
    spec = {
      { '<leader>s', group = '[S]earch' },
      { '<leader>f', group = '[F]ormat/[F]ile' },
      { '<leader>w', group = '[W]indow' },
      { '<leader>r', group = '[R]est' },
      { '<leader>t', group = '[T]oggle' },
      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      { 'gr', group = '[G]oto [R]eference (LSP)' },
    },
  },
}