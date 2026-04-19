#!/bin/bash

set -e

echo "🚀 Starting Development Environment Setup..."

# --- OS Detection ---
OS="$(uname)"
case "$OS" in
  "Linux")
    if [ -f /etc/os-release ]; then
      . /etc/os-release
      DISTRO=$ID
    else
      echo "❌ Could not detect Linux distribution."
      exit 1
    fi
    ;;
  "Darwin")
    DISTRO="macos"
    ;;
  *)
    echo "❌ Unsupported OS: $OS"
    exit 1
    ;;
esac

echo "Platform detected: $DISTRO"

# --- System Package Installation ---
case "$DISTRO" in
  "ubuntu"|"debian")
    echo "📦 Installing packages for Debian/Ubuntu..."
    sudo apt update
    sudo apt install -y git git-lfs zip 7zip zoxide zsh vim micro curl build-essential
    ;;
  "arch"|"cachyos")
    echo "📦 Installing packages for Arch/CachyOS..."
    sudo pacman -Syu --noconfirm git git-lfs zip 7zip zoxide zsh vim micro curl base-devel

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
    yay -S --noconfirm git git-lfs zip 7zip zoxide zsh vim micro curl
    ;;
  "fedora")
    echo "📦 Installing packages for Fedora..."
    sudo dnf install -y git git-lfs zip 7zip zoxide zsh vim micro curl development-tools
    ;;
  "macos")
    echo "📦 Setting up macOS..."
    # Check for Homebrew
    if ! command -v brew &> /dev/null; then
      echo "🍺 Installing Homebrew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      # Add brew to path for the rest of the script if it's a new install
      eval "$(/opt/homebrew/bin/brew shellenv)" || eval "$(/usr/local/bin/brew shellenv)"
    fi
    echo "🍺 Installing packages via Homebrew..."
    brew install git git-lfs zoxide vim micro sevenzip
    ;;
esac

# --- ZSH & Oh My Zsh ---
if [ "$SHELL" != "$(which zsh)" ] && [ "$DISTRO" != "macos" ]; then
  echo "🐚 Changing default shell to zsh..."
  sudo chsh -s "$(which zsh)" "$USER"
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "🐚 Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# OMZ Plugins
ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# --- NVM (Node Version Manager) ---
if [ ! -d "$HOME/.nvm" ]; then
  echo "🟢 Installing NVM..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
fi
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# --- SDKMan (Software Development Kit Manager) ---
if [ ! -d "$HOME/.sdkman" ]; then
  echo "☕ Installing SDKMan..."
  curl -s "https://get.sdkman.io" | bash
fi
# Source SDKMan even if already installed
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# --- uv (Python Package Manager) ---
if ! command -v uv &> /dev/null; then
  echo "🐍 Installing uv..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi
# Add uv to path for the current script
export PATH="$HOME/.local/bin:$PATH"

# --- Starship.rs ---
if ! command -v starship &> /dev/null; then
  echo "⭐ Installing Starship prompt..."
  curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# --- .zshrc Configuration ---
echo "🐚 Configuring .zshrc..."
if [ -f "$HOME/.zshrc" ]; then
  echo "📦 Backing up existing .zshrc to ~/.zshrc.pre-devenv"
  # Don't move if it's already a backup
  if [ ! -f "$HOME/.zshrc.pre-devenv" ]; then
      mv "$HOME/.zshrc" "$HOME/.zshrc.pre-devenv"
  fi
fi

echo "📥 Downloading new .zshrc..."
# Note: Replace the URL with your actual .zshrc location
curl -sSL https://raw.githubusercontent.com/BryanSant/devenv/main/.zshrc -o "$HOME/.zshrc"

# --- Tools & Languages ---

# Node.js
echo "🟢 Setting up Node.js..."
nvm install --lts
npm install -g @angular/cli

# Java & Ecosystem
echo "☕ Setting up Java ecosystem..."
sdk install java || true
JAVA_VERSION=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2)
sdk install java ${JAVA_VERSION}-graal || true
sdk install kotlin || true
sdk install gradle || true
sdk install maven || true
sdk flush

# Python
echo "🐍 Setting up Python..."
uv python install --default || true

echo "✅ Development environment setup complete!"
echo "⚠️ Please restart your terminal or run 'source ~/.zshrc' to apply changes."
