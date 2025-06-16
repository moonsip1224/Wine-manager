#!/bin/bash
set -e

echo "🌐 Installing noVNC and websockify"
echo "================================="

WINE_MANAGER_DIR="$HOME/wine-manager"

# Ensure directory exists
mkdir -p "$WINE_MANAGER_DIR"
cd "$WINE_MANAGER_DIR"

# Remove old versions if they exist
echo "🧹 Cleaning up old installations..."
rm -rf novnc noVNC-* websockify-*

# Download noVNC
echo "📥 Downloading noVNC v1.4.0..."
if wget -O - https://github.com/novnc/noVNC/archive/v1.4.0.tar.gz | tar -xzv; then
    mv noVNC-1.4.0 novnc
    ln -sf "$WINE_MANAGER_DIR/novnc/vnc_lite.html" "$WINE_MANAGER_DIR/novnc/index.html"
    echo "✅ noVNC installed"
else
    echo "❌ Failed to download noVNC"
    exit 1
fi

# Download websockify
echo "📥 Downloading websockify v0.12.0..."
if wget -O - https://github.com/novnc/websockify/archive/v0.12.0.tar.gz | tar -xzv; then
    mv websockify-0.12.0 novnc/utils/websockify
    echo "✅ websockify installed"
else
    echo "❌ Failed to download websockify"
    exit 1
fi

echo "✅ noVNC and websockify installation completed!"
