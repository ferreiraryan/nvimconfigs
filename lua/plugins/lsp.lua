-- lua/plugins/lsp.lua
return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'mason-org/mason.nvim',
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
    'saghen/blink.cmp',
    'folke/lazydev.nvim',
  },
  config = function()
    -- Função de atalho para mapeamentos do LSP
    local on_attach = function(client, bufnr)
      local map = function(keys, func, desc, mode)
        vim.keymap.set(mode or 'n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
      end

      -- Mapeamentos comuns do LSP
      map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
      map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'v' })
      map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
      map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
      map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
      map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')
      map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
      map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

      -- ... (o resto da sua configuração on_attach)
    end

    -- Capacidades do cliente LSP, aprimoradas pelo blink.cmp
    local capabilities = require('blink.cmp').get_lsp_capabilities()

    -- Servidores LSP a serem instalados
    local servers = {
      'ts_ls',
      'ast_grep',
      'dartls',
      'lua_ls',

      -- adicione outros aqui, ex: 'pyright', 'gopls'
    }

    -- Ferramentas adicionais a serem instaladas pelo Mason
    local tools = {
      'stylua',
    }

    -- Configuração do Mason
    require('mason').setup()
    require('mason-lspconfig').setup {
      ensure_installed = servers,
      automatic_installation = true,
    }
    require('mason-tool-installer').setup { ensure_installed = tools }

    -- Configuração dos servidores LSP
    for _, server_name in ipairs(servers) do
      local server_opts = {
        on_attach = on_attach,
        capabilities = capabilities,
      }
      -- Configurações específicas por servidor
      if server_name == 'lua_ls' then
        server_opts.settings = {
          Lua = {
            completion = { callSnippet = 'Replace' },
            diagnostics = { globals = { 'vim' } },
          },
        }
      end
      require('lspconfig')[server_name].setup(server_opts)
    end
  end,
}
