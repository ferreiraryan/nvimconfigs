-- lua/core/options.lua
-- Configurações centrais do editor Neovim

-- [[ Flags e Variáveis Globais ]]
vim.g.have_nerd_font = true -- Mude para false se não tiver Nerd Fonts instaladas

-- [[ Aparência e UI ]]
vim.opt.number = true -- Mostrar número das linhas
vim.opt.relativenumber = true -- Mostrar linhas relativas à posição do cursor
vim.opt.termguicolors = true -- NOVO: Essencial para temas de cores modernos funcionarem corretamente
vim.opt.signcolumn = 'yes:1' -- NOVO: Coluna de sinais (LSP) com largura fixa para não "pular"
vim.opt.cursorline = true -- Destaca a linha atual do cursor
vim.opt.splitright = true -- Abrir splits verticais à direita
vim.opt.splitbelow = true -- Abrir splits horizontais abaixo
vim.opt.showmode = false -- Desabilitado, pois plugins de statusline (lualine) já fazem isso
vim.opt.list = true -- Mostrar caracteres invisíveis
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' } -- Aparência dos caracteres invisíveis
vim.opt.scrolloff = 8 -- Manter 8 linhas de contexto ao rolar

-- [[ Comportamento do Editor ]]
vim.opt.mouse = 'a' -- Habilitar o uso do mouse em todos os modos
vim.opt.completeopt = 'menuone,noselect' -- NOVO: Melhora a experiência do menu de autocompleção
vim.opt.confirm = true -- Pedir confirmação ao sair com arquivos não salvos
vim.opt.breakindent = true -- Manter a indentação em linhas quebradas
vim.opt.inccommand = 'split' -- Mostrar preview de substituições em um split
vim.o.spell = false -- Desabilitar corretor ortográfico por padrão
vim.o.spelllang = 'pt_br'

-- [[ Indentação ]]
vim.opt.expandtab = true -- Usar espaços em vez de tabs
vim.opt.tabstop = 2 -- Sua preferência: largura do tab = 2 espaços
vim.opt.shiftwidth = 2 -- Sua preferência: tamanho da indentação = 2 espaços
vim.opt.softtabstop = 2 -- Comportamento do backspace na indentação
vim.opt.autoindent = true -- NOVO: Indentar novas linhas automaticamente
vim.opt.smartindent = true -- NOVO: Indentação inteligente para certas linguagens

-- [[ Busca (Search) ]]
vim.opt.ignorecase = true -- Ignorar maiúsculas/minúsculas na busca
vim.opt.smartcase = true -- A menos que a busca contenha uma letra maiúscula

-- [[ Performance e Arquivos ]]
vim.opt.hidden = true -- NOVO: Permite trocar de buffer sem salvar
vim.opt.undofile = true -- Habilitar histórico de "desfazer" persistente
vim.opt.swapfile = false -- NOVO: Desabilitar arquivo de swap (undofile é melhor)
vim.opt.backup = false -- NOVO: Desabilitar arquivo de backup
vim.opt.updatetime = 250 -- Tempo para plugins reagirem a eventos (ex: git signs)
vim.opt.timeoutlen = 1000 -- Tempo de espera para mapeamentos de teclas

-- [[ Clipboard ]]
-- Sincroniza com o clipboard do sistema (Ctrl+C/Ctrl+V)
-- Agendado para não atrasar a inicialização
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- [[ Diagnósticos do LSP ]]
-- Configura como os erros e avisos do LSP são exibidos
vim.opt.foldenable = false
vim.diagnostic.config {
  underline = true,
  signs = true,
  update_in_insert = false, -- Não atualizar enquanto digita (melhora a performance)
  virtual_text = { -- "Comentário" flutuante com a mensagem de erro
    spacing = 4,
    prefix = '●', -- Caractere antes da mensagem
  },
  severity_sort = true, -- Mostrar erros mais graves primeiro
}
