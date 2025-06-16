#!/bin/bash
set -e

echo "📝 Configuring and Starting Services"
echo "==================================="

export PORT=${PORT:-8080}

echo "⚙️  Updating supervisord configuration with port $PORT..."

# Update supervisord configuration with the correct port
sed -i "s/--listen 8080/--listen $PORT/g" /etc/supervisor/conf.d/supervisord.conf

# Configure Wine environment for container
export WINEDLLOVERRIDES="mscoree,mshtml="
export DISPLAY=:0

echo "🔧 Initializing Wine environment..."

# Initialize wine prefix if it doesn't exist
if [ ! -d "/root/prefix64" ]; then
    echo "🍷 Creating Wine prefix..."
    export WINEPREFIX="/root/prefix64"
    export WINEARCH=win64
    
    # Wait for X11 to be ready
    echo "⏳ Waiting for X11 server..."
    timeout 30 bash -c 'until xdpyinfo >/dev/null 2>&1; do sleep 1; done' || echo "X11 timeout, continuing..."
    
    # Initialize Wine
    /usr/bin/wineboot --init >/dev/null 2>&1 || echo "Wine initialization completed"
    
    # Configure Wine for GUI applications
    echo "⚙️  Configuring Wine for GUI applications..."
    /usr/bin/winecfg /v win10 2>/dev/null || echo "winecfg completed"
    
    # Clear any corrupted cached files
    rm -rf /root/.cache/winetricks/vcrun2019/* 2>/dev/null || true
    
    # Install basic Windows components for better compatibility
    echo "📦 Installing Windows components..."
    /usr/bin/winetricks -q --force corefonts vcrun2019 || echo "Some components may have failed to install, continuing..."
    
    echo "✅ Wine prefix created and configured"
else
    echo "✅ Wine prefix already exists"
fi

echo "🚀 Starting supervisord..."

# Start supervisord
exec /usr/bin/supervisord -n -c /etc/supervisor/conf.d/supervisord.conf
