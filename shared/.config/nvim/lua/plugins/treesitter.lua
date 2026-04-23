return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    local ok, ts = pcall(require, 'nvim-treesitter.configs')
    if not ok then
      ts = require('nvim-treesitter')
    end

    ts.setup({
      ensure_installed = {
        'bash',
        'c',
        'diff',
        'go',
        'gomod',
        'gosum',
        'gowork',
        'html',
        'kotlin',
        'lua',
        'luadoc',
        'json',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'rust',
        'toml',
      },
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}
