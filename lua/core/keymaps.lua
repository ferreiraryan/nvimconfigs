-- ~/.config/nvim/lua/core/keymaps.lua

local map = vim.keymap.set

-- Função para justificar parágrafos em markdown ignorando títulos
local function format_markdown_ignore_headers()
  local start_line = nil
  local end_line = nil
  local total_lines = vim.fn.line '$'

  for lnum = 1, total_lines + 1 do
    local line = vim.fn.getline(lnum)
    local is_header = vim.startswith(line, '#')

    if line:match '^%s*$' or is_header or lnum == total_lines + 1 then
      if start_line and end_line and end_line >= start_line then
        vim.cmd(string.format('%d,%dgq', start_line, end_line))
      end
      start_line = nil
      end_line = nil
    else
      if not start_line then
        start_line = lnum
      end
      end_line = lnum
    end
  end
end

-- Atalhos Gerais
map('i', 'jk', '<Esc>', { noremap = true, silent = true, desc = 'Sair do modo de Inserção' })
map('n', '<C-r>', ':redo<CR>', { noremap = true, desc = 'Refazer (Redo)' })
map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Limpar highlight da busca' })
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Sair do modo terminal' })

-- Atalho para formatar com LSP (precisa do plugin conform.nvim ou similar)
-- map('n', '<leader>fd', vim.lsp.buf.format, { desc = 'Formatar arquivo' })
-- ADICIONE ESTA LINHA NOVA:
vim.keymap.set({ 'n', 'v' }, '<leader>fd', function()
  require('conform').format { async = true, lsp_fallback = true }
end, { desc = 'Formatar arquivo' })

-- Atalho de verificação ortográfica
map('n', '<f8>', function()
  vim.opt.spell = not vim.opt.spell:get()
  print('Spell check: ' .. (vim.opt.spell:get() and 'ON' or 'OFF'))
end, { desc = 'Alternar verificação ortográfica (F7)' })

-- Navegação entre janelas (splits)
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Mover para janela à esquerda' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Mover para janela à direita' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Mover para janela abaixo' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Mover para janela acima' })

-- Mover janela atual
map('n', '<leader>wv', '<C-w>H', { desc = 'Mover janela para vertical (esquerda)' })
map('n', '<leader>wh', '<C-w>K', { desc = 'Mover janela para horizontal (acima)' })

-- Diagnósticos
map('n', '<leader>d', vim.diagnostic.setloclist, { desc = 'Abrir lista de diagnósticos' })

-- Markdown
map('n', '<leader>fj', format_markdown_ignore_headers, { desc = 'Justificar parágrafos (Markdown)' })

-- Em lua/core/keymaps.lua
-- Exemplo de como configurar após a instalação com lazy.nvim
-- Geralmente dentro de um bloco on_attach ou no arquivo de configuração de atalhos

-- Mapeia 'gcc' para comentar a linha atual no modo Normal
vim.keymap.set('n', 'gcc', function()
  require('Comment.api').toggle.linewise.current()
end, { desc = 'Comentar/descomentar linha atual' })

-- Mapeia 'gc' para comentar a seleção no modo Visual
vim.keymap.set('v', 'gc', '<ESC><CMD>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>', { desc = 'Comentar/descomentar seleção' })

vim.keymap.set('v', '<leader>r', function()
  require('refactoring').select_refactor {
    -- Esta linha é a chave!
    lsp_actions = true,
  }
end)

-- ~/.config/nvim/lua/core/keymaps.lua

local map = vim.keymap.set

-- Modo Normal
map('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle File Explorer' }) -- Assumindo que você usa nvim-tree
map('n', '<leader>w', ':w<CR>', { desc = 'Save File' })
map('n', '<leader>q', ':q<CR>', { desc = 'Quit' })

-- Modo Visual
map('v', '<', '<gv', { desc = 'Indent Left' })
map('v', '>', '>gv', { desc = 'Indent Right' })
