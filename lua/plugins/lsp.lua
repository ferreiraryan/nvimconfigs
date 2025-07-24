return {
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Gerenciamento de LSPs e ferramentas
    'mason-org/mason.nvim',
    'mason-org/mason-lspconfig.nvim',

    -- Melhorias para Flutter (ESSENCIAL)
    {
      'akinsho/flutter-tools.nvim',
      dependencies = { 'nvim-lua/plenary.nvim' },
    },

    -- UI e Autocompletar
    { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
    'saghen/blink.cmp',
  },
  config = function()
    -- Lista de pacotes para o Mason instalar. Usamos os nomes exatos do Mason.
    local ensure_installed = {
      -- LSPs
      'dart-sdk',
      'lua-language-server',
      'pyright',
      'ruff-lsp',
      'css-lsp',
      'html-lsp',
      'json-lsp',
      'tailwindcss-language-server',
      'typescript-language-server', -- Nome do pacote para 'ts_ls'

      -- Ferramentas (Formatadores, etc)
      'stylua',
    }

    -- Setup do Mason
    require('mason').setup()

    -- Anexa os atalhos de teclado quando um LSP inicia
    local on_attach = function(client, bufnr)
      local map = function(keys, func, desc)
        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
      end

      -- Mapeamentos essenciais (usando Telescope)
      map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
      map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
      map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
      map('K', vim.lsp.buf.hover, 'Hover Documentation')
      map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
      map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
    end

    -- Capacidades para o autocompletar
    local capabilities = require('blink.cmp').get_lsp_capabilities()

    -- Configura o mason-lspconfig para usar a lista e os handlers
    require('mason-lspconfig').setup {
      ensure_installed = ensure_installed,
      handlers = {
        -- Handler padrão para servidores sem configuração especial
        function(server_name)
          require('lspconfig')[server_name].setup {
            on_attach = on_attach,
            capabilities = capabilities,
          }
        end,

        -- Handler customizado para Lua
        ['lua_ls'] = function()
          require('lspconfig').lua_ls.setup {
            on_attach = on_attach,
            capabilities = capabilities,
            settings = { Lua = { diagnostics = { globals = { 'vim' } } } },
          }
        end,

        -- Handler do Dart com integração do Flutter Tools
        ['dartls'] = function()
          require('lspconfig').dartls.setup {
            on_attach = function(client, bufnr)
              -- Ativa os atalhos LSP padrão
              on_attach(client, bufnr)

              -- Define atalhos específicos para Flutter APENAS em arquivos Dart
              local fmap = function(keys, func, desc)
                vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'Flutter: ' .. desc })
              end
              fmap('<leader>fr', require('flutter-tools').reload, '[R]eload')
              fmap('<leader>fR', require('flutter-tools').restart, '[R]estart')
              fmap('<leader>fq', require('flutter-tools').quit, '[Q]uit App')
              fmap('<leader>ft', require('flutter-tools').open_flutter_outline, 'Open Ou[t]line')
            end,
            capabilities = capabilities,
            settings = {
              dart = {
                -- Essas opções ativam features úteis do LSP para Flutter
                closingLabels = true,
                flutterOutline = true,
                outline = true,
              },
            },
          }

          -- Configura o plugin flutter-tools
          require('flutter-tools').setup {}
        end,
      },
    }
  end,
}
