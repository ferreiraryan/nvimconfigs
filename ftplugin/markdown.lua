vim.opt_local.wrap = true      -- Quebra a linha visualmente no limite da janela
vim.opt_local.linebreak = true -- Garante que a quebra ocorra entre as palavras, sem cortar uma palavra no meio
-- Força o Neovim a ocultar a sintaxe bruta (ex: esconde os ** do negrito)
vim.opt_local.conceallevel = 2

-- Define quando a formatação real deve aparecer.
-- 'c' = mostra o texto puro apenas quando você está editando a linha no modo de Inserção ou Comando.
vim.opt_local.concealcursor = 'c'


vim.keymap.set('n', '<leader>x', function()
  -- Exibe as opções no command-line
  vim.api.nvim_echo({ { "Estado do Checkbox: 1=[ ] | 2=[-] | 3=[x] > ", "Question" } }, false, {})

  -- Captura exatamente um caractere de input
  local char = vim.fn.getcharstr()

  -- Limpa a mensagem do command-line
  vim.cmd('redraw')

  -- Mapeamento das opções
  local states = {
    ['1'] = '[ ]',
    ['2'] = '[-]',
    ['3'] = '[x]',
  }

  local new_state = states[char]

  -- Sai silenciosamente se pressionar ESC ou tecla não mapeada
  if not new_state then return end

  local line = vim.api.nvim_get_current_line()

  -- Tenta encontrar e substituir um checkbox existente: [ ], [-] ou [x]
  local new_line, count = line:gsub('%[[%s%-x]%]', new_state, 1)

  -- Se a linha não tinha um checkbox, injeta um inteligentemente
  if count == 0 then
    if line:match('^%s*%- ') then
      -- Linha já é uma lista ("- item"), apenas insere o checkbox
      new_line = line:gsub('^(%s*%- )', '%1' .. new_state .. ' ')
    else
      -- Linha é texto puro, converte para lista com checkbox preservando indentação
      new_line = line:gsub('^(%s*)', '%1- ' .. new_state .. ' ')
    end
  end

  vim.api.nvim_set_current_line(new_line)
end, { buffer = true, desc = 'Select Markdown Checkbox State' })
