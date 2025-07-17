-- Arquivo de restauração para um estado estável

return {
  ------------------------------------------------------------------
  -- Bloco 1: Sua configuração original do blink.cmp, que já funcionava
  ------------------------------------------------------------------
  {
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
      },
      'folke/lazydev.nvim',
    },
    opts = {
      -- Restaurando seu mapeamento original e simples
      keymap = {
        preset = 'default',
        ['<S-Tab>'] = { 'select_prev', 'fallback' },
        ['<Tab>'] = { 'select_next', 'fallback' },
        ['<Enter>'] = { 'select_and_accept', 'fallback' },
      },

      -- Restaurando o resto das suas opções originais
      appearance = {
        nerd_font_variant = 'mono',
      },
      completion = {
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },
      snippets = { preset = 'luasnip' },
      fuzzy = { implementation = 'lua' },
      signature = { enabled = true },
    },
  },

  ------------------------------------------------------------------
  -- Bloco 2: nvim-autopairs da forma mais simples, sem conflitos
  ------------------------------------------------------------------
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    -- Nenhuma configuração complexa, apenas o setup padrão.
    opts = {},
  },
}
