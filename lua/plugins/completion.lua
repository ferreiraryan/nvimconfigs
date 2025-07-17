-- Autocomplete moderno com nvim-cmp
return {
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp', -- Fonte para o LSP
      'hrsh7th/cmp-buffer', -- Fonte para o texto do buffer atual
      'hrsh7th/cmp-path', -- Fonte para caminhos de arquivo
      'L3MON4D3/LuaSnip', -- Dependência para snippets
      'saadparwaiz1/cmp_luasnip', -- Integração de snippets com cmp
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        -- Mapeamentos para navegar e confirmar sugestões
        mapping = cmp.mapping.preset.insert {
          ['<C-k>'] = cmp.mapping.select_prev_item(),
          ['<C-j>'] = cmp.mapping.select_next_item(),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          -- A mágica do auto-import acontece aqui ao confirmar
          ['<CR>'] = cmp.mapping.confirm { select = true },
        },
        -- Ordem das fontes de sugestão
        sources = cmp.config.sources {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        },
      }
    end,
  },

  -- Autopairs integrado com nvim-cmp
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    dependencies = { 'hrsh7th/nvim-cmp' },
    config = function()
      require('nvim-autopairs').setup {}
      -- Integração para que o autopairs não atrapalhe a confirmação do cmp
      local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
      require('cmp').event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
  },
}
