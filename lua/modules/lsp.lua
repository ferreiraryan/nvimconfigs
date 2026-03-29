local M = {}

function M.reload()
  for _, client in ipairs(vim.lsp.get_active_clients()) do
    vim.lsp.stop_client(client.id)
  end

  vim.cmd 'edit'
  vim.cmd 'LspStart'

  print '🔁 LSP reiniciado'
end

return M
