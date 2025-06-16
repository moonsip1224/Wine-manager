#!/bin/bash
set -e

echo "🌐 Installing noVNC and websockify"
echo "================================="

cd /root

# Remove old versions if they exist
echo "🧹 Cleaning up old installations..."
rm -rf /root/novnc /root/noVNC-* /root/websockify-*

# Install latest noVNC
echo "📥 Downloading noVNC v1.4.0..."
if wget -O - https://github.com/novnc/noVNC/archive/v1.4.0.tar.gz | tar -xzv; then
    mv noVNC-1.4.0 novnc
    ln -sf /root/novnc/vnc_lite.html /root/novnc/index.html
    echo "✅ noVNC installed"
else
    echo "❌ Failed to download noVNC"
    exit 1
fi

# Install latest websockify
echo "📥 Downloading websockify v0.12.0..."
if wget -O - https://github.com/novnc/websockify/archive/v0.12.0.tar.gz | tar -xzv; then
    mv websockify-0.12.0 novnc/utils/websockify
    echo "✅ websockify installed"
else
    echo "❌ Failed to download websockify"
    exit 1
fi

echo "✅ noVNC and websockify installation completed!"
