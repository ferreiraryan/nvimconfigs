local M = {}

local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO, { title = 'Git' })
end

local function run_cmd(command)
  local output = vim.fn.system(command .. ' 2>&1')
  if vim.v.shell_error ~= 0 then
    notify('❌ Erro:\n' .. output, vim.log.levels.ERROR)
    return false
  end
  return true
end

-- =========================
-- INIT REPO
-- =========================
function M.setup_repo(remote_url)
  if not remote_url or remote_url == '' then
    notify('Forneça a URL do repositório', vim.log.levels.ERROR)
    return
  end

  if vim.fn.isdirectory('.git') == 0 then
    notify('🔧 Inicializando repo...')
    if not run_cmd('git init') then return end
  else
    notify('Repo já existe')
  end

  if vim.fn.filereadable('README.md') == 0 then
    vim.fn.writefile({ '# Projeto' }, 'README.md')
  end

  run_cmd('git add .')
  run_cmd('git diff-index --quiet HEAD -- || git commit -m "Initial"')
  run_cmd('git branch -M main')

  if vim.fn.system('git remote get-url origin') == '' then
    run_cmd('git remote add origin ' .. remote_url)
  else
    run_cmd('git remote set-url origin ' .. remote_url)
  end

  run_cmd('git push -u origin main')

  notify('🚀 Repo pronto!')
end

-- =========================
-- GIT ADD ALL
-- =========================
function M.add_all()
  if run_cmd('git add .') then
    notify('Arquivos adicionados')
  end
end

-- =========================
-- GIT COMMIT (seu padrão)
-- =========================
function M.commit(args)
  if #args < 2 then
    notify('Uso: :GitCommit <tipo> [escopo] <mensagem>', vim.log.levels.WARN)
    return
  end

  local tipo = args[1]
  local escopo = ''
  local mensagem = ''

  if args[2]:match '^%(.+%)$' then
    escopo = args[2]
    mensagem = table.concat(args, ' ', 3)
  else
    mensagem = table.concat(args, ' ', 2)
  end

  local commit_msg = tipo .. escopo .. ': ' .. mensagem

  if not run_cmd('git add .') then return end

  if run_cmd("git commit -m '" .. commit_msg .. "'") then
    notify('Commit: ' .. commit_msg)
  end
end

-- =========================
-- GIT PUSH
-- =========================
function M.push()
  if run_cmd('git push') then
    notify('✅ Push realizado')
  end
end

-- =========================
-- GIT PULL
-- =========================
function M.pull()
  if run_cmd('git pull') then
    notify('✅ Pull realizado')
  end
end

return M
