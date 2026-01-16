return {
  {
    'NickvanDyke/opencode.nvim',
    dependencies = {
      { 'folke/snacks.nvim', opts = { input = {}, picker = {}, terminal = {} } },
    },
    config = function()
      local function load_opencode_commands(dir)
        local prompts = {}
        local ok, scandir = pcall(vim.fn.scandir, dir)
        if not ok then
          return prompts
        end

        for _, file in ipairs(scandir) do
          if vim.endswith(file, '.md') or vim.endswith(file, '.txt') then
            local name = vim.fn.fnamemodify(file, ':r')
            local path = dir .. '/' .. file
            local content = vim.fn.readfile(path)
            local prompt_text = table.concat(content, '\n')

            prompts[name] = { prompt = prompt_text, submit = true }
          end
        end
        return prompts
      end

      local custom_commands = load_opencode_commands(vim.fn.expand '~/.opencode/opencode/commands')

      vim.g.opencode_opts = {
        prompts = vim.tbl_extend('force', {
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
        }, custom_commands),
        select = {
          prompt = 'opencode: ',
          sections = {
            prompts = true,
            commands = {
              ['session.new'] = 'Start a new session',
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
      vim.o.autoread = true
    end,
  },
}
