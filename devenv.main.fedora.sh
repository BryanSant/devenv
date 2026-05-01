#!/bin/bash

echo "📦 Installing packages for Fedora..."
sudo dnf install -y git git-lfs zip 7zip zoxide zsh vim micro curl @development-tools direnv
