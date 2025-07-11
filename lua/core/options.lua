-- lua/core/options.lua

vim.g.have_nerd_font = false -- Mude para true se tiver Nerd Font

-- Opções do editor (:help option-list)
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.showmode = false
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.inccommand = 'split'
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.confirm = true
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.o.spell = false
vim.o.spelllang = 'pt_br'

-- Sincronizar clipboard (pode aumentar um pouco o tempo de inicialização)
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Configurações de diagnóstico

-- Em lua/core/options.lua

-- Substitua seu bloco de diagnóstico por este:
vim.diagnostic.config({
  -- Grifado ondulado sob o erro/aviso
  underline = true,

  -- Ícone na lateral esquerda (gutter)
  signs = true,

  -- Não atualizar enquanto digita (melhora a performance)
  update_in_insert = false,

  -- O "comentário" ao lado da linha, agora forçado a aparecer
  virtual_text = {
    source = true, -- IMPORTANTE: Força a exibição do texto
    spacing = 4,   -- Espaço entre o código e o texto do erro
    prefix = '●',  -- Caractere antes da mensagem
  },
})
