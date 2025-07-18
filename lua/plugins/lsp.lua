-- lua/plugins/lsp.lua
return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
    { 'folke/lazydev.nvim', ft = 'lua' },
  },
  config = function()
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    local on_attach = function(client, bufnr)
      local map = function(keys, func, desc, mode)
        vim.keymap.set(mode or 'n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
      end
      map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
      map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
      map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction')
      map('K', vim.lsp.buf.hover, 'Hover Documentation')
    end

    local function has_tool_config(root_dir, tool_name)
      local toml_path = root_dir .. '/pyproject.toml'
      if vim.fn.filereadable(toml_path) == 0 then return false end
      local file = io.open(toml_path, 'r')
      if not file then return false end
      local content = file:read '*a'
      file:close()
      return content:match('%[tool.' .. tool_name .. '%]')
    end

    require('mason').setup()

    local servers = { 'ruff', 'pyright', 'lua_ls', 'jsonls', 'html', 'cssls', 'marksman', 'tailwindcss' }

    require('mason-lspconfig').setup {
      ensure_installed = servers,
      handlers = {
        function(server_name) -- Handler Padrão
          require('lspconfig')[server_name].setup { on_attach = on_attach, capabilities = capabilities }
        end,
        ['lua_ls'] = function()
          require('lspconfig').lua_ls.setup {
            on_attach = on_attach,
            capabilities = capabilities,
            settings = { Lua = { diagnostics = { globals = { 'vim' } } } },
          }
        end,
        ['pyright'] = function() -- Handler do Pyright
          require('lspconfig').pyright.setup {
            on_attach = on_attach,
            capabilities = capabilities,
            root_dir = function(fname)
              local root = require('lspconfig.util').root_pattern('pyproject.toml', '.git')(fname)
              if root and has_tool_config(root, 'pyright') then return root end
            end,
          }
        end,
        ['ruff'] = function() -- Handler do Ruff
          require('lspconfig').ruff.setup {
            capabilities = capabilities,
            root_dir = function(fname)
              local root = require('lspconfig.util').root_pattern('pyproject.toml', '.git')(fname)
              if root and has_tool_config(root, 'ruff') then return root end
            end,
            on_attach = function(client, bufnr)
              -- Desativa os diagnósticos do Ruff no editor
              vim.diagnostic.disable(bufnr, vim.lsp.get_namespace(client.id))
              -- Permite que a formatação continue funcionando
              if client.supports_method 'textDocument/formatting' then
                vim.keymap.set('n', '<leader>fr', function()
                  vim.lsp.buf.format { async = true, bufnr = bufnr }
                end, { buffer = bufnr, desc = 'Formatar com Ruff' })
              end
            end,
          }
        end,
      },
    }
  end,
}
