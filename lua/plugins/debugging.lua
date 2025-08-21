return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "Continue",
      },
      {
        "<leader>dC",
        function()
          require("dap").run_to_cursor()
        end,
        desc = "Run to Cursor",
      },
      {
        "<leader>dT",
        function()
          require("dap").terminate()
        end,
        desc = "Terminate",
      },
    },
    config = function()
      local dap = require("dap")

      -- Adapter für codelldb
      dap.adapters.codelldb = function(callback, config)
        local port = 13000 -- Beliebiger, freier Port
        local codelldb_path = vim.fn.stdpath("data") .. "/mason/bin/codelldb"

        -- Server starten
        local handle
        local pid_or_err
        handle, pid_or_err = vim.loop.spawn(codelldb_path, {
          args = { "--port", tostring(port) },
          detached = true,
        }, function(code)
          handle:close()
          if code ~= 0 then
            print("codelldb exited with code", code)
          end
        end)

        -- Callback dem DAP-Client geben
        callback({ type = "server", host = "127.0.0.1", port = port })
      end

      -- Konfiguration für C++
      dap.configurations.cpp = {
        {
          name = "Launch",
          type = "codelldb",
          request = "launch",
          program = function()
            -- Frage nach Binary oder benutze Standard aus build-Ordner
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/build/main", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = function()
            -- Optional: frage nach Argumenten
            local input = vim.fn.input("Args: ")
            return vim.split(input, " ", true)
          end,
        },
      }
      dap.configurations.c = dap.configurations.cpp
      dap.configurations.rust = dap.configurations.cpp
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio", -- 🔥 die fehlende Abhängigkeit
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "codelldb",
      },
      automatic_installation = true,
    },
  },
}
