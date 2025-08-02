-- lua/plugins/lsp.lua (ou onde este arquivo estiver)

return {
  -- 1. GERENCIADOR DE PACOTES: Mason
  -- Instala e gerencia LSPs, Formatadores e Linters.
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

  -- 2. CONFIGURAÇÃO DO LSP: O cérebro da operação
  -- Conecta Mason, lspconfig, e outras ferramentas.
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
      { 'akinsho/flutter-tools.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
    },
    config = function()
      -- Lista de servidores de linguagem (LSPs) que o Mason deve instalar.
      local lsp_servers = {
        'ruff',
        'lua_ls',
        'pyright', -- Essencial para Python/Django
        'cssls',
        'html',
        'jsonls',
        'tailwindcss',
        'tsserver',
        'dartls',
      }

      -- Função executada quando um LSP se anexa a um buffer.
      -- Define todos os atalhos de teclado do LSP.
      local on_attach = function(client, bufnr)
        -- Ativa o lsp_signature se ele estiver disponível
        if pcall(require, 'lsp_signature') then
          require('lsp_signature').on_attach({
            bind = true,
            handler_opts = { border = 'rounded' },
          }, bufnr)
        end

        local map = function(mode, keys, func, desc)
          vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
        end

        -- Mapeamentos essenciais para navegação e ações
        map('n', 'K', vim.lsp.buf.hover, 'Mostrar Documentação')
        map('n', 'gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('n', 'gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('n', 'gi', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('n', '<leader>rn', vim.lsp.buf.rename, '[R]e[n]omear')
        map({ 'n', 'v' }, '<leader>la', vim.lsp.buf.code_action, '[L]SP [A]ction')
      end

      -- Capacidades que o cliente (Neovim) oferece ao servidor (LSP)
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Configuração principal que conecta Mason ao lspconfig
      require('mason-lspconfig').setup {
        ensure_installed = lsp_servers,
        handlers = {
          -- Handler padrão para a maioria dos LSPs que não precisam de config especial
          function(server_name)
            require('lspconfig')[server_name].setup {
              on_attach = on_attach,
              capabilities = capabilities,
            }
          end,

          ----------------------------------------------------------------------
          -- *** A CORREÇÃO DEFINITIVA ESTÁ AQUI ***
          ----------------------------------------------------------------------

          ['pyright'] = function()
            require('lspconfig').pyright.setup {
              on_attach = on_attach,
              capabilities = capabilities,
              -- NENHUMA TABELA `settings` AQUI. DEIXE-O LER O ARQUIVO.
            }
          end,

          -- Handler especial para Dart, integrando com Flutter Tools
          ['dartls'] = function()
            require('flutter-tools').setup {} -- Configura as ferramentas do Flutter
            require('lspconfig').dartls.setup {
              on_attach = function(client, bufnr)
                on_attach(client, bufnr) -- Aplica os atalhos globais primeiro

                -- Adiciona atalhos específicos para Flutter
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
        },
      }
    end,
  },

  -- 3. AJUDA DE ASSINATURA: Mostra parâmetros de funções
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
  -- O seu plugin de Treesitter e outros devem vir aqui...
}
