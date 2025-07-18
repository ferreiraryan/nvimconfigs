-- ~/.config/nvim/lua/plugins/formatting.lua

return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  opts = {
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'ruff_format', 'black' },
      
      -- Bônus: exemplos para web (SINTAXE CORRIGIDA)
      javascript = { 'prettierd', 'prettier' },      -- ANTES: { { 'prettierd', 'prettier' } }
      typescript = { 'prettierd', 'prettier' },      -- ANTES: { { 'prettierd', 'prettier' } }
      javascriptreact = { 'prettierd', 'prettier' }, -- ANTES: { { 'prettierd', 'prettier' } }
      typescriptreact = { 'prettierd', 'prettier' }, -- ANTES: { { 'prettierd', 'prettier' } }
      html = { 'prettierd', 'prettier' },            -- ANTES: { { 'prettierd', 'prettier' } }
      css = { 'prettierd', 'prettier' },             -- ANTES: { { 'prettierd', 'prettier' } }
      json = { 'prettierd', 'prettier' },            -- ANTES: { { 'prettierd', 'prettier' } }
      yaml = { 'prettierd', 'prettier' },            -- ANTES: { { 'prettierd', 'prettier' } }
      markdown = { 'prettierd', 'prettier' },        -- ANTES: { { 'prettierd', 'prettier' } }
    },

    format_on_save = {
      async = false, 
      lsp_fallback = true,
      timeout_ms = 500,
    },
  },
}
