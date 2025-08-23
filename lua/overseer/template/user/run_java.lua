return {
  name = "Run Java file",
  builder = function()
    local filename = vim.fn.expand("%:t")
    local classname = vim.fn.expand("%:t:r")
    return {
      cmd = { "bash", "-c", "javac " .. filename .. " && java " .. classname },
    }
  end,
  condition = {
    filetype = { "java" },
  },
}
