-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
    'mfussenegger/nvim-dap-python',
  },
  keys = {
    -- Basic debugging keymaps, feel free to change to your liking!
    {
      '<F5>',
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
    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    {
      '<F7>',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: See last session result.',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        -- 'delve', -- go debugger
        'python',
      },
    }

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '󰏤',
          play = '',
          step_into = '',
          step_over = '',
          step_out = '',
          step_back = '',
          run_last = '',
          terminate = '',
          disconnect = '󰌙',
        },
      },
    }

    -- Change breakpoint icons
    -- vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    -- vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    -- local breakpoint_icons = vim.g.have_nerd_font
    --     and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
    --   or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    -- for type, icon in pairs(breakpoint_icons) do
    --   local tp = 'Dap' .. type
    --   local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
    --   vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    -- end

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    -- require('dap-go').setup {
    --  delve = {
    --    -- On Windows delve must be run attached or it crashes.
    --    -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
    --    detached = vim.fn.has 'win32' == 0,
    --  },
    --}

    -- START python config
    -- Installs an isolated version of debugpy to launch which is separate from the project's env
    require('dap-python').setup '/home/jason/.pyenv/versions/debugpy/bin/python'

    -- Set the default test runner to pytest. Most of the projects encountered are using it.
    -- This may not be needed. Try removing it.
    require('dap-python').test_runner = 'pytest'

    -- Add confguration to launch the current file.
    table.insert(dap.configurations.python, 1, {
      name = 'debugpy:pytest: Current File',
      type = 'python',
      request = 'launch',
      module = 'debugpy',
      args = {
        '-m',
        'pytest',
        '-lvxs',
        '--no-cov', -- disable coverage as coverage breaks debuggers. It breaks pycharm and dap.
        '${file}',
      },
      console = 'integratedTerminal',
    })
    table.insert(dap.configurations.python, 1, {
      name = 'debugpy: remote attach',
      type = 'python',
      request = 'attach',
      justMyCode = false,
      connect = {
        host = '127.0.0.1',
        port = 5678,
      },
    })
    -- END python config
    -- START C++ & Rust config
    dap.adapters.lldb = {
      type = 'executable',
      command = '/opt/llvm/bin/lldb-dap', -- adjust as needed, must be absolute path
      name = 'lldb',
    }
    dap.configurations.cpp = {
      {
        name = 'Launch',
        type = 'lldb',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},

        -- 💀
        -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
        --
        --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
        --
        -- Otherwise you might get the following error:
        --
        --    Error on launch: Failed to attach to the target process
        --
        -- But you should be aware of the implications:
        -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
        -- runInTerminal = false,
      },
    }
    -- IMPORTANT! You're probably looking for :RustLsp debuggables
    -- IMPORTANT! You're probably looking for :RustLsp debuggables
    -- IMPORTANT! You're probably looking for :RustLsp debuggables
    -- IMPORTANT! You're probably looking for :RustLsp debuggables
    -- IMPORTANT! You're probably looking for :RustLsp debuggables
    dap.configurations.rust = {
      {
        -- Follow the guide: https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#ccrust-via-lldb-vscode
        name = 'Launch',
        type = 'lldb',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},

        initCommands = function()
          -- Find out where to look for the pretty printer Python module.
          local rustc_sysroot = vim.fn.trim(vim.fn.system 'rustc --print sysroot')
          assert(vim.v.shell_error == 0, 'failed to get rust sysroot using `rustc --print sysroot`: ' .. rustc_sysroot)
          local script_file = rustc_sysroot .. '/lib/rustlib/etc/lldb_lookup.py'
          local commands_file = rustc_sysroot .. '/lib/rustlib/etc/lldb_commands'

          -- The following is a table/list of lldb commands, which have a syntax
          -- similar to shell commands.
          --
          -- To see which command options are supported, you can run these commands
          -- in a shell:
          --
          --   * lldb --batch -o 'help command script import'
          --   * lldb --batch -o 'help command source'
          --
          -- Commands prefixed with `?` are quiet on success (nothing is written to
          -- debugger console if the command succeeds).
          --
          -- Prefixing a command with `!` enables error checking (if a command
          -- prefixed with `!` fails, subsequent commands will not be run).
          --
          -- NOTE: it is possible to put these commands inside the ~/.lldbinit
          -- config file instead, which would enable rust types globally for ALL
          -- lldb sessions (i.e. including those run outside of nvim). However,
          -- that may lead to conflicts when debugging other languages, as the type
          -- formatters are merely regex-matched against type names. Also note that
          -- .lldbinit doesn't support the `!` and `?` prefix shorthands.
          return {
            ([[!command script import '%s']]):format(script_file),
            ([[command source '%s']]):format(commands_file),
          }
        end,
        -- ...,
      },
      {
        name = 'Launch function under cursor',
        type = 'lldb',
        request = 'launch',
        cargo = {
          args = { 'test', '--no-run' },
        },
        args = { '${selectedText}' },
        cwd = '${workspaceFolder}',
      },
    }
    -- END C++ & Rust config
  end,
}
