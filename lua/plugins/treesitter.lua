-- lazy.nvim
return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function()
    --- PASSO 1: Registrar o parser customizado do Django ---
    local parser_config = require('nvim-treesitter.parsers').get_parser_configs()

    parser_config.htmldjango = {
      install_info = {
        -- A URL do repositório que você encontrou
        url = 'https://github.com/interdependence/tree-sitter-htmldjango',
        files = { 'src/parser.c' },
        -- O nome da linguagem que o parser usa internamente
        language = 'htmldjango',
      },
      -- Mapeia este parser para o filetype 'htmldjango'
      filetype = 'htmldjango',
    }
    require('nvim-treesitter.configs').setup {
      ensure_installed = {
        'c',
        'lua',
        'vim',
        'vimdoc',
        'javascript',
        'typescript',
        'html',
        'css',
        'json',
        'python',
        'dart',
        'json',
        'markdown',
        'bash',
        'htmldjango',
      },
      highlight = {
        enable = true,
        -- Desativa o highlight para arquivos muito grandes para não travar o editor.
        disable = function(lang, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
        -- Desativamos o highlighting por regex do Vim, pois o Treesitter é superior.
        additional_vim_regex_highlighting = { 'htmldjango' },
      },
      indent = { enable = true },
      auto_install = true,
    }
  end,
}
