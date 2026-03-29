return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  event = { "BufReadPost", "BufNewFile" }, -- Melhor que lazy=false para performance
  config = function()
    -- Use pcall para evitar que o erro trave seu init.lua inteiro
    local ok, configs = pcall(require, "nvim-treesitter.configs")
    if not ok then
      return
    end

    configs.setup({
      ensure_installed = {
        "c", "lua", "vim", "vimdoc", "query",
        "javascript", "typescript", "html", "css",
        "python", "bash", "markdown", "markdown_inline"
      },
      highlight = { enable = true },
      indent = { enable = true },
      auto_install = true,
    })

    -- Forçar o filetype que você quer
    vim.filetype.add({
      extension = {
        html = "htmldjango",
      },
    })
  end,
}
