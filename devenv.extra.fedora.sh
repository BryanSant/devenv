#!/bin/bash

echo "🐙 Installing GitHub CLI..."
sudo dnf install -y gh

echo "🐳 Installing Docker..."
sudo dnf config-manager addrepo --from-repofile https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker
wget https://desktop.docker.com/linux/main/amd64/docker-desktop-x86_64.rpm
if [ "$IS_DESKTOP" = "true" ]; then
    sudo dnf install ./docker-desktop-x86_64.rpm
fi

echo "🏗️ Installing Terraform..."
sudo dnf install -y dnf-plugins-core
if [ "$VERSION_ID" -ge 44 ] 2>/dev/null; then
    sudo dnf config-manager addrepo --from-repofile=https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
    sudo sed -i 's/\$releasever/43/g' /etc/yum.repos.d/hashicorp.repo
else
    sudo dnf config-manager --add-repo https://apt.releases.hashicorp.com/fedora/hashicorp.repo
fi
sudo dnf install -y terraform

echo "🚀 Installing Skaffold..."
curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64 && \
sudo install skaffold /usr/local/bin/
rm skaffold

echo "☁️ Installing Google Cloud CLI..."
curl https://sdk.cloud.google.com > /tmp/gcloud-sdk-install.sh
bash /tmp/gcloud-sdk-install.sh --disable-prompts
rm /tmp/gcloud-sdk-install.sh
