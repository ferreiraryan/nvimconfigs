-- lua/core/autocmds.lua

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Grupo para evitar duplicação de autocomandos
local my_augroup = augroup('MyAutocommands', { clear = true })

-- Highlight ao copiar texto (yank)
autocmd('TextYankPost', {
  group = my_augroup,
  desc = 'Highlight ao copiar (yank)',
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Configurações específicas para Markdown
autocmd('FileType', {
  group = my_augroup,
  pattern = 'markdown',
  desc = 'Habilitar quebra de linha visual para Markdown',
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
    vim.opt_local.showbreak = '↪ '
  end,
})

-- Adicione em algum lugar da sua configuração do Neovim
vim.api.nvim_create_user_command('DjangoInit', function()
  -- Pega o diretório atual
  local current_dir = vim.fn.getcwd()
  -- Define o caminho do template
  local template_path = os.getenv 'HOME' .. '/.config/nvim/templates/django_pyproject.toml'
  -- Comando para copiar o template para o diretório atual
  local cmd = 'cp ' .. template_path .. ' ' .. current_dir .. '/pyproject.toml'

  -- Executa o comando e notifica o usuário
  local result = os.execute(cmd)
  if result then
    vim.notify('✅ Projeto Django iniciado com pyproject.toml', vim.log.levels.INFO)
    vim.cmd 'edit pyproject.toml' -- Abre o arquivo recém-criado
  else
    vim.notify('❌ Falha ao iniciar o projeto.', vim.log.levels.ERROR)
  end
end, {})

-- =============================================================
-- COMANDOS PARA GERAR O .gitignore A PARTIR DE TEMPLATES (VERSÃO CORRIGIDA)
-- =============================================================

local function create_gitignore_from_template(template_path, template_name)
  local dest_path = vim.fn.getcwd() .. '/.gitignore'

  if vim.fn.filereadable(template_path) == 0 then
    vim.notify('ERRO: O template "' .. template_path .. '" não pode ser lido.', vim.log.levels.ERROR)
    return
  end

  local content = vim.fn.readfile(template_path)
  if #content == 0 then
    vim.notify('ERRO: O template "' .. template_name .. '" está vazio.', vim.log.levels.ERROR)
    return
  end

  vim.notify('Lidas ' .. #content .. ' linhas de "' .. template_name .. '". Tentando escrever...', vim.log.levels.INFO)

  if vim.fn.filereadable(dest_path) == 1 then
    local choice = vim.fn.confirm('Um .gitignore já existe. Deseja sobrescrevê-lo?', '&Sim\n&Não', 2)
    if choice ~= 1 then
      vim.notify('Operação cancelada.', vim.log.levels.WARN)
      return
    end
  end

  local ok, err = pcall(vim.fn.writefile, content, dest_path)
  if ok then
    vim.notify('✅ .gitignore para "' .. template_name .. '" criado com sucesso!', vim.log.levels.INFO)
  else
    vim.notify('ERRO FATAL: Falha ao escrever o arquivo .gitignore: ' .. err, vim.log.levels.ERROR)
  end
end

-- Comando :GitignoreMenu (menu visual)
vim.api.nvim_create_user_command('GitignoreMenu', function()
  local template_dir = vim.fn.expand '~/.config/nvim/templates/gitignore/'
  local files = vim.fn.glob(template_dir .. '*.gitignore', true, true)
  if type(files) == 'string' then
    files = vim.split(files, '\n', { trimempty = true })
  end

  local templates = {}
  for _, file_path in ipairs(files) do
    table.insert(templates, {
      name = vim.fn.fnamemodify(file_path, ':t:r'),
      path = file_path,
    })
  end

  if #templates == 0 then
    vim.notify('Nenhum template encontrado em ' .. template_dir, vim.log.levels.WARN)
    return
  end

  table.sort(templates, function(a, b)
    return a.name < b.name
  end)

  local menu_lines = { 'Selecione um template .gitignore:', '' }
  local max_width = 3
  for _, t in ipairs(templates) do
    local line = '  ' .. t.name
    table.insert(menu_lines, line)
    max_width = math.max(max_width, #line)
  end

  local win_height = math.min(#menu_lines + 15, vim.o.lines - 4)
  local win_width = math.min(max_width + 30, vim.o.columns - 4)
  local row = math.floor((vim.o.lines - win_height) / 2)
  local col = math.floor((vim.o.columns - win_width) / 2)

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')

  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
  })

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, menu_lines)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  vim.api.nvim_win_set_option(win, 'cursorline', true)

  local function select_option_and_close()
    local line_num = vim.api.nvim_win_get_cursor(win)[1]
    local selected_index = line_num - 2
    if selected_index > 0 and selected_index <= #templates then
      local selection = templates[selected_index]
      vim.api.nvim_win_close(win, true)
      create_gitignore_from_template(selection.path, selection.name)
    end
  end

  vim.keymap.set('n', '<CR>', select_option_and_close, { buffer = buf, silent = true })
  vim.keymap.set('n', 'q', function()
    vim.api.nvim_win_close(win, true)
  end, { buffer = buf, silent = true })
  vim.keymap.set('n', '<Esc>', function()
    vim.api.nvim_win_close(win, true)
  end, { buffer = buf, silent = true })
end, {})

-- ==========================================
-- ======= salvar ao sair do insert =========
-- ==========================================

-- Alternativa para o seu autocmd de 'InsertLeave'
vim.api.nvim_create_autocmd('FocusLost', {
  group = my_augroup,
  desc = 'Salvar arquivos quando o Neovim perde o foco',
  pattern = '*',
  command = 'silent! wall', -- Salva todos os buffers modificados
})

-- ==========================================
-- ======= Criar Requiriments python ========
-- ==========================================

vim.api.nvim_create_user_command('FreezeRequirements', function()
  local output = vim.fn.system 'pip freeze > requirements.txt'
  if vim.v.shell_error == 0 then
    print 'requirements.txt atualizado com sucesso.'
  else
    print('Erro ao executar pip freeze: ' .. output)
  end
end, {})

-- ==========================================
-- =========== Baixar pacote pip ============
-- ==========================================

vim.api.nvim_create_user_command('Pip', function(packg)
  local output = vim.fn.system('pip install ' .. packg.args)
  if vim.v.shell_error == 0 then
    print 'Pacote instalado com sucesso.'
  else
    print('Erro ao executar pip : ' .. output)
  end
end, {
  nargs = 1,
})

-- ==========================================
-- ============== Comandos Git ==============
-- ==========================================

vim.api.nvim_create_user_command('GitAddAll', function()
  local output = vim.fn.system 'git add .'
  if vim.v.shell_error == 0 then
    print 'Arquivos Adicionados com sucesso!'
  else
    print('Erro ao Adicionar: ' .. output)
  end
end, {})

vim.api.nvim_create_user_command('GitCommit', function(opts)
  local args = opts.fargs
  local tipo = args[1]
  local escopo = ''
  local mensagem = ''

  if #args < 2 then
    print 'Uso: :GitCommit <tipo> [escopo] <mensagem>'
    return
  end

  -- Se o segundo argumento estiver entre parênteses, remove e usa como escopo
  if args[2]:match '^%(.+%)$' then
    escopo = args[2]
    mensagem = table.concat(args, ' ', 3)
  else
    -- Se o segundo argumento não parecer escopo, considera que mensagem começa aqui
    mensagem = table.concat(args, ' ', 2)
  end

  local commit_msg = tipo .. escopo .. ': ' .. mensagem

  -- Executa git add
  local add_output = vim.fn.system 'git add .'
  if vim.v.shell_error ~= 0 then
    print('Erro ao adicionar arquivos: ' .. add_output)
    return
  end

  -- Executa git commit
  local commit_output = vim.fn.system("git commit -m '" .. commit_msg .. "'")
  if vim.v.shell_error == 0 then
    print('Commit realizado: ' .. commit_msg)
  else
    print('Erro ao commitar: ' .. commit_output)
  end
end, {
  nargs = '+',
})

vim.api.nvim_create_user_command('GitPush', function()
  local output = vim.fn.system 'git push'
  if vim.v.shell_error == 0 then
    print '✅ git push realizado com sucesso!'
  else
    print('❌ Erro no git push:\n' .. output)
  end
end, {})

vim.api.nvim_create_user_command('GitPull', function()
  local output = vim.fn.system 'git pull'
  if vim.v.shell_error == 0 then
    print '✅ git pull realizado com sucesso!'
  else
    print('❌ Erro no git pull:\n' .. output)
  end
end, {})

-- Função para mostrar mensagens ao usuário
local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO, { title = 'Git Helper' })
end

-- A lógica principal do nosso comando
local function setup_repo(opts)
  local remote_url = opts.args
  if not remote_url or remote_url == '' then
    notify('❌ Erro: Forneça a URL SSH do repositório.', vim.log.levels.ERROR)
    return
  end

  -- Helper para rodar comandos no shell
  local function run_cmd(command)
    -- Usamos vim.fn.system para rodar e capturar a saída (se necessário)
    -- O '2>&1' redireciona o erro para a saída padrão, para podermos ver
    local output = vim.fn.system(command .. ' 2>&1')
    -- Checa se o comando falhou
    if vim.v.shell_error ~= 0 then
      notify('Falha ao executar: ' .. command .. '\n' .. output, vim.log.levels.ERROR)
      return false -- indica falha
    end
    return true -- indica sucesso
  end

  -- 1. Inicia o repo se necessário
  if vim.fn.isdirectory '.git' == 0 then
    notify '🔧 Inicializando um novo repositório Git...'
    if not run_cmd 'git init' then
      return
    end
  else
    notify '✅ Repositório Git já existe.'
  end

  -- 2. Cria README.md se não existir
  if vim.fn.filereadable 'README.md' == 0 then
    notify '📝 Criando arquivo README.md...'
    vim.fn.writefile({ '# workout_API' }, 'README.md')
  end

  -- 3. Adiciona e commita
  notify '📦 Adicionando arquivos...'
  if not run_cmd 'git add .' then
    return
  end

  notify '🚀 Realizando o commit inicial...'
  -- Apenas commita se houver algo para commitar, para evitar erro
  run_cmd 'git diff-index --quiet HEAD -- || git commit -m "Initial"'

  -- 4. Garante que a branch é 'main'
  notify "🌿 Renomeando a branch para 'main'..."
  if not run_cmd 'git branch -M main' then
    return
  end

  -- 5. Configura o remote
  -- Checa se o remote 'origin' já existe
  if vim.fn.system 'git remote get-url origin > /dev/null 2>&1' == '' then
    notify "🔗 Adicionando o remote 'origin'..."
    if not run_cmd('git remote add origin ' .. remote_url) then
      return
    end
  else
    notify "🔄 Atualizando a URL do remote 'origin'..."
    if not run_cmd('git remote set-url origin ' .. remote_url) then
      return
    end
  end

  -- 6. Faz o push inicial
  notify '📤 Enviando para o GitHub...'
  if not run_cmd 'git push -u origin main' then
    return
  end

  notify('✨ Processo concluído com sucesso!', vim.log.levels.INFO)
end

-- Cria o comando de usuário no Neovim
vim.api.nvim_create_user_command(
  'InitRepo', -- Nome do comando
  setup_repo, -- Função a ser chamada
  {
    nargs = 1, -- Espera exatamente 1 argumento
    complete = 'shellcmd', -- Ajuda a autocompletar, mas é opcional
    desc = 'Inicializa o repositório e envia para o GitHub. Uso: :InitRepo <url_ssh>',
  }
)

-- ==========================================
-- ======= Recarregar Lsp =========
-- ==========================================

vim.api.nvim_create_user_command('LspReload', function()
  for _, client in ipairs(vim.lsp.get_active_clients()) do
    vim.lsp.stop_client(client.id)
  end
  vim.cmd 'edit' -- força reload do buffer atual
  vim.cmd 'LspStart' -- reinicia todos os LSPs ativos
  print '🔁 LSP reiniciado.'
end, {})
