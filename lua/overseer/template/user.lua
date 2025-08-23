-- lua/overseer/template/user.lua
local templates = {}

-- Python: roda o arquivo atual
table.insert(templates, {
  name = "Run Python file",
  builder = function()
    return { cmd = { "python", vim.fn.expand("%") } }
  end,
  condition = { filetype = { "python" } },
})

-- Java: compila e roda a classe atual (sem pacotes)
table.insert(templates, {
  name = "Run Java file (simple)",
  builder = function()
    return { cmd = { "./gradlew", "run" } }
  end,
  condition = { filetype = { "java" } },
})

-- Flutter: roda o app
table.insert(templates, {
  name = "Run Flutter app",
  builder = function()
    return { cmd = { "flutter", "run" } }
  end,
  condition = { filetype = { "dart" } },
})

return templates
