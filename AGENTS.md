# AGENTS.md

Documentation for AI assistants working with this dot-vault.

## Overview

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/). Changes made to `~/.config/nvim/` or `~/dot-vault/.config/nvim/` are the same due to symlinking.

## Structure

```
~/dot-vault/
├── README.md              - Stow setup documentation
├── .ideavimrc             - JetBrains IDE vim configuration
├── .config/
│   └── nvim/
│       ├── init.lua           - lazy.nvim bootstrap + imports
│       ├── lazy-lock.json     - Plugin lockfile
│       ├── .stylua.toml       - Lua formatter config
│       ├── lua/
│       │   ├── core/          - Core configuration
│       │   │   ├── options.lua    - Vim options/settings
│       │   │   ├── keymaps.lua    - Keybindings
│       │   │   └── autocmds.lua   - Autocommands
│       │   └── plugins/       - Plugin specifications
│       │       ├── opencode.lua   - OpenCode AI assistant
│       │       ├── editor.lua     - Editor plugins
│       │       ├── lsp.lua        - LSP configuration
│       │       ├── ui.lua         - UI/theme plugins
│       │       └── ...
│       └── after/
│           └── ftplugin/      - Filetype-specific settings
```

## Neovim Configuration

### Plugin Management
- Uses [lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management
- Plugins are defined in `lua/plugins/*.lua`
- Each file returns a lazy.nvim spec table (array of plugins)

### Adding a Plugin

1. Create `lua/plugins/<name>.lua` with the plugin spec:
   ```lua
   return {
     "author/repo-name",
     -- Optional: configuration
     opts = {},
     config = function() ... end,
   }
   ```

2. Keybindings go in `lua/core/keymaps.lua`

3. Run `:Lazy sync` to install

### Core Configuration
- `lua/core/options.lua` - Vim options (`vim.o.*`)
- `lua/core/keymaps.lua` - Global keybindings
- `lua/core/autocmds.lua` - Autocommands

### Key Conventions
- Mini.nvim for AI, surround, statusline
- TokyoNight theme
- snacks.nvim for input/picker/terminal
- which-key.nvim for keybinding hints

## Commands

### Sync changes to git
```bash
cd ~/dot-vault
git add -A && git commit -m "message" && git push
```

### Re-stow (after cloning fresh)
```bash
cd ~/dot-vault
stow -t ~ .
```

### Uninstall
```bash
cd ~/dot-vault
stow -t ~ -D .
```
