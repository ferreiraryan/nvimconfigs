--- lua/plugins/toggleterm.lua
return {
  'akinsho/toggleterm.nvim',
  version = '*',
  opts = {
    open_mapping = [[<C-/>]],
    direction = 'float',
    float_opts = {
      border = 'curved',
    },
    start_in_insert = true,
    insert_mappings = true,
    terminal_mappings = true,
  },
  config = function(_, opts)
    require('toggleterm').setup(opts)

    -- Função para abrir o lazygit
    function _G.Lazygit_toggle()
      local Terminal = require('toggleterm.terminal').Terminal
      local lazygit = Terminal:new({ cmd = 'lazygit', hidden = true })
      lazygit:toggle()
    end

    -- Atalho para o lazygit
    vim.keymap.set('n', '<leader>rg', '<cmd>lua Lazygit_toggle()<CR>', { desc = 'Abrir lazygit' })
  end,
}
