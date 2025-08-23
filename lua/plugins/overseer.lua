-- lua/plugins/overseer.lua
return {
  "stevearc/overseer.nvim",
require("overseer").setup({ templates = { "builtin" } })

local overseer = require("overseer");

-- registrar 1 template
overseer.register_template({
  name = "Run Python file",
  builder = function()
    return { cmd = { "python3", vim.fn.expand("%") } }
  end,
  condition = { filetype = { "python" } },
})

-- registrar outros
overseer.register_template({
  name = "Run Java file (simple)",
  builder = function()
    local fname = vim.fn.expand("%:t")
    local cname = vim.fn.expand("%:t:r")
    return { cmd = { "bash", "-c", "javac " .. fname .. " && java " .. cname } }
  end,
  condition = { filetype = { "java" } },
})

}
