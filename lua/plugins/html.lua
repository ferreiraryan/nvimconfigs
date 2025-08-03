return {
  -- ... seus outros plugins, como o colorizer, lsp, etc.

  -- 1. Plugin para auto-fechamento e renomeio de tags HTML
  {
    'windwp/nvim-ts-autotag',
    -- Nenhuma configuração extra é necessária, ele já vem pronto para usar
  },

  -- 2. Plugin para Emmet
  {
    'mattn/emmet-vim',
    -- init = function()
    --   -- Define a tecla para expandir a abreviação Emmet
    --   vim.g.user_emmet_leader_key = '<C-e>'
    -- end,
  },
}
