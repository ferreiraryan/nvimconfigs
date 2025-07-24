-- lazy.nvim
return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter.configs').setup {
      ensure_installed = { 'c', 'lua', 'vim', 'vimdoc', 'javascript', 'typescript', 'html', 'css', 'json', 'python', 'dart' },
      highlight = { enable = true },
      indent = { enable = true },
      auto_install = true,
    }
  end,
}
