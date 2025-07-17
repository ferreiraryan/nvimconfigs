-- Em lua/plugins/formatting.lua

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" }, -- Carrega o plugin antes de salvar um arquivo
  cmd = { "ConformInfo" },
  opts = {
    -- Define os formatadores para linguagens específicas
    formatters_by_ft = {
      python = { "ruff" },
      lua = { "stylua" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      html = { "prettier" },
      css = { "prettier" },
      json = { "prettier" },
      -- Adicione outras linguagens conforme necessário
    },

    -- Configuração para formatar ao salvar (format_on_save)
    format_on_save = {
      -- Permite formatar de forma assíncrona para não travar o editor
      async = false,
      -- Define um tempo limite para a formatação
      timeout_ms = 500,
      -- Permite que a formatação seja desabilitada em buffers específicos
      lsp_fallback = true,
    },
  },
  
  -- Adiciona os atalhos de teclado
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = "n",
      desc = "Formatar arquivo",
    },
  },
}
