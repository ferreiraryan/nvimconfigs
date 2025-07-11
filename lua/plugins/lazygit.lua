-- lua/plugins/lazygit.lua
return {
  -- Integração do lazygit com o toggleterm
  {
    'akinsho/toggleterm.nvim',
    -- Sobrescrevemos a configuração do toggleterm para adicionar o lazygit
    opts = {
      --... (suas outras opções do toggleterm podem ir aqui)
      direction = 'float',
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
  },
}