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
vim.api.nvim_create_user_command('ProjectInitPython', function()
  -- Pega o diretório atual
  local current_dir = vim.fn.getcwd()
  -- Define o caminho do template
  local template_path = os.getenv 'HOME' .. '/.config/nvim/templates/python_pyproject.toml'
  -- Comando para copiar o template para o diretório atual
  local cmd = 'cp ' .. template_path .. ' ' .. current_dir .. '/pyproject.toml'

  -- Executa o comando e notifica o usuário
  local result = os.execute(cmd)
  if result then
    vim.notify('✅ Projeto Python iniciado com pyproject.toml', vim.log.levels.INFO)
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
  local template_dir = vim.fn.expand('~/.config/nvim/templates/gitignore/')
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

  table.sort(templates, function(a, b) return a.name < b.name end)

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
  vim.keymap.set('n', 'q', function() vim.api.nvim_win_close(win, true) end, { buffer = buf, silent = true })
  vim.keymap.set('n', '<Esc>', function() vim.api.nvim_win_close(win, true) end, { buffer = buf, silent = true })
end, {})
