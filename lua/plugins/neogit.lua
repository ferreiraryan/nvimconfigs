-- Plugins
return {
  { 'nvim-lua/plenary.nvim' },

  { 'TimUntersberger/neogit',        dependencies = 'nvim-lua/plenary.nvim' },

  { 'nvim-telescope/telescope.nvim', dependencies = 'nvim-lua/plenary.nvim' },
  config = function()
    -- 2️⃣ Configuração do Neogit (fora do return)
    require('neogit').setup {
      disable_signs = false,
      disable_hint = false,
      disable_context_highlighting = false,
      disable_commit_confirmation = false,
      integrations = {
        telescope = true
      },
    }
  end

}
