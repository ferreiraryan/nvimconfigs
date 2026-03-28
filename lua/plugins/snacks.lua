-- lua/plugins/snacks.lua
return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    scroll = {
      enabled = true,
      animate = {
        duration = { step = 15, total = 250 },
        easing = 'linear',
      },
      -- Desativa o scroll suave se o arquivo for gigante (performance)
      max_file_size = 1024 * 1024, -- 1MB
    },
    image = {
      enabled = true,
      doc = {
        -- Isso faz as imagens aparecerem dentro do Markdown automaticamente
        inline = true,
        render = true,
        max_width = 80,
        max_height = 40,
      },
    },
    bigfile = { enabled = true },
    dashboard = {
      enabled = true,
      sections = {
        { section = 'header' }, -- Aqui você pode colocar uma ASCII Art foda
        { section = 'keys',   gap = 1, padding = 1 },
        { section = 'startup' },
      },
    },
    styles = {
      notification = {
        wo = { winblend = 10 }, -- Leve transparência nas notificações
      },
    },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = {
      enabled = true,
      filter = function(notif)
        -- Ignora se a mensagem contiver o erro específico do didChange
        if notif.msg:find("textDocument/didChange") then
          return false
        end
        return true
      end,
    },
    quickfile = { enabled = true },
    words = { enabled = true },
    -- Se quiser manter o Telescope por enquanto, deixe o picker desativado
    picker = { enabled = true },
  },
  keys = {
    {
      '<leader><space>',
      function()
        Snacks.picker.smart()
      end,
      desc = 'Smart Find Files',
    },
    {
      '<leader>ff',
      function()
        Snacks.picker.files()
      end,
      desc = 'Find Files',
    },
    {
      '<leader>fg',
      function()
        Snacks.picker.grep()
      end,
      desc = 'Grep',
    },
    {
      '<leader>fb',
      function()
        Snacks.picker.buffers()
      end,
      desc = 'Buffers',
    },
    {
      '<leader>fh',
      function()
        Snacks.picker.help()
      end,
      desc = 'Help Tags',
    },
    {
      '<leader>lg',
      function()
        Snacks.lazygit()
      end,
      desc = 'LazyGit',
    },
    {
      '<leader>gb',
      function()
        Snacks.gitbrowse()
      end,
      desc = 'Git Browse',
    },
    -- Terminal flutuante rápido (pode coexistir com o toggleterm)
    {
      '<leader>fT',
      function()
        Snacks.terminal()
      end,
      desc = 'Terminal',
    },
  },
}
