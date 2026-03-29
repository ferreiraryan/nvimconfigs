local M = {}

function M.freeze()
  local output = vim.fn.system 'pip freeze > requirements.txt'
  if vim.v.shell_error == 0 then
    print 'requirements.txt atualizado.'
  else
    print('Erro: ' .. output)
  end
end

function M.install(pkg)
  local output = vim.fn.system('pip install ' .. pkg)
  if vim.v.shell_error == 0 then
    print 'Pacote instalado.'
  else
    print('Erro: ' .. output)
  end
end

return M
