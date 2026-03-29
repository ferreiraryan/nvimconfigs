local M = {}

function M.django_init()
  local current_dir = vim.fn.getcwd()
  local template_path = os.getenv 'HOME' .. '/.config/nvim/templates/django_pyproject.toml'

  local cmd = 'cp ' .. template_path .. ' ' .. current_dir .. '/pyproject.toml'
  if os.execute(cmd) then
    vim.notify('✅ Django iniciado', vim.log.levels.INFO)
    vim.cmd 'edit pyproject.toml'
  else
    vim.notify('❌ Falha', vim.log.levels.ERROR)
  end
end

function M.create_gitignore(template_path, name)
  local dest = vim.fn.getcwd() .. '/.gitignore'
  local content = vim.fn.readfile(template_path)

  if #content == 0 then
    vim.notify('Template vazio', vim.log.levels.ERROR)
    return
  end

  vim.fn.writefile(content, dest)
  vim.notify('✅ .gitignore criado: ' .. name)
end

return M
