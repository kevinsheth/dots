-- Rust-specific keymaps (only loaded for Rust files)
local bufnr = vim.api.nvim_get_current_buf()

local function map(keys, func, desc, mode)
  mode = mode or 'n'
  vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = 'Rust: ' .. desc })
end

-- Code actions with rust-analyzer grouping
map('<leader>ca', function()
  vim.cmd.RustLsp 'codeAction'
end, 'Code Action')

-- Hover actions (run twice to enter window, or set auto_focus)
map('K', function()
  vim.cmd.RustLsp { 'hover', 'actions' }
end, 'Hover Actions')

-- Debugging
map('<leader>rd', function()
  vim.cmd.RustLsp 'debuggables'
end, 'Debuggables')

-- Run targets
map('<leader>rr', function()
  vim.cmd.RustLsp 'runnables'
end, 'Runnables')

-- Test targets
map('<leader>rt', function()
  vim.cmd.RustLsp 'testables'
end, 'Testables')

-- Expand macro recursively
map('<leader>rm', function()
  vim.cmd.RustLsp 'expandMacro'
end, 'Expand Macro')

-- Open Cargo.toml
map('<leader>rc', function()
  vim.cmd.RustLsp 'openCargo'
end, 'Open Cargo.toml')

-- Parent module
map('<leader>rp', function()
  vim.cmd.RustLsp 'parentModule'
end, 'Parent Module')

-- Explain error under cursor
map('<leader>re', function()
  vim.cmd.RustLsp 'explainError'
end, 'Explain Error')

-- Render diagnostic (full cargo output)
map('<leader>rD', function()
  vim.cmd.RustLsp 'renderDiagnostic'
end, 'Render Diagnostic')

-- Join lines (works in visual mode too)
map('<leader>rj', function()
  vim.cmd.RustLsp 'joinLines'
end, 'Join Lines', { 'n', 'v' })

-- Open docs.rs for symbol under cursor
map('<leader>ro', function()
  vim.cmd.RustLsp 'openDocs'
end, 'Open docs.rs')

-- Rebuild proc macros
map('<leader>rR', function()
  vim.cmd.RustLsp 'rebuildProcMacros'
end, 'Rebuild Proc Macros')

-- View syntax tree
map('<leader>rs', function()
  vim.cmd.RustLsp 'syntaxTree'
end, 'Syntax Tree')
