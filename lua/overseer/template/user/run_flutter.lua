return {
  name = "Run Flutter app",
  builder = function()
    return {
      cmd = { "flutter", "run" },
    }
  end,
  condition = {
    filetype = { "dart" },
  },
}
