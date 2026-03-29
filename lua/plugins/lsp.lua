return {
  -- MASON (Instalador de LSPs)
  {
    'williamboman/mason.nvim',
    cmd = { 'Mason' },
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

  -- LSP CONFIG
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim',          opts = {} }, -- Removido 'legacy' tag para usar versão atual
      { 'akinsho/flutter-tools.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      local lspconfig = require('lspconfig')
      local mason_lspconfig = require('mason-lspconfig')

      local servers = {
        'ruff',
        'lua_ls',
        'pyright',
        'cssls',
        'emmet_ls',
        'html',
        'jsonls',
        'tailwindcss',
        'jdtls',
        'marksman',
        'clangd',
        'ts_ls',
      }

      -- KEYMAPS + ATTACH
      local on_attach = function(client, bufnr)
        -- Assinatura (lsp_signature)
        local ok, lsp_sig = pcall(require, 'lsp_signature')
        if ok then
          lsp_sig.on_attach({
            bind = true,
            handler_opts = { border = 'rounded' },
          }, bufnr)
        end

        local map = function(mode, keys, func, desc)
          vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
        end

        map('n', 'K', vim.lsp.buf.hover, 'Hover')
        map('n', 'gd', require('telescope.builtin').lsp_definitions, 'Definition')
        map('n', 'gr', require('telescope.builtin').lsp_references, 'References')
        map('n', 'gi', require('telescope.builtin').lsp_implementations, 'Implementation')
        map('n', '<leader>rn', vim.lsp.buf.rename, 'Rename')
        map({ 'n', 'v' }, '<leader>la', vim.lsp.buf.code_action, 'Code Action')

        -- TS_LS extra (antigo tsserver)
        if client.name == "ts_ls" then
          client.server_capabilities.documentFormattingProvider = false

          map('n', '<leader>oi', function()
            vim.lsp.buf.execute_command {
              command = '_typescript.organizeImports',
              arguments = { vim.api.nvim_buf_get_name(0) },
            }
          end, 'Organize Imports')
        end

        -- Flutter extra
        if client.name == "dartls" then
          local ok_flutter, ft = pcall(require, 'flutter-tools.commands')
          if ok_flutter then
            map('n', '<leader>fr', ft.reload, 'Flutter Reload')
            map('n', '<leader>fR', ft.restart, 'Flutter Restart')
            map('n', '<leader>fq', ft.quit, 'Flutter Quit')
          end
        end
      end

      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      mason_lspconfig.setup {
        ensure_installed = servers,
        handlers = {
          -- DEFAULT HANDLER
          function(server_name)
            -- Acessar via lspconfig[server_name] dispara o warning no 0.11
            -- A forma recomendada agora é usar diretamente o setup do servidor
            lspconfig[server_name].setup({
              on_attach = on_attach,
              capabilities = capabilities,
            })
          end,

          -- HTML
          ['html'] = function()
            lspconfig.html.setup {
              on_attach = on_attach,
              capabilities = capabilities,
              filetypes = { 'html', 'jinja.html', 'djangohtml' },
            }
          end,

          -- EMMET
          ['emmet_ls'] = function()
            lspconfig.emmet_ls.setup {
              on_attach = on_attach,
              capabilities = capabilities,
              filetypes = {
                'html', 'css', 'scss',
                'javascriptreact', 'typescriptreact',
                'jinja.html', 'djangohtml'
              },
            }
          end,

          -- PYRIGHT
          ['pyright'] = function()
            lspconfig.pyright.setup {
              on_attach = on_attach,
              capabilities = capabilities,
              settings = {
                python = {
                  analysis = {
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                    typeCheckingMode = 'basic',
                  },
                },
              },
            }
          end,

          -- MARKDOWN
          ['marksman'] = function()
            lspconfig.marksman.setup {
              capabilities = capabilities,
              on_attach = function(client, bufnr)
                on_attach(client, bufnr)
                vim.diagnostic.enable(false, { bufnr = bufnr }) -- Sintaxe atualizada para desabilitar
              end,
            }
          end,

          -- DART / FLUTTER
          ['dartls'] = function()
            require('flutter-tools').setup {
              lsp = {
                on_attach = on_attach,
                capabilities = capabilities,
                settings = {
                  showTodos = true,
                  completeFunctionCalls = true,
                },
                flags = {
                  allow_incremental_sync = false,
                  debounce_text_changes = 200,
                },
              },
            }
          end,
        },
      }

      -- SERVIDORES EXTERNOS AO MASON
      if vim.fn.executable('gdscript') == 1 then
        lspconfig.gdscript.setup {
          on_attach = on_attach,
          capabilities = capabilities,
        }
      end
    end,
  },

  -- ASSINATURA (Independente)
  {
    'ray-x/lsp_signature.nvim',
    event = 'VeryLazy',
    opts = {
      bind = true,
      handler_opts = { border = 'rounded' },
    },
  },
}
