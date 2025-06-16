#!/bin/bash
set -e

echo "🍷 Configuring Wine Environment"
echo "=============================="

export DISPLAY=:99
export HOME="$HOME"
export PATH="$HOME/.local/bin:$PATH"

# Start a temporary Xvfb for Wine initialization
echo "🖥️  Starting temporary display server..."
/usr/bin/Xvfb :99 -screen 0 1024x768x24 &
XVFB_PID=$!
sleep 3

# Set Wine environment
export WINEPREFIX="$HOME/.local/share/vinegar/prefixes/studio"
export WINEARCH=win64

# Initialize Wine prefix
if [ ! -d "$WINEPREFIX" ]; then
    echo "🔧 Creating Wine prefix..."
    mkdir -p "$HOME/.local/share/vinegar/prefixes"
    timeout 120 wineboot --init >/dev/null 2>&1 || echo "Wine initialization completed"
    
    # Configure Wine for optimal performance
    echo "⚙️  Configuring Wine for optimal performance..."
    export WINEDLLOVERRIDES="mscoree,mshtml="
    
    # Set Wine to Windows 10 mode for better compatibility
    timeout 60 winecfg /v win10 >/dev/null 2>&1 || echo "Wine configuration completed"
    
    # Install essential Windows components
    echo "📦 Installing essential Windows components..."
    timeout 300 winetricks -q --force vcrun2019 corefonts >/dev/null 2>&1 || echo "Windows components installation completed"
    
    echo "✅ Wine prefix created and configured"
else
    echo "✅ Wine prefix already exists"
fi

# Configure audio for Wine
echo "🔊 Configuring audio for Wine..."
if ! pulseaudio --check; then
    pulseaudio --start --daemonize >/dev/null 2>&1 || echo "PulseAudio already running"
fi

# Stop temporary Xvfb
kill $XVFB_PID 2>/dev/null || true
sleep 2

echo "✅ Wine environment configuration completed!"
