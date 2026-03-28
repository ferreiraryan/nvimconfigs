return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'mfussenegger/nvim-dap-python',
    'nvim-neotest/nvim-nio',
    'mason-org/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'leoluz/nvim-dap-go',
    'mfussenegger/nvim-jdtls',
  },
  keys = {
    {
      '<F9>',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<F1>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<F2>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<F3>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<leader>b',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>B',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Set Breakpoint',
    },
    {
      '<F7>',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: Toggle UI',
    },
  },
  config = function()
    local dap, dapui = require 'dap', require 'dapui'

    require('mason-nvim-dap').setup {
      automatic_installation = true,
      ensure_installed = {
        'delve',
        'java-debug-adapter',
        'codelldb',
      },
    }

    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Listeners para abrir/fechar UI automaticamente
    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Outras linguagens
    require('dap-go').setup { delve = { detached = vim.fn.has 'win32' == 0 } }
    require('dap-python').setup()

    dap.configurations.java = dap.configurations.java or {}
    table.insert(dap.configurations.java, {
      type = 'java',
      request = 'attach',
      name = 'Attach to :5005',
      hostName = '127.0.0.1',
      port = 5005,
    })

    -- Configuração C++ (CodeLLDB)
    dap.adapters.codelldb = {
      type = 'server',
      port = '${port}',
      executable = {
        command = vim.fn.expand '$HOME/.local/share/nvim/mason/bin/codelldb',
        args = { '--port', '${port}' },
      },
    }

    local function get_executable()
      local path = vim.fn.getcwd()
      local cmd = string.format(
        'find %s -maxdepth 4 -type f -executable '
          .. "-not -path '*/.*' -not -path '*/build/_deps/*' "
          .. "-printf '%%T@ %%p\\n' | sort -rh | cut -d' ' -f2- | head -n 1",
        path
      )
      local executable = vim.fn.trim(vim.fn.system(cmd))

      if executable == nil or executable == '' or executable:match 'find:' then
        return vim.fn.input('Executable path: ', path .. '/', 'file')
      end
      return executable
    end

    dap.configurations.cpp = {
      {
        name = 'Launch (Auto-find Newest)',
        type = 'codelldb',
        request = 'launch',
        program = get_executable,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
        initCommands = function()
          return { 'settings set target.disable-aslr false' }
        end,
      },
    }
    dap.configurations.c = dap.configurations.cpp
    dap.configurations.rust = dap.configurations.cpp

    -- Auto-Build System com Integração Quickfix
    local cpp_group = vim.api.nvim_create_augroup('CPPAutoBuild', { clear = true })
    vim.api.nvim_create_autocmd('BufWritePost', {
      group = cpp_group,
      pattern = { '*.cpp', '*.c', '*.hpp', '*.h', '*.cc' },
      callback = function()
        if vim.bo.filetype ~= 'cpp' and vim.bo.filetype ~= 'c' then
          return
        end

        local cwd = vim.fn.getcwd()
        local cmd = ''

        if vim.fn.filereadable(cwd .. '/CMakeLists.txt') == 1 then
          if vim.fn.isdirectory(cwd .. '/build') == 0 then
            cmd = 'cmake -B build -DCMAKE_BUILD_TYPE=Debug && cmake --build build -j $(nproc)'
          else
            cmd = 'cmake --build build -j $(nproc)'
          end
        elseif vim.fn.filereadable(cwd .. '/Makefile') == 1 then
          cmd = 'make -j $(nproc)'
        end

        if cmd ~= '' then
          local output = {}
          vim.fn.jobstart(cmd, {
            stdout_buffered = true,
            stderr_buffered = true,
            on_stdout = function(_, data)
              if data then
                vim.list_extend(output, data)
              end
            end,
            on_stderr = function(_, data)
              if data then
                vim.list_extend(output, data)
              end
            end,
            on_exit = function(_, code)
              if code == 0 then
                vim.notify('Build OK', 'info', { title = 'C++ Debug' })
                vim.fn.setqflist({}, 'r') -- Limpa quickfix se build passar
              else
                -- Popula Quickfix com o erro completo
                vim.fn.setqflist({}, 'r', { title = 'C++ Build Error', lines = output })
                vim.notify('Build FAILED (check :copen)', 'error', { title = 'C++ Debug' })
              end
            end,
          })
        end
      end,
    })
  end,
}
