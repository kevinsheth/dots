# dot-vault

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Layout

- `shared/` - configs used on both work and personal machines
- `work/` - work-only configs (macOS)
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

Stow shared + work configs:

```bash
cd ~/dots
stow -t ~ --ignore='^Brewfile$' shared work
```

If this is a personal macOS machine, stow `personal-mac` instead of `work`:

```bash
cd ~/dots
stow -t ~ shared personal-mac
```

### Personal machine (Omarchy)

No Homebrew bootstrap is used. Stow shared + Omarchy personal configs:

```bash
cd ~/dots
stow -t ~ shared personal-omarchy
```

## AeroSpace and Keyboard Modifiers (work)

After stowing on macOS, reload AeroSpace config:

```bash
aerospace reload-config
```

In macOS System Settings, grant **Accessibility** permission and enable **Login Item** for:

- AeroSpace
- Raycast

For a Windows-layout keyboard, use **System Settings → Keyboard → Keyboard Shortcuts → Modifier Keys** and swap Command/Option for that keyboard:

- **Option Key** → `Command`
- **Command Key** → `Option`

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
stow -t ~ -D shared personal-omarchy
```
