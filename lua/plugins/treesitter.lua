return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  lazy = false,
  config = function()
    -- 🔧 Registrar parser custom (modo compatível com versões novas)
    -- local parser_config = require("nvim-treesitter.parsers")
    --
    -- parser_config.htmldjango = {
    --   install_info = {
    --     url = "https://github.com/interdependence/tree-sitter-htmldjango",
    --     files = { "src/parser.c", "src/scanner.cc" }, -- importante!
    --     branch = "main",
    --   },
    --   filetype = "htmldjango",
    -- }

    -- 🔧 Configuração padrão
    require("nvim-treesitter").setup({
      ensure_installed = {
        "c", "lua", "vim", "vimdoc",
        "javascript", "typescript",
        "html", "css", "json",
        "python", "dart",
        "markdown", "markdown_inline",
        "bash", "http"
      },

      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "htmldjango" },
        disable = function(_, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
          return ok and stats and stats.size > max_filesize
        end,
      },

      indent = { enable = true },
      auto_install = true,
    })

    -- 🔧 Associar filetype manualmente (ESSENCIAL pro Django)
    vim.filetype.add({
      extension = {
        html = "htmldjango",
      },
    })
  end,
}
