# dot-vault

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Layout

- `shared/` - configs used on both work and personal machines
- `work/` - macOS/work-only configs and Homebrew bootstrap
- `personal/` - personal/Omarchy-only configs

## Prerequisites

Install GNU Stow:

```bash
# macOS
brew install stow

# Ubuntu/Debian
sudo apt install stow

# Arch
sudo pacman -S stow
```

## Bootstrap

### Work machine (macOS)

Install apps/tools from Homebrew:

```bash
cd ~/dots
brew bundle --file work/Brewfile
brew bundle check --file work/Brewfile
```

Stow shared + work configs:

```bash
cd ~/dots
stow -t ~ --ignore='^Brewfile$' shared work
```

### Personal machine (Omarchy)

No Homebrew bootstrap is used. Stow shared + personal configs:

```bash
cd ~/dots
stow -t ~ shared personal
```

## AeroSpace and Karabiner (work)

After stowing on macOS, reload AeroSpace config:

```bash
aerospace reload-config
```

In macOS System Settings, grant **Accessibility** permission and enable **Login Item** for:

- AeroSpace
- Karabiner-Elements
- Raycast

Karabiner config is tracked at `work/.config/karabiner/karabiner.json`.

## Updating

Edit files in `~/dots`, then commit and push:

```bash
cd ~/dots
git add -A && git commit -m "update dotfiles"
git push
```

## Uninstalling symlinks

Work machine:

```bash
cd ~/dots
stow -t ~ -D --ignore='^Brewfile$' shared work
```

Personal machine:

```bash
cd ~/dots
stow -t ~ -D shared personal
```
