#!/usr/bin/env bash
set -e

### helpers
log() { echo -e "\n==> $1"; }

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

### sanity check
if ! command -v pacman >/dev/null; then
  echo "This script must be run on Arch Linux."
  exit 1
fi

log "Starting dotfiles installation"

# ------------------------------------------------------------------
# yay bootstrap
# ------------------------------------------------------------------
if ! command -v yay >/dev/null; then
  log "Installing yay"
  sudo pacman -S --needed --noconfirm git base-devel
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  pushd /tmp/yay
  makepkg -si --noconfirm
  popd
  rm -rf /tmp/yay
else
  log "yay already installed"
fi

# ------------------------------------------------------------------
# install packages
# ------------------------------------------------------------------
# if [[ -f packages/pkglist-explicit.txt ]]; then
#   log "Installing pacman packages"
#   sudo pacman -S --needed - < packages/pkglist-explicit.txt
# fi

if [[ -f packages/pkglist-aur.txt ]]; then
  log "Installing AUR packages"
  yay -S --needed - < packages/pkglist-explicit.txt
fi

# ------------------------------------------------------------------
# dotfiles
# ------------------------------------------------------------------
log "Installing dotfiles"

mkdir -p ~/.config

stow_dir() {
  local dir="$1"
  if [[ -d "$dir" ]]; then
    log "Linking $dir"
    rsync -a --delete "$SCRIPT_DIR/$dir/" "$HOME/.config/$dir/"
  fi
}

stow_dir hypr
stow_dir waybar
stow_dir fastfetch
stow_dir alacritty
stow_dir swayosd
stow_dir conky
stow_dir nchat
stow_dir mako
stow_dir ly

# ------------------------------------------------------------------
# free files
# ------------------------------------------------------------------
if [[ -f "$SCRIPT_DIR/starship.toml" ]]; then
  log "Installing starship.toml"
  rsync -a "$SCRIPT_DIR/starship.toml" "$HOME/.config/starship.toml"
fi

if [[ -f "$SCRIPT_DIR/.zshrc" ]]; then
  log "Installing .zshrc"
  cp "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"
fi

# ------------------------------------------------------------------
# zsh default shell
# ------------------------------------------------------------------
if [[ "$SHELL" != *zsh ]]; then
  log "Setting zsh as default shell"
  chsh -s "$(which zsh)"
fi

# ------------------------------------------------------------------
# services
# ------------------------------------------------------------------
log "Enabling services"

sudo systemctl enable --now ly@tty1 || true
sudo systemctl disable --now getty@tty1 || true
sudo systemctl enable --now bluetooth.service || true
sudo systemctl enable --now power-profiles-daemon.service || true
systemctl --user enable --now wireplumber.service || true

# ------------------------------------------------------------------
# final tweaks
# ------------------------------------------------------------------

sudo cp ./ly/config.ini /etc/ly/config.ini -f

# ------------------------------------------------------------------
# done
# ------------------------------------------------------------------
log "Installation complete"
echo "Reboot recommended."
