local godot = require("modules.godot")

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local group = augroup("CoreAutocmds", { clear = true })



local git = require("modules.git")

vim.api.nvim_create_user_command("InitRepo", function(opts)
  git.setup_repo(opts.args)
end, { nargs = 1 })

vim.api.nvim_create_user_command("GitAddAll", function()
  git.add_all()
end, {})

vim.api.nvim_create_user_command("GitCommit", function(opts)
  git.commit(opts.fargs)
end, { nargs = '+' })

vim.api.nvim_create_user_command("GitPush", function()
  git.push()
end, {})

vim.api.nvim_create_user_command("GitPull", function()
  git.pull()
end, {})


-- PYTHON
vim.api.nvim_create_user_command("FreezeRequirements", function()
  require("modules.python").freeze()
end, {})

vim.api.nvim_create_user_command("Pip", function(opts)
  require("modules.python").install(opts.args)
end, { nargs = 1 })

-- DJANGO
vim.api.nvim_create_user_command("DjangoInit", function()
  require("modules.templates").django_init()
end, {})

-- LSP
vim.api.nvim_create_user_command("LspReload", function()
  require("modules.lsp").reload()
end, {})

-- GIT (mantém o que você já tinha)
vim.api.nvim_create_user_command("InitRepo", function(opts)
  require("modules.git").setup_repo(opts.args)
end, { nargs = 1 })


-- ========================
-- SESSION FIX
-- ========================
autocmd("User", {
  pattern = "SessionLoadPre",
  group = group,
  callback = function()
    -- fecha janelas flutuantes
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local config = vim.api.nvim_win_get_config(win)
      if config.relative ~= "" then
        vim.api.nvim_win_close(win, true)
      end
    end

    -- fecha neotree
    pcall(vim.cmd, "Neotree close")
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "SessionLoadPost",
  callback = function()
    local cwd = vim.fn.getcwd()
    vim.cmd("cd " .. cwd)
  end,
})

-- ========================
-- YANK HIGHLIGHT
-- ========================
autocmd("TextYankPost", {
  group = group,
  callback = function()
    vim.hl.on_yank()
  end,
})

-- ========================
-- MARKDOWN
-- ========================
autocmd("FileType", {
  group = group,
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
    vim.opt_local.showbreak = "↪ "
    vim.diagnostic.disable(0)
  end,
})

-- ========================
-- AUTO SAVE
-- ========================
autocmd("FocusLost", {
  group = group,
  callback = function()
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(bufnr)
          and vim.bo[bufnr].modified
          and vim.bo[bufnr].filetype ~= "markdown"
          and vim.bo[bufnr].buftype == ''
      then
        vim.cmd("silent! write")
      end
    end
  end,
})

-- ========================
-- DASHBOARD
-- ========================
autocmd("VimEnter", {
  group = group,
  callback = function()
    if vim.fn.argc() == 0 then
      require("snacks.dashboard").open()
    end
  end,
})
