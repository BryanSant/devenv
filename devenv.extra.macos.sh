#!/bin/bash

echo "🐙 Installing GitHub CLI..."
brew install gh

if [ "$IS_DESKTOP" = "true" ]; then
    echo "🖥️ Desktop environment detected. Installing Docker Desktop..."
    if ! command -v docker &> /dev/null; then
        brew install --cask docker
    else
        echo "✅ Docker already installed."
    fi
else
    echo "⚠️ Headless macOS not common, but Docker Desktop is the standard."
    if ! command -v docker &> /dev/null; then
        brew install --cask docker
    else
        echo "✅ Docker already installed."
    fi
fi

echo "🏗️ Installing Terraform..."
brew tap hashicorp/tap
brew install hashicorp/tap/terraform

echo "🚀 Installing Skaffold..."
brew install skaffold

echo "☁️ Installing Google Cloud CLI..."
brew install --cask google-cloud-sdk
