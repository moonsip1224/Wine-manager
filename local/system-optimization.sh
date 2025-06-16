#!/bin/bash
set -e

echo "🔧 System Optimization and Verification"
echo "======================================"

WINE_MANAGER_DIR="$HOME/wine-manager"

# Verify graphics drivers
echo "🎮 Checking graphics configuration..."
if command -v glxinfo >/dev/null 2>&1; then
    if glxinfo | grep -q "direct rendering: Yes"; then
        echo "✅ Hardware graphics acceleration enabled"
    else
        echo "⚠️  Software rendering detected - performance may be limited"
    fi
else
    echo "ℹ️  Graphics info not available"
fi

# Optimize kernel parameters for gaming
echo "⚙️  Applying system optimizations..."
# Increase file descriptor limits
echo "* soft nofile 65536" | sudo tee -a /etc/security/limits.conf >/dev/null 2>&1 || true
echo "* hard nofile 65536" | sudo tee -a /etc/security/limits.conf >/dev/null 2>&1 || true

# Set vm.max_map_count for better performance
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf >/dev/null 2>&1 || true
sudo sysctl vm.max_map_count=262144 >/dev/null 2>&1 || true

# Configure swappiness for better responsiveness
echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf >/dev/null 2>&1 || true
sudo sysctl vm.swappiness=10 >/dev/null 2>&1 || true

# Verify network connectivity
echo "🌐 Verifying network connectivity..."
if ping -c 1 google.com >/dev/null 2>&1; then
    echo "✅ Network connectivity verified"
else
    echo "⚠️  Network connectivity issues detected"
fi

# Create Wine Manager launcher in applications menu
echo "📱 Creating application menu entry..."
mkdir -p "$HOME/.local/share/applications"
cat > "$HOME/.local/share/applications/wine-manager.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Wine Manager
Comment=Wine Desktop Environment with Roblox Studio
Exec=$WINE_MANAGER_DIR/start.sh
Icon=applications-games
Terminal=true
Categories=Game;Emulator;Development;
Keywords=wine;windows;roblox;studio;gaming;
StartupNotify=true
EOF

chmod +x "$HOME/.local/share/applications/wine-manager.desktop"

# Update desktop database
if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database "$HOME/.local/share/applications" >/dev/null 2>&1 || true
fi

echo "✅ System optimization completed!"
