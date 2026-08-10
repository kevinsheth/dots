# dot-vault

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Layout

- `shared/` - configs used on both work and personal machines
- `work/` - work-only Homebrew manifest (macOS)
- `personal-mac/` - personal macOS-only configs
- `personal-omarchy/` - personal Omarchy-only configs

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

Stow shared configs:

```bash
cd ~/dots
stow -t ~ shared
```

If this is a personal macOS machine, stow shared + personal configs:

```bash
cd ~/dots
stow -t ~ --ignore='^Brewfile$' shared personal-mac
```

### Personal machine (Omarchy)

No Homebrew bootstrap is used. Stow shared + Omarchy personal configs:

```bash
cd ~/dots
stow -t ~ shared personal-omarchy
```

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
stow -t ~ -D shared
```

Personal Omarchy machine:

```bash
cd ~/dots
stow -t ~ -D shared personal-omarchy
```

Personal macOS machine:

```bash
cd ~/dots
stow -t ~ -D --ignore='^Brewfile$' shared personal-mac
```
