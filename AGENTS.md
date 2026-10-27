# AGENTS.md

Documentation for AI assistants working with this dot-vault.

## Overview

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/). Configuration is split into shared and machine-specific packages.

## Structure

```
~/dots/
├── README.md                  - Stow setup documentation
├── shared/                    - Configuration used on every machine
│   ├── .ideavimrc
│   └── .config/
│       └── nvim/
│           ├── init.lua           - lazy.nvim bootstrap + imports
│           ├── .stylua.toml       - Lua formatter config
│           ├── lua/
│           │   ├── core/          - Core configuration
│           │   │   ├── options.lua    - Vim options/settings
│           │   │   ├── keymaps.lua    - Keybindings
│           │   │   └── autocmds.lua   - Autocommands
│           │   └── plugins/       - Plugin specifications
│           │       ├── opencode.lua   - OpenCode AI assistant
│           │       ├── editor.lua     - Editor plugins
│           │       ├── lsp.lua        - LSP configuration
│           │       ├── ui.lua         - UI/theme plugins
│           │       └── ...
│           └── after/
│               └── ftplugin/      - Filetype-specific settings
├── work/                      - Work macOS Homebrew manifest
├── personal-mac/              - Personal macOS configuration
└── personal-omarchy/          - Personal Omarchy configuration
```

## Neovim Configuration

### Plugin Management
- Uses [lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management
- Plugins are defined in `shared/.config/nvim/lua/plugins/*.lua`
- Each file returns a lazy.nvim spec table (array of plugins)

### Adding a Plugin

1. Create `shared/.config/nvim/lua/plugins/<name>.lua` with the plugin spec:
   ```lua
   return {
     "author/repo-name",
     -- Optional: configuration
     opts = {},
     config = function() ... end,
   }
   ```

2. Keybindings go in `shared/.config/nvim/lua/core/keymaps.lua`

3. Run `:Lazy sync` to install

### Core Configuration
- `shared/.config/nvim/lua/core/options.lua` - Vim options (`vim.o.*`)
- `shared/.config/nvim/lua/core/keymaps.lua` - Global keybindings
- `shared/.config/nvim/lua/core/autocmds.lua` - Autocommands

### Key Conventions
- Mini.nvim for AI, surround, statusline
- TokyoNight theme
- snacks.nvim for input/picker/terminal
- which-key.nvim for keybinding hints

## Commands

### Sync changes to git
```bash
cd ~/dots
git add -A && git commit -m "message" && git push
```

### Stow a work machine
```bash
cd ~/dots
stow -t ~ shared
```

### Stow a personal macOS machine
```bash
cd ~/dots
stow -t ~ --ignore='^Brewfile$' shared personal-mac
```
