-- ~/.config/nvim/lua/plugins/formatting.lua

return {
  'stevearc/conform.nvim',
  opts = {
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'black' },
      javascript = { 'prettierd' },
      typescript = { 'prettierd' },
      html = { 'prettierd' },
      css = { 'prettierd' },
      json = { 'prettierd' },
      dart = { 'dart_format' },
    },
    -- Configura para formatar sempre que o arquivo for salvo
    format_on_save = {
      -- Aumentado de 500ms para 2s para evitar timeouts
      timeout_ms = 2000,
      lsp_fallback = true,
    },
  },
}
