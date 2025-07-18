-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    filesystem = {
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
      },
      commands = {
        add_init_py = function(state)
          local node = state.tree:get_node()
          local path = node.path

          if vim.fn.isdirectory(path) == 0 then
            path = vim.fn.fnamemodify(path, ":h")
          end

          local init_path = path .. "/__init__.py"

          if vim.fn.filereadable(init_path) == 1 then
            vim.notify('__init__.py já existe em ' .. path, vim.log.levels.INFO)
            return
          end

          local ok, err = pcall(vim.fn.writefile, {}, init_path)
          if ok then
            vim.notify('✅ Criado: ' .. init_path, vim.log.levels.INFO)
            require("neo-tree.sources.filesystem.commands").refresh(state)
          else
            vim.notify('Erro ao criar __init__.py: ' .. err, vim.log.levels.ERROR)
          end
        end,
      },
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
  },

  vim.api.nvim_create_user_command("InitPy", function()
    local manager = require("neo-tree.sources.manager")
    local state = manager.get_state("filesystem")
    local node = state.tree:get_node()

    if not node then
      vim.notify("Nenhum item selecionado no Neo-tree.", vim.log.levels.WARN)
      return
    end

    local path = node.path
    if vim.fn.isdirectory(path) == 0 then
      path = vim.fn.fnamemodify(path, ":h")
    end

    local init_path = path .. "/__init__.py"

    if vim.fn.filereadable(init_path) == 1 then
      vim.notify('__init__.py já existe em ' .. path, vim.log.levels.INFO)
      return
    end

    local ok, err = pcall(vim.fn.writefile, {}, init_path)
    if ok then
      vim.notify('✅ Criado: ' .. init_path, vim.log.levels.INFO)
      require("neo-tree.sources.filesystem.commands").refresh(state)
    else
      vim.notify('Erro ao criar __init__.py: ' .. err, vim.log.levels.ERROR)
    end
  end, {
    desc = "Cria um __init__.py na pasta selecionada do Neo-tree",
  })
}
