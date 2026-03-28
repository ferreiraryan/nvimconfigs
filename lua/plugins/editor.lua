-- lua/plugins/editor.lua
return {
  'akinsho/bufferline.nvim',
  dependencies = 'nvim-tree/nvim-web-devicons',
  opts = {
    options = {
      mode = 'buffers',
      -- ESTA É A MÁGICA:
      custom_filter = function(buf_number)
        local harpoon = require 'harpoon'
        local marks = harpoon:list().items
        local buf_name = vim.api.nvim_buf_get_name(buf_number)

        -- Se o buffer não tiver nome (ex: terminal ou dashboard), não mostra
        if buf_name == '' then
          return false
        end

        -- Percorre a lista do Harpoon e compara com o nome do buffer atual
        for _, item in ipairs(marks) do
          -- item.value geralmente é o caminho relativo do arquivo
          -- Usamos find para bater o nome do arquivo com a marca
          if buf_name:find(item.value, 1, true) then
            return true
          end
        end

        -- Se não achou na lista do Harpoon, esconde a aba
        return false
      end,

      -- Mantém a ordenação que configuramos antes
      sort_by = function(buffer_a, buffer_b)
        local harpoon = require 'harpoon'
        local items = harpoon:list().items
        local function get_index(buf)
          local name = vim.api.nvim_buf_get_name(buf.id)
          for i, item in ipairs(items) do
            if name:find(item.value, 1, true) then
              return i
            end
          end
          return 999
        end
        return get_index(buffer_a) < get_index(buffer_b)
      end,
    },
  },
}
