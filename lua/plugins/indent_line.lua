-- lua/plugins/indent.lua

return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  opts = {
    -- As opções agora são aninhadas
    indent = {
      char = '│', -- Caractere da linha
    },
    scope = {
      -- Esta é a nova forma de desabilitar a linha no primeiro nível
      show_start = false,
    },
  },
}