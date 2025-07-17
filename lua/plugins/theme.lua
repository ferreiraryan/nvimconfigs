-- 'catppuccin' será o seu tema
return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000, -- Certifica de que ele carregue primeiro
  config = function()
    -- Carrega o tema
    vim.cmd.colorscheme 'catppuccin'
  end,
}

-- lua/plugins/theme.lua
-- return {
--   'folke/tokyonight.nvim',
--   priority = 1000,
--   config = function()
--     require('tokyonight').setup {
--       styles = {
--         comments = { italic = false },
--       },
--     }
--     vim.cmd.colorscheme 'tokyonight-night'
--
--     -- Você também pode colocar o Catppuccin aqui se quiser alternar
--     -- require('catppuccin').setup()
--   end,
-- }
