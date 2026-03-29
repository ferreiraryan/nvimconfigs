return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons', -- Troque por 'nvim-mini/mini.icons' se for o seu padrão
  },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    -- Previne que o Neovim trave ou perca performance em arquivos muito grandes
    max_file_size = 1.5, -- Limite em MB
    anti_conceal = {
      -- Desativa a renderização visual exatamente na linha que tem o foco do cursor.
      enabled = true,
    },

    heading = {
      -- Desativa o sinal na gutter para manter a tela limpa
      sign = false,
      position = 'inline',
      -- Ícones distintos para cada nível de cabeçalho
      icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
      -- Adiciona um background sutil nos cabeçalhos (depende do seu colorscheme suportar)
      backgrounds = {
        'RenderMarkdownH1Bg',
        'RenderMarkdownH2Bg',
        'RenderMarkdownH3Bg',
        'RenderMarkdownH4Bg',
        'RenderMarkdownH5Bg',
        'RenderMarkdownH6Bg',
      },
    },

    code = {
      -- Formata blocos de código como caixas delimitadas, melhorando a leitura
      sign = false,
      width = 'block',
      right_pad = 1,
      disable_background = false,
    },

    checkbox = {
      -- Substitui os [ ] e [x] padrão por ícones mais modernos
      unchecked = { icon = '󰄱 ' },
      checked = { icon = '󰱒 ' },
      -- Permite estados customizados (ex: [-] para em progresso)
      custom = {
        todo = { raw = '[-]', rendered = '󰥔 ', highlight = 'RenderMarkdownWarn' },
      },
    },

    bullet = {
      -- Rotaciona os ícones de listas aninhadas para facilitar a identificação da indentação
      icons = { '●', '○', '◆', '◇' },
      right_pad = 1,
    },

    callout = {
      -- Formata blockquotes do GitHub/Obsidian como callouts visuais
      note = { raw = '[!NOTE]', rendered = '󰋽 Note', highlight = 'RenderMarkdownInfo' },
      tip = { raw = '[!TIP]', rendered = '󰌶 Tip', highlight = 'RenderMarkdownSuccess' },
      important = { raw = '[!IMPORTANT]', rendered = '󰅾 Important', highlight = 'RenderMarkdownHint' },
      warning = { raw = '[!WARNING]', rendered = '󰀪 Warning', highlight = 'RenderMarkdownWarn' },
      caution = { raw = '[!CAUTION]', rendered = '󰳦 Caution', highlight = 'RenderMarkdownError' },
    },
  },

}
