return {
  'NvChad/nvim-colorizer.lua',
  config = function()
    require('colorizer').setup {
      filetypes = { '*' },
      user_default_options = {
        names = false,
        RGB = true,
        RRGGBB = true,
        AARRGGBB = true,
        css = true,
        css_fn = true,
        tailwind = true, -- 🔥 mostra as cores das classes tailwind (bg-red-500)
      },
    }
  end,
}
