# dot-vault

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Contents

- `.config/nvim/` - Neovim configuration
- `.ideavimrc` - IdeaVim configuration for JetBrains IDEs
- `.aerospace.toml` - AeroSpace window manager config (macOS)

## Setup

### Prerequisites

Install GNU Stow:

```bash
# macOS
brew install stow

# Ubuntu/Debian
sudo apt install stow

# Arch
sudo pacman -S stow
```

### Installation

1. Clone this repo to your home directory:
   ```bash
   cd ~
   git clone https://github.com/kevinsheth/dots.git dot-vault
   ```

2. Remove any existing configs that would conflict:
   ```bash
   rm -rf ~/.config/nvim
   rm -f ~/.ideavimrc
   rm -f ~/.aerospace.toml
   ```

3. Run stow:
   ```bash
   cd ~/dot-vault
   stow -t ~ .
   ```

### macOS window manager setup (Omarchy-style)

This repo includes an AeroSpace config with Omarchy-like behavior:

- `alt-h/j/k/l` focus windows
- `alt-shift-h/j/k/l` move windows
- `alt-1..0` switch workspaces
- `alt-shift-1..0` move window to workspace
- `alt-space` opens Raycast

After stow, run:

```bash
aerospace reload-config
```

Then in macOS settings, ensure both **AeroSpace** and **Raycast** have:

- Accessibility permission
- Login item enabled

Raycast does not require a separate dotfile to match this workflow; it works out of the box once the global hotkey is set in Raycast settings.

### Updating

Changes made to files in `~/.config/nvim/` or `~/dot-vault/.config/nvim/` are the same (symlinked). To sync changes:

```bash
cd ~/dot-vault
git add -A && git commit -m "update config"
git push
```

### Uninstalling

To remove the symlinks:

```bash
cd ~/dot-vault
stow -t ~ -D .
```
