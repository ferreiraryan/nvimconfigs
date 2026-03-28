-- ftplugin/java.lua (versão robusta)
local ok_jdtls, jdtls = pcall(require, 'jdtls')
if not ok_jdtls then
  return
end

local root_markers = { 'gradlew', 'mvnw', '.git' }
local root_dir = require('jdtls.setup').find_root(root_markers)
if not root_dir then
  -- fora de projeto: não tenta subir jdtls
  return
end

-- bundles via Mason (sem get_install_path)
local mason = vim.fn.stdpath 'data' .. '/mason'
local bundles = {}
local dbg_jar = vim.fn.glob(mason .. '/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar', 1)
if dbg_jar ~= '' then
  table.insert(bundles, dbg_jar)
end
local test_jars = vim.fn.glob(mason .. '/packages/java-test/extension/server/*.jar', 1)
if test_jars ~= '' then
  for _, j in ipairs(vim.split(test_jars, '\n', { trimempty = true })) do
    table.insert(bundles, j)
  end
end

local config = {
  cmd = { 'jdtls' }, -- instalado via Mason
  root_dir = root_dir,
  init_options = { bundles = bundles },
  settings = {
    java = {
      signatureHelp = { enabled = true },
      contentProvider = { preferred = 'fernflower' },
    },
  },
}

-- inicia/anexa
jdtls.start_or_attach(config)

-- Só configure DAP quando o cliente JDTLS estiver pronto
vim.defer_fn(function()
  local has_client = false
  for _, c in ipairs(vim.lsp.get_active_clients { bufnr = 0 }) do
    if c.name == 'jdtls' then
      has_client = true
      break
    end
  end
  if has_client then
    jdtls.setup_dap { hotcodereplace = 'auto' }
    require('jdtls.dap').setup_dap_main_class_configs()
  else
    vim.notify('JDTLS não anexou; verifique se abriu o projeto na raiz.', vim.log.levels.WARN)
  end
end, 100) -- pequeno delay ajuda
