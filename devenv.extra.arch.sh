#!/bin/bash

echo "🐙 Installing GitHub CLI..."
yay -S --noconfirm github-cli

echo "🐳 installing Docker..."
if [ "$IS_DESKTOP" = "true" ]; then
    if ! pacman -Qi docker-desktop &> /dev/null; then
        yay -S --noconfirm docker-desktop
    else
        echo "✅ Docker Desktop already installed."
    fi
else
    yay -S --noconfirm docker docker-compose
    sudo systemctl enable --now docker.service
    sudo usermod -aG docker $USER
fi

echo "🏗️ Installing Terraform..."
yay -S --noconfirm terraform

echo "🚀 Installing Skaffold..."
yay -S --noconfirm skaffold-bin

echo "☁️ Installing Google Cloud CLI..."
yay -S --noconfirm google-cloud-cli
