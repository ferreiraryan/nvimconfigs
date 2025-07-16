
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
    local on_attach = function(client, bufnr)
      local map = function(keys, func, desc, mode)
        vim.keymap.set(mode or 'n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
      end

      map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
      map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'v' })
      map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
      map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
      map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
      map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')
      map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
      map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
    end

    local capabilities = require('blink.cmp').get_lsp_capabilities()

    local mason_servers_to_manage = {
      'ts_ls',
      'dartls',
      'lua_ls',
      'pyright',
      'ruff',
      'jsonls',
      'html',
      'cssls',
    }

    local mason_tools_to_install = {
      'stylua',
    }

    require('mason').setup()
    require('mason-lspconfig').setup {
      ensure_installed = {},
      automatic_installation = true,
    }
    require('mason-tool-installer').setup { ensure_installed = mason_tools_to_install }

    local lspconfig_servers_to_configure = mason_servers_to_manage

    for _, server_name in ipairs(lspconfig_servers_to_configure) do
      local server_opts = {
        on_attach = on_attach,
        capabilities = capabilities,
      }
      if server_name == 'lua_ls' then
        server_opts.settings = {
          Lua = {
            completion = { callSnippet = 'Replace' },
            diagnostics = { globals = { 'vim' } },
          },
        }
      elseif server_name == 'pyright' then
        server_opts.settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "workspace"
            }
          }
        }
      end

      local lspconfig_setup_fn = require('lspconfig')[server_name]
      if lspconfig_setup_fn then
        lspconfig_setup_fn.setup(server_opts)
      else
        print("WARN: lspconfig does not have a setup function for " .. server_name)
      end
    end
  end,
}
