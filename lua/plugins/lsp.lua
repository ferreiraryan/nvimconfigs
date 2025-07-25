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
                fmap('<leader>fr', require('flutter-tools').reload, '[F]lutter [R]eload')
                fmap('<leader>fR', require('flutter-tools').restart, '[F]lutter [R]estart')
                fmap('<leader>fq', require('flutter-tools').quit, '[F]lutter [Q]uit App')
              end,
            }
          end,
        },
      }
    end,
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
}
