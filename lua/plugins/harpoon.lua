return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2', -- Recomendo a versão 2, é mais estável
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require 'harpoon'
    harpoon:setup()
    -- No setup do Harpoon
    vim.api.nvim_create_autocmd('VimEnter', {
      callback = function()
        local items = harpoon:list().items
        for _, item in ipairs(items) do
          -- Adiciona o arquivo ao buffer list sem trocar de janela
          vim.fn.execute('badd ' .. item.value)
        end
        -- Opcional: Abre o primeiro arquivo da lista automaticamente
        if #items > 0 then
          harpoon:list():select(1)
        end
      end,
    })
    vim.api.nvim_create_autocmd('BufWritePost', {
      pattern = 'harpoon',
      callback = function()
        vim.cmd 'redrawtabline'
      end,
    })
    vim.api.nvim_create_autocmd('BufLeave', {
      pattern = 'harpoon', -- Nome do buffer do menu
      callback = function()
        vim.cmd 'redrawtabline'
      end,
    })

    -- Coloque seus atalhos aqui dentro
    vim.keymap.set('n', '<leader>a', function()
      harpoon:list():add()
    end)
    vim.keymap.set('n', '<C-e>', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end)
  end,
}
