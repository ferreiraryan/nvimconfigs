return {
  "coffebar/neovim-project",
  load_session_on_startup = false,
  before_session_load = function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_config(win).relative ~= "" then
        vim.api.nvim_win_close(win, true)
      end
    end
  end,
  opts = {
    projects = { -- define project roots
      "~/Documents/projects/*/*/*",
    },
    picker = {
      type = "snacks", -- one of "telescope", "fzf-lua", or "snacks"
    }
  },
  on_project_selected = function()
    -- fecha TODAS floating windows (snacks)
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_config(win).relative ~= "" then
        vim.api.nvim_win_close(win, true)
      end
    end
  end,
  init = function()
    -- enable saving the state of plugins in the session
    vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
  end,
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    -- optional picker
    { "nvim-telescope/telescope.nvim", tag = "0.1.4" },
    -- optional picker
    { "ibhagwan/fzf-lua" },
    -- optional picker
    { "folke/snacks.nvim" },
    { "Shatur/neovim-session-manager" },
  },
  lazy = false,
  priority = 100,
}
