#!/bin/bash

echo "📦 Setting up macOS..."
# Check for Homebrew
if ! command -v brew &> /dev/null; then
  echo "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Add brew to path for the rest of the script if it's a new install
  eval "$(/opt/homebrew/bin/brew shellenv)" || eval "$(/usr/local/bin/brew shellenv)"
fi
echo "🍺 Installing packages via Homebrew..."
brew install git git-lfs zoxide vim micro sevenzip direnv
