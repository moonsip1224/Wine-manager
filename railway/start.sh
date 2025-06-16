#!/bin/bash
set -e

echo "🚀 Wine Manager Railway - Complete Setup & Start"
echo "================================================"

# Get the current directory and set up paths
RAILWAY_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export PORT=${PORT:-8080}
export DISPLAY=:0
export HOME=/root
export DEBIAN_FRONTEND=noninteractive

echo "📁 Railway directory: $RAILWAY_DIR"
echo "🌐 Port: $PORT"
echo "🖥️  Display: $DISPLAY"
echo "⏰ Time: $(date)"
echo "================================================"

# Step 1: Install system dependencies
echo ""
echo "📦 Step 1: Installing System Dependencies..."

if [ -f "$RAILWAY_DIR/install-dependencies.sh" ]; then
    chmod +x "$RAILWAY_DIR/install-dependencies.sh"
    "$RAILWAY_DIR/install-dependencies.sh"
else
    echo "❌ Dependency installation script not found!"
    exit 1
fi

# Step 2: Set up environment
echo ""
echo "🔧 Step 2: Setting Up Environment..."

if [ -f "$RAILWAY_DIR/setup-environment.sh" ]; then
    chmod +x "$RAILWAY_DIR/setup-environment.sh"
    "$RAILWAY_DIR/setup-environment.sh"
else
    echo "❌ Environment setup script not found!"
    exit 1
fi

# Step 3: Install noVNC
echo ""
echo "🌐 Step 3: Installing noVNC..."

if [ -f "$RAILWAY_DIR/install-novnc.sh" ]; then
    chmod +x "$RAILWAY_DIR/install-novnc.sh"
    "$RAILWAY_DIR/install-novnc.sh"
else
    echo "❌ noVNC installation script not found!"
    exit 1
fi

# Step 4: Install Wine
echo ""
echo "🍷 Step 4: Installing Wine..."

if [ -f "$RAILWAY_DIR/install-wine.sh" ]; then
    chmod +x "$RAILWAY_DIR/install-wine.sh"
    "$RAILWAY_DIR/install-wine.sh"
else
    echo "❌ Wine installation script not found!"
    exit 1
fi

# Step 5: Install Vinegar
echo ""
echo "🍇 Step 5: Installing Vinegar..."

if [ -f "$RAILWAY_DIR/install-vinegar.sh" ]; then
    chmod +x "$RAILWAY_DIR/install-vinegar.sh"
    "$RAILWAY_DIR/install-vinegar.sh"
else
    echo "❌ Vinegar installation script not found!"
    exit 1
fi

# Step 6: Set up desktop
echo ""
echo "🖥️  Step 6: Setting Up Desktop..."

if [ -f "$RAILWAY_DIR/setup-desktop.sh" ]; then
    chmod +x "$RAILWAY_DIR/setup-desktop.sh"
    "$RAILWAY_DIR/setup-desktop.sh"
else
    echo "❌ Desktop setup script not found!"
    exit 1
fi

# Step 7: Configure and start services
echo ""
echo "📝 Step 7: Configuring and Starting Services..."

if [ -f "$RAILWAY_DIR/configure-services.sh" ]; then
    chmod +x "$RAILWAY_DIR/configure-services.sh"
    exec "$RAILWAY_DIR/configure-services.sh"
else
    echo "❌ Services configuration script not found!"
    exit 1
fi
