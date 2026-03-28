-- lua/plugins/theme.lua
return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  opts = {
    flavour = 'mocha', -- Mocha é o padrão dark do Hyde
    transparent_background = true, -- ESSENCIAL para ver o wallpaper do Hyde
    term_colors = true,
    integrations = {
      cmp = true,
      gitsigns = true,
      nvimtree = true,
      treesitter = true,
      notify = true,
      mini = true,
      snacks = true, -- Integração nativa com o Snacks!
      bufferline = true,
      harpoon = true,
    },
  },
  config = function(_, opts)
    require('catppuccin').setup(opts)
    vim.cmd.colorscheme 'catppuccin'
  end,
}
