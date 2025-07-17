return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'williamboman/mason.nvim', -- Renomeado para o novo nome da organização
    'williamboman/mason-lspconfig.nvim',
    { 'j-hui/fidget.nvim', tag = "legacy", opts = {} }, -- Fidget para UI do LSP
    { 'folke/lazydev.nvim', ft = 'lua' },
  },
  config = function()
-- ESTA É A FORMA CORRETA
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Garante que a tabela 'general' exista antes de usá-la
capabilities.general = vim.tbl_deep_extend("force", capabilities.general or {}, {
  positionEncodings = { "utf-16" },
})
    local on_attach = function(client, bufnr)
      local map = function(keys, func, desc, mode)
        vim.keymap.set(mode or 'n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
      end
      map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
      map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'v' })
      -- etc.
    end

    local servers = {
      "ruff",
      "lua_ls",
      "jsonls",
      "html",
      "cssls",
      "marksman", 
      "tailwindcss",
    }

    require('mason').setup()
    require('mason-lspconfig').setup {
      ensure_installed = servers,
    }

    for _, server_name in ipairs(servers) do
      local opts = {
        on_attach = on_attach,
        capabilities = capabilities,
      }

      if server_name == "lua_ls" then
        opts.settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
          },
        }
      end

      require('lspconfig')[server_name].setup(opts)
    end
  end,
}
