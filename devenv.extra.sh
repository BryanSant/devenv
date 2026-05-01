#!/bin/bash

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

# --- Determine Environment Type (Desktop vs Headless) ---
export IS_DESKTOP=false
if [ "$DISTRO" = "macos" ]; then
    export IS_DESKTOP=true
elif [ "$XDG_SESSION_TYPE" = "wayland" ] || [ -n "$WAYLAND_DISPLAY" ] || [ -n "$DISPLAY" ]; then
    export IS_DESKTOP=true
fi

# --- System Package Installation (Platform Specific) ---
case "$DISTRO" in
  "ubuntu") DISTRO="debian" ;;
  "cachyos") DISTRO="arch" ;;
esac

if [[ "$DISTRO" =~ ^(debian|arch|fedora|macos)$ ]]; then
  echo "📥 Downloading and running platform-specific extra setup for $DISTRO..."
  curl -sSL "https://raw.githubusercontent.com/BryanSant/devenv/main/devenv.extra.${DISTRO}.sh" | bash
else
  echo "⚠️ No specific extra setup script for $DISTRO. Skipping platform-specific tools."
fi

# --- Claude, Gemini & Firebase (NPM) ---
echo "✨ Installing Claude, Gemini and Firebase CLI..."
if command -v npm &> /dev/null; then
    npm install -g @anthropic-ai/claude-code @google/gemini-cli firebase-tools
else
    echo "⚠️ npm not found. Skipping Claude, Gemini and Firebase."
fi

# --- k3d (Common) ---
echo "☸️ Installing k3d..."
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

echo "✅ Extra tools installation complete!"
