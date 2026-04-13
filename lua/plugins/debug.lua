return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'mfussenegger/nvim-dap-python',
    'leoluz/nvim-dap-go',
    'nvim-neotest/nvim-nio',
    'jay-babu/mason-nvim-dap.nvim',
  },
  keys = {
    { '<F9>',      function() require('dap').continue() end,          desc = 'Debug: Start' },
    { '<F1>',      function() require('dap').step_into() end,         desc = 'Step Into' },
    { '<F2>',      function() require('dap').step_over() end,         desc = 'Step Over' },
    { '<F3>',      function() require('dap').step_out() end,          desc = 'Step Out' },
    { '<leader>b', function() require('dap').toggle_breakpoint() end, desc = 'Breakpoint' },
    { '<F7>',      function() require('dapui').toggle() end,          desc = 'Toggle UI' },
  },
  config = function()
    local dap, dapui = require 'dap', require 'dapui'

    require('mason-nvim-dap').setup {
      ensure_installed = { 'codelldb', 'python', 'delve', 'java-debug-adapter' },
      automatic_installation = true,
    }

    dapui.setup()
    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Adapters Setup
    require('dap-python').setup('python3')
    require('dap-go').setup()

    -- Java Attach
    dap.configurations.java = {
      {
        type = 'java',
        request = 'attach',
        name = 'Debug (Attach) - Remote',
        hostName = '127.0.0.1',
        port = 5005,
      },
    }

    -- C / C++ / Rust
    dap.adapters.codelldb = {
      type = 'server',
      port = '${port}',
      executable = {
        command = vim.fn.expand '$HOME/.local/share/nvim/mason/bin/codelldb',
        args = { '--port', '${port}' },
      },
    }

    local function get_executable()
      local target = vim.fn.expand('%:p:r')
      return (vim.fn.executable(target) == 1) and target or vim.fn.input('Path: ', vim.fn.getcwd() .. '/', 'file')
    end

    dap.configurations.cpp = {
      {
        name = 'Launch (Terminal)',
        type = 'codelldb',
        request = 'launch',
        program = get_executable,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        console = 'integratedTerminal', -- Para funcionar o scanf
      },
    }
    dap.configurations.c = dap.configurations.cpp
    dap.configurations.rust = dap.configurations.cpp

    -- Auto-build para C/C++ ao salvar
    vim.api.nvim_create_autocmd('BufWritePost', {
      group = vim.api.nvim_create_augroup('DAPBuild', { clear = true }),
      pattern = { '*.c', '*.cpp' },
      callback = function()
        local file = vim.fn.expand('%:p')
        local out = vim.fn.expand('%:p:r')
        local cmd = string.format('gcc -g "%s" -o "%s" -lm', file, out) -- Default para arquivos únicos

        if vim.fn.filereadable('Makefile') == 1 then cmd = 'make' end

        vim.fn.jobstart(cmd, {
          on_exit = function(_, code)
            if code == 0 then vim.notify('Build OK', 'info') end
          end
        })
      end,
    })
  end,
}
