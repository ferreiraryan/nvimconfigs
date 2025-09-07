-- lua/plugins/lsp.lua

return {
  -- 1. GERENCIADOR DE PACOTES: Mason
  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    opts = {
      ui = {
        icons = {
          package_installed = '✓',
          package_pending = '➜',
          package_uninstalled = '✗',
        },
      },
    },
  },

  -- 2. CONFIGURAÇÃO DO LSP: A VERSÃO FINAL E COMPLETA
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim',          tag = 'legacy',                            opts = {} },
      { 'akinsho/flutter-tools.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
    },
    config = function()
      -- Lista de servidores de linguagem (LSPs) completa
      local lsp_servers = {
        'ruff',
        'lua_ls',
        'pyright',
        'cssls',
        'emmet_ls', -- << Reativado
        'html',
        'jsonls',
        'tailwindcss', -- << Reativado
        'tsserver',
        'dartls',
        'jdtls',
        'marksman',
        'djlint',
      }

      local on_attach = function(client, bufnr)
        if pcall(require, 'lsp_signature') then
          require('lsp_signature').on_attach({
            bind = true,
            handler_opts = { border = 'rounded' },
          }, bufnr)
        end
        local map = function(mode, keys, func, desc)
          vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
        end
        map('n', 'K', vim.lsp.buf.hover, 'Mostrar Documentação')
        map('n', 'gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('n', 'gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('n', 'gi', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('n', '<leader>rn', vim.lsp.buf.rename, '[R]e[n]omear')
        map({ 'n', 'v' }, '<leader>la', vim.lsp.buf.code_action, '[L]SP [A]ction')
      end

      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      require('mason-lspconfig').setup {
        ensure_installed = lsp_servers,
        handlers = {
          -- Handler padrão para configurar a maioria dos servidores
          function(server_name)
            require('lspconfig')[server_name].setup {
              on_attach = on_attach,
              capabilities = capabilities,
            }
          end,

          -----------------------------------------------------------------
          --- CONFIGURAÇÃO EXPLÍCITA PARA EVITAR CONFLITOS ---
          -----------------------------------------------------------------
          ['html'] = function()
            require('lspconfig').html.setup {
              on_attach = on_attach,
              capabilities = capabilities,
              filetypes = { 'html', 'jinja.html', 'djangohtml' },
            }
          end,

          ['emmet_ls'] = function()
            require('lspconfig').emmet_ls.setup {
              on_attach = on_attach,
              capabilities = capabilities,
              filetypes = { 'html', 'css', 'scss', 'javascriptreact', 'typescriptreact', 'jinja.html', 'djangohtml' },
            }
          end,
          ['marksman'] = function()
            require('lspconfig').marksman.setup {
              capabilities = capabilities,
              on_attach = function(client, bufnr)
                -- 1. Executa sua função on_attach padrão para ter os atalhos
                on_attach(client, bufnr)

                -- 2. Desativa os diagnósticos APENAS para este buffer
                vim.diagnostic.disable(bufnr)
              end,
            }
          end,

          -- Handler especial para Dart
          ['dartls'] = function()
            require('flutter-tools').setup {}
            require('lspconfig').dartls.setup {
              on_attach = function(client, bufnr)
                on_attach(client, bufnr)
                local fmap = function(keys, func, desc)
                  vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'Flutter: ' .. desc })
                end
                fmap('<leader>fr', require('flutter-tools').reload, '[F]lutter [R]eload')
                fmap('<leader>fR', require('flutter-tools').restart, '[F]lutter [R]estart')
                fmap('<leader>fq', require('flutter-tools').quit, '[F]lutter [Q]uit App')
              end,
              capabilities = capabilities,
            }
          end,
          ['djlint'] = function()
            lspconfig.djlint.setup {
              filetypes = { 'html', 'djangohtml', 'htmldjango' },
            }
          end,
          ['tsserver'] = function()
            require('lspconfig').tsserver.setup {
              on_attach = function(client, bufnr)
                -- chama o on_attach padrão (atalhos, etc.)
                on_attach(client, bufnr)

                -- desativa o formatador do tsserver (deixa pra prettier ou null-ls)
                client.server_capabilities.documentFormattingProvider = false
                client.server_capabilities.documentRangeFormattingProvider = false

                -- atalhos extras só pra TS/JS
                local map = function(mode, keys, func, desc)
                  vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = 'TS: ' .. desc })
                end

                map('n', '<leader>oi', function()
                  vim.lsp.buf.execute_command({
                    command = '_typescript.organizeImports',
                    arguments = { vim.api.nvim_buf_get_name(0) },
                  })
                end, '[O]rganizar [I]mports')
              end,
              capabilities = capabilities,
              filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
            }
          end,

        },
      }
    end,
  },

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
}
