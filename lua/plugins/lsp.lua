-- ~/.config/nvim/lua/plugins/lsp.lua

return {
  -- 1. GERENCIADOR DE PACOTES LSP: Mason
  -- Instala e gerencia LSPs, Formatadores e Linters.
  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    config = function()
      require('mason').setup {
        ui = {
          icons = {
            package_installed = '✓',
            package_pending = '➜',
            package_uninstalled = '✗',
          },
        },
      }
    end,
  },

  -- 2. CONFIGURAÇÃO DO LSP: O cérebro da operação
  -- Conecta Mason, lspconfig, flutter-tools e fidget.
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
      {
        'akinsho/flutter-tools.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
      },
    },
    config = function()
      local servers = {
        -- LSPs
        'lua_ls',
        'pyright',
        'cssls',
        'html',
        'jsonls',
        'tailwindcss',
        'tsserver',
        'dartls',
        -- Formatadores (para o conform.nvim)
        'stylua',
        'black',
        'prettierd',
      }

      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local on_attach = function(client, bufnr)
        require('lsp_signature').on_attach({
          bind = true,
          handler_opts = { border = 'rounded' },
        }, bufnr)

        local map = function(mode, keys, func, desc)
          vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
        end

        map('n', 'K', vim.lsp.buf.hover, 'Mostrar Documentação')
        map('n', 'gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('n', 'gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('n', 'gi', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('n', '<leader>rn', vim.lsp.buf.rename, '[R]e[n]omear')
        map({ 'n', 'v' }, '<leader>la', vim.lsp.buf.code_action, '[C]ode [A]ction')
      end

      -- *** A CORREÇÃO ESTÁ AQUI ***
      -- Juntamos a instalação e a configuração dos handlers em uma única chamada.
      require('mason-lspconfig').setup {
        ensure_installed = servers,
        automatic_installation = true,
        handlers = {
          -- Handler Padrão para a maioria dos LSPs
          function(server_name)
            require('lspconfig')[server_name].setup {
              on_attach = on_attach,
              capabilities = capabilities,
            }
          end,
          -- Handler Especial para Dart/Flutter
          ['dartls'] = function()
            require('flutter-tools').setup {} -- Configura o flutter-tools
            require('lspconfig').dartls.setup {
              capabilities = capabilities,
              on_attach = function(client, bufnr)
                on_attach(client, bufnr) -- Atalhos globais
                -- Atalhos específicos do Flutter
                local fmap = function(keys, func, desc)
                  vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'Flutter: ' .. desc })
                end
                -- MUDANÇAS AQUI:
                fmap('<leader>rr', require('flutter-tools').reload, '[R]eload')
                fmap('<leader>rR', require('flutter-tools').restart, '[R]estart')
                fmap('<leader>rq', require('flutter-tools').quit, '[Q]uit App')
              end,
            }
          end,
        },
      }
    end,
  },
  -- 3. AUTOCOMPLETAR: nvim-cmp e seus complementos
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
          ['<C-j>'] = cmp.mapping.select_next_item(),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm { select = true },
        },
        -- Fontes para o autocompletar
        sources = cmp.config.sources {
          { name = 'nvim_lsp' },
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
    end,
  },

  {
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
  },
  -- 5. AJUDA DE ASSINATURA: Mostra parâmetros de funções
  {
    'ray-x/lsp_signature.nvim',
    event = 'VeryLazy',
    opts = {
      bind = true,
      handler_opts = {
        border = 'rounded',
      },
    },
  },

  -- 6. SYNTAX HIGHLIGHTING: Treesitter
  -- Essencial para o LSP funcionar com precisão e para um código mais legível.
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = { 'c', 'lua', 'vim', 'vimdoc', 'javascript', 'typescript', 'html', 'css', 'json', 'python', 'dart' },
        highlight = { enable = true },
        indent = { enable = true },
        auto_install = true,
      }
    end,
  },
}
