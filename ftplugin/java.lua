-- Sobe o JDTLS somente quando você abrir um arquivo .java

local ok, jdtls = pcall(require, 'jdtls')
if not ok then
  return
end

-- workspace dedicado por projeto
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.fn.stdpath 'data' .. '/jdtls-workspaces/' .. project_name

-- raiz do projeto
local root_markers = { 'gradlew', 'mvnw', '.git' }
local root_dir = require('jdtls.setup').find_root(root_markers)
if root_dir == nil then
  return
end

-- capabilities (se usa nvim-cmp)
local ok_cmp, cmp = pcall(require, 'cmp_nvim_lsp')
local capabilities = ok_cmp and cmp.default_capabilities() or nil

-- keymaps básicos
local on_attach = function(_, bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = 'LSP: ' .. (desc or '') })
  end
  map('n', 'K', vim.lsp.buf.hover, 'Hover')
  map('n', 'gd', require('telescope.builtin').lsp_definitions, 'Goto Definition')
  map('n', 'gr', require('telescope.builtin').lsp_references, 'Goto References')
  map('n', 'gi', require('telescope.builtin').lsp_implementations, 'Goto Implementation')
  map('n', '<leader>rn', vim.lsp.buf.rename, 'Rename')
  map({ 'n', 'v' }, '<leader>la', vim.lsp.buf.code_action, 'Code Action')
end

local config = {
  cmd = { 'jdtls', '-data', workspace_dir },
  root_dir = root_dir,
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    java = {
      signatureHelp = { enabled = true },
      contentProvider = { preferred = 'fernflower' },
      configuration = { updateBuildConfiguration = 'interactive' },
    },
  },
}

jdtls.start_or_attach(config)
