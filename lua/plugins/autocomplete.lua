return {
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'onsails/lspkind.nvim', -- Ícones para o autocompletar
    },
    config = function()
      local cmp = require 'cmp'
      local lspkind = require 'lspkind'
      local luasnip = require 'luasnip'
      local cmp_autopairs = require 'nvim-autopairs.completion.cmp'

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-k>'] = cmp.mapping.select_prev_item(),
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<C-j>'] = cmp.mapping.select_next_item(),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm { select = true },
        },

        -------------------------------------------------
        --- A ÚNICA MUDANÇA IMPORTANTE ESTÁ AQUI ABAIXO ---
        -------------------------------------------------
        sources = cmp.config.sources {
          {
            name = 'nvim_lsp',
            option = {
              -- Esta é a linha que ensina o cmp a "ler" a sintaxe do Emmet
              keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w\+\)*\)]],
            },
          },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        },

        -- Adiciona ícones bonitos na frente das sugestões
        formatting = {
          format = lspkind.cmp_format {
            mode = 'symbol_text',
            maxwidth = 50,
            ellipsis_char = '...',
          },
        },
      }

      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
  },
  {
    'L3MON4D3/LuaSnip',
    dependencies = {
      'saadparwaiz1/cmp_luasnip',
      'rafamadriz/friendly-snippets', -- <<< ADICIONE ESTA LINHA
    },
    config = function()
      -- <<< ADICIONE ESTAS DUAS LINHAS ABAIXO
      require('luasnip.loaders.from_vscode').lazy_load()
      require('luasnip').filetype_extend('html', { 'djangohtml' }) -- Bônus: faz snippets de html funcionarem em django
    end,
  },
}
