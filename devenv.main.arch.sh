#!/bin/bash

echo "📦 Installing packages for Arch/CachyOS..."
sudo pacman -Syu --noconfirm git git-lfs zip 7zip zoxide zsh vim micro curl base-devel direnv

if ! command -v yay &> /dev/null; then
  echo "✨ Installing yay (AUR helper)..."
  rm -rf /tmp/yay
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  cd /tmp/yay
  makepkg -si --noconfirm
  cd -
  rm -rf /tmp/yay
fi

# Re-verify and use yay to ensure everything is up to date and install packages
yay -S --noconfirm git git-lfs zip 7zip zoxide zsh vim micro curl direnv
