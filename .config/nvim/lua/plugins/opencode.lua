return {
  {
    'NickvanDyke/opencode.nvim',
    dependencies = {
      { 'folke/snacks.nvim', opts = { input = {}, picker = {}, terminal = {} } },
    },
    config = function()
      vim.g.opencode_opts = {
        prompts = {
          ask_append = { prompt = '', ask = true },
          ask_this = { prompt = '@this: ', ask = true, submit = true },
          diagnostics = { prompt = 'Explain @diagnostics', submit = true },
          diff = { prompt = 'Review the following git diff for correctness and readability: @diff', submit = true },
          document = { prompt = 'Add comments documenting @this', submit = true },
          explain = { prompt = 'Explain @this and its context', submit = true },
          fix = { prompt = 'Fix @diagnostics', submit = true },
          implement = { prompt = 'Implement @this', submit = true },
          optimize = { prompt = 'Optimize @this for performance and readability', submit = true },
          review = { prompt = 'Review @this for correctness and readability', submit = true },
          test = { prompt = 'Add tests for @this', submit = true },
        },
        select = {
          prompt = 'opencode: ',
          sections = {
            prompts = true,
            commands = {
              ['session.new'] = 'Start a new session',
              ['session.select'] = 'Select an existing session',
              ['session.share'] = 'Share the current session',
              ['session.interrupt'] = 'Interrupt the current session',
              ['session.compact'] = 'Compact the current session (reduce context size)',
              ['session.undo'] = 'Undo the last action in the current session',
              ['session.redo'] = 'Redo the last undone action in the current session',
              ['agent.cycle'] = 'Cycle the selected agent',
              ['prompt.submit'] = 'Submit the current prompt',
              ['prompt.clear'] = 'Clear the current prompt',
            },
            provider = true,
          },
          snacks = {
            preview = 'preview',
            layout = {
              preset = 'vscode',
              hidden = {},
            },
          },
        },
      }
      -- After closing and reopening Neovim, opencode server may be gone. Run
      -- `opencode --port` again (or use a fixed port, e.g. port = 3000 and
      -- `opencode --port 3000`).
      vim.o.autoread = true

      -- Patch vim.ui.select so opencode's picker callback always gets the real item.
      vim.defer_fn(function()
        local orig = vim.ui.select
        vim.ui.select = function(items, opts, on_choice)
          local function wrapped(choice, idx)
            local first = items and items[1]
            local is_opencode = type(first) == "table" and (first.__type or first.__group or (first.item and first.item.__type))
            if is_opencode then
              local resolved = choice
              if type(choice) == "table" and choice.item and (choice.item.__type == "prompt" or choice.item.__type == "command" or choice.item.__type == "provider") then
                resolved = choice.item
              elseif (not resolved or type(resolved) == "number" or not (resolved.__type)) then
                local i = type(choice) == "number" and choice or idx
                if i and items[i] and items[i].__type then
                  resolved = items[i]
                end
              end
              return on_choice(resolved, idx)
            end
            return on_choice(choice, idx)
          end
          return orig(items, opts, wrapped)
        end
      end, 100)

      -- Workaround: tui.command.execute doesn't run custom commands on the server. Use the
      -- same path as other prompts: append text to prompt via API, then prompt.submit.
      vim.defer_fn(function()
        local api = require("opencode.api.command")
        local orig_api = api.command
        local client = require("opencode.cli.client")
        local server = require("opencode.cli.server")
        api.command = function(cmd)
          local cmd_str = (cmd and tostring(cmd)) or ""
          if cmd_str == "" then return orig_api(cmd) end
          -- Built-ins: plugin may pass with slash (e.g. /agent.cycle); server expects no slash
          local builtin = cmd_str:match("^/?(session%.[%w%.]+)$")
            or cmd_str:match("^/?(prompt%.[%w%.]+)$")
            or cmd_str:match("^/?(agent%.[%w%.]+)$")
          if builtin then
            return orig_api(builtin)
          end
          -- Custom command: needs slash for append; use append + Enter flow
          if not cmd_str:match("^/") then cmd_str = "/" .. cmd_str end
          -- Custom command: append via API (selector may open), then simulate Enter in terminal
          -- so the TUI confirms the command and submits (API prompt.submit doesn't work while selector is open).
          server.get_port()
            :next(function(port)
              client.tui_append_prompt(cmd_str, port, function()
                require("opencode.events").subscribe()
                -- Find embedded opencode terminal and send Enter to confirm command + submit
                for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
                  if vim.api.nvim_buf_is_valid(bufnr)
                      and vim.bo[bufnr].filetype == "opencode_terminal"
                      and vim.bo[bufnr].buftype == "terminal" then
                    local ok, job_id = pcall(vim.api.nvim_buf_get_var, bufnr, "terminal_job_id")
                    if ok and job_id and job_id > 0 then
                      -- 1st Enter: confirm command from selector; 2nd Enter: submit
                      vim.defer_fn(function()
                        vim.fn.chansend(job_id, "\r")
                        vim.defer_fn(function()
                          vim.fn.chansend(job_id, "\r")
                        end, 150)
                      end, 100)
                      return
                    end
                  end
                end
                -- No embedded terminal: try API submit anyway
                client.tui_execute_command("prompt.submit", port)
              end)
            end)
            :catch(function(err)
              vim.notify("opencode command failed: " .. tostring(err), vim.log.levels.ERROR, { title = "opencode" })
            end)
        end
      end, 150)
    end,
  },
}
