local M = {}

local pipe_path = '/tmp/godot.pipe'

function M.setup_server()
  local is_godot = vim.fn.findfile('project.godot', '.;') ~= ''

  if not is_godot then
    if vim.tbl_contains(vim.fn.serverlist(), pipe_path) then
      vim.fn.serverstop(pipe_path)
      vim.fn.delete(pipe_path)
    end
    return
  end

  if vim.tbl_contains(vim.fn.serverlist(), pipe_path) then
    return
  end

  if vim.fn.filewritable(pipe_path) == 1 then
    local ok, sock = pcall(vim.fn.sockconnect, 'pipe', pipe_path)
    if ok then
      vim.fn.chanclose(sock)
      return
    else
      vim.fn.delete(pipe_path)
    end
  end

  local ok, err = pcall(vim.fn.serverstart, pipe_path)
  if not ok then
    vim.notify("Erro ao iniciar server Godot: " .. tostring(err), vim.log.levels.ERROR)
  end
end

local group = vim.api.nvim_create_augroup("GodotServerSync", { clear = true })

vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
  group = group,
  pattern = "*",
  callback = function()
    -- Defer para garantir que o CWD foi atualizado pelo plugin antes de rodar
    vim.defer_fn(M.setup_server, 100)
  end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
  group = group,
  callback = function()
    if vim.tbl_contains(vim.fn.serverlist(), pipe_path) then
      vim.fn.serverstop(pipe_path)
      vim.fn.delete(pipe_path)
    end
  end,
})

return M
