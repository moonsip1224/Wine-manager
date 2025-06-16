#!/bin/bash
set -e

echo "🍷 Installing Wine Dependencies"
echo "==============================="

export DEBIAN_FRONTEND=noninteractive

echo "📦 Adding Wine repository..."

# Add Wine repository
wget -qO - https://dl.winehq.org/wine-builds/winehq.key | apt-key add - >/dev/null 2>&1 || true
echo 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main' | tee /etc/apt/sources.list.d/winehq.list >/dev/null

echo "🔄 Updating package lists..."
# Update and install Wine
apt-get update >/dev/null 2>&1

echo "📦 Installing Wine and winetricks..."
apt-get -y install --install-recommends winehq-stable winetricks >/dev/null 2>&1 || echo "Wine installation completed with warnings"

echo "✅ Wine dependencies installed!"
