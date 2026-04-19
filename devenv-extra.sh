#!/bin/bash

set -e

echo "🚀 Starting Extra Tools Installation..."

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

# --- Load Environment ---
# Ensure NVM is available for npm-based tools
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# --- GitHub CLI ---
echo "🐙 Installing GitHub CLI..."
case "$DISTRO" in
  "ubuntu"|"debian")
    type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && sudo apt update \
    && sudo apt install gh -y
    ;;
  "arch"|"cachyos")
    sudo pacman -S --noconfirm github-cli
    ;;
  "fedora")
    sudo dnf install -y gh
    ;;
  "macos")
    brew install gh
    ;;
esac

# --- Docker (Linux Only) ---
if [ "$DISTRO" != "macos" ]; then
    echo "🐳 Installing Docker..."
    case "$DISTRO" in
      "ubuntu"|"debian")
        curl -fsSL https://get.docker.com | sh
        sudo usermod -aG docker $USER
        ;;
      "arch"|"cachyos")
        sudo pacman -S --noconfirm docker docker-compose
        sudo systemctl enable --now docker.service
        sudo usermod -aG docker $USER
        ;;
      "fedora")
        sudo dnf install -y moby-engine docker-compose
        sudo systemctl enable --now docker.service
        sudo usermod -aG docker $USER
        ;;
    esac
fi

# --- Gemini & Firebase (NPM) ---
echo "✨ Installing Gemini and Firebase CLI..."
if command -v npm &> /dev/null; then
    npm install -g @google/gemini-cli firebase-tools
else
    echo "⚠️ npm not found. Skipping Gemini and Firebase."
fi

# --- Terraform ---
echo "🏗️ Installing Terraform..."
case "$DISTRO" in
  "ubuntu"|"debian")
    wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update && sudo apt install terraform
    ;;
  "arch"|"cachyos")
    sudo pacman -S --noconfirm terraform
    ;;
  "fedora")
    sudo dnf install -y dnf-plugins-core
    sudo dnf config-manager --add-repo https://apt.releases.hashicorp.com/fedora/hashicorp.repo
    sudo dnf install -y terraform
    ;;
  "macos")
    brew tap hashicorp/tap
    brew install hashicorp/tap/terraform
    ;;
esac

# --- k3d ---
echo "☸️ Installing k3d..."
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

# --- Skaffold ---
echo "🚀 Installing Skaffold..."
case "$DISTRO" in
  "macos")
    brew install skaffold
    ;;
  *)
    curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64 && \
    sudo install skaffold /usr/local/bin/
    rm skaffold
    ;;
esac

# --- Google Cloud CLI ---
echo "☁️ Installing Google Cloud CLI..."
case "$DISTRO" in
  "macos")
    brew install --cask google-cloud-sdk
    ;;
  "arch"|"cachyos")
    # Using AUR or manual install is common, but let's go with the script for consistency
    curl https://sdk.cloud.google.com | bash --disable-prompts
    ;;
  *)
    curl https://sdk.cloud.google.com | bash --disable-prompts
    ;;
esac

echo "✅ Extra tools installation complete!"
