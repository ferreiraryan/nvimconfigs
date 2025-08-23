return {
  name = "Run Python file",
  builder = function()
    return {
      cmd = { "python3", vim.fn.expand("%") },
    }
  end,
  condition = {
    filetype = { "python" },
  },
}

