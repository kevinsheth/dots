# dot-vault

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Contents

- `.config/nvim/` - Neovim configuration
- `.ideavimrc` - IdeaVim configuration for JetBrains IDEs

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
   ```

3. Run stow:
   ```bash
   cd ~/dot-vault
   stow -t ~ .
   ```

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
