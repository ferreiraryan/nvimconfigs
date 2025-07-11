return {
  {
    'preservim/vim-markdown',
    ft = { 'markdown' },
    init = function()
      vim.g.vim_markdown_folding_disabled = 0
      vim.g.vim_markdown_conceal = 0
    end,
  },
  {
    'reedes/vim-pencil',
    ft = { 'markdown' },
    config = function()
      vim.cmd([[ autocmd FileType markdown PencilSoft ]])
    end,
  },
  {
    'lukas-reineke/headlines.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    ft = { 'markdown' },
    config = function()
      require('headlines').setup({
        markdown = {
          fat_headlines = true,
          fat_headline_upper_string = '▔',
          fat_headline_lower_string = ' ',
        },
      })
    end,
  },
}