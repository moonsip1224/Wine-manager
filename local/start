#!/bin/bash
set -e

echo "🚀 Wine Manager Local - Complete Setup & Start"
echo "==============================================="

# Get the current directory and set up paths
LOCAL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$LOCAL_DIR")"
WINE_MANAGER_DIR="$HOME/wine-manager"

export PORT=${PORT:-4000}
export DISPLAY=:99
export HOME="$HOME"

echo "📁 Local directory: $LOCAL_DIR"
echo "📁 Project root: $PROJECT_ROOT"
echo "📁 Wine Manager directory: $WINE_MANAGER_DIR"
echo "🌐 Port: $PORT"
echo "🖥️  Display: $DISPLAY"
echo "⏰ Time: $(date)"
echo "==============================================="

# Step 1: Detect Linux distribution
echo ""
echo "🔍 Step 1: Detecting Linux Distribution..."

if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS_NAME=$NAME
    DISTRO=$ID
    VERSION=$VERSION_ID
    echo "📍 Detected: $OS_NAME ($DISTRO $VERSION)"
else
    echo "❌ Cannot detect Linux distribution"
    exit 1
fi

# Step 2: Install system dependencies
echo ""
echo "📦 Step 2: Installing System Dependencies..."
echo "This will run the dependency installation script..."

if [ -f "$LOCAL_DIR/install-dependencies.sh" ]; then
    chmod +x "$LOCAL_DIR/install-dependencies.sh"
    "$LOCAL_DIR/install-dependencies.sh"
else
    echo "❌ Dependency installation script not found!"
    exit 1
fi

# Step 3: Set up environment
echo ""
echo "🔧 Step 3: Setting Up Environment..."

if [ -f "$LOCAL_DIR/setup-environment.sh" ]; then
    chmod +x "$LOCAL_DIR/setup-environment.sh"
    "$LOCAL_DIR/setup-environment.sh"
else
    echo "❌ Environment setup script not found!"
    exit 1
fi

# Step 4: Install noVNC
echo ""
echo "🌐 Step 4: Installing noVNC..."

if [ -f "$LOCAL_DIR/install-novnc.sh" ]; then
    chmod +x "$LOCAL_DIR/install-novnc.sh"
    "$LOCAL_DIR/install-novnc.sh"
else
    echo "❌ noVNC installation script not found!"
    exit 1
fi

# Step 5: Install Vinegar
echo ""
echo "🍇 Step 5: Installing Vinegar..."

if [ -f "$LOCAL_DIR/install-vinegar-local.sh" ]; then
    chmod +x "$LOCAL_DIR/install-vinegar-local.sh"
    "$LOCAL_DIR/install-vinegar-local.sh"
else
    echo "❌ Vinegar installation script not found!"
    exit 1
fi

# Step 6: Configure Wine
echo ""
echo "🍷 Step 6: Configuring Wine..."

if [ -f "$LOCAL_DIR/configure-wine.sh" ]; then
    chmod +x "$LOCAL_DIR/configure-wine.sh"
    "$LOCAL_DIR/configure-wine.sh"
else
    echo "❌ Wine configuration script not found!"
    exit 1
fi

# Step 7: Create desktop shortcuts
echo ""
echo "🖥️  Step 7: Creating Desktop Shortcuts..."

if [ -f "$LOCAL_DIR/create-shortcuts.sh" ]; then
    chmod +x "$LOCAL_DIR/create-shortcuts.sh"
    "$LOCAL_DIR/create-shortcuts.sh"
else
    echo "❌ Desktop shortcuts script not found!"
    exit 1
fi

# Step 8: Configure services
echo ""
echo "📝 Step 8: Configuring Services..."

if [ -f "$LOCAL_DIR/configure-services.sh" ]; then
    chmod +x "$LOCAL_DIR/configure-services.sh"
    "$LOCAL_DIR/configure-services.sh"
else
    echo "❌ Services configuration script not found!"
    exit 1
fi

# Step 9: System optimization
echo ""
echo "🔧 Step 9: System Optimization..."

if [ -f "$LOCAL_DIR/system-optimization.sh" ]; then
    chmod +x "$LOCAL_DIR/system-optimization.sh"
    "$LOCAL_DIR/system-optimization.sh"
else
    echo "❌ System optimization script not found!"
    exit 1
fi

# Step 10: Create management scripts
echo ""
echo "📜 Step 10: Creating Management Scripts..."

if [ -f "$LOCAL_DIR/create-management-scripts.sh" ]; then
    chmod +x "$LOCAL_DIR/create-management-scripts.sh"
    "$LOCAL_DIR/create-management-scripts.sh"
else
    echo "❌ Management scripts creation script not found!"
    exit 1
fi

# Step 11: Check if services are already running
echo ""
echo "🔍 Step 11: Checking for Existing Services..."

if [ -f "$WINE_MANAGER_DIR/supervisord.pid" ]; then
    echo "⚠️  Wine Manager appears to be already running"
    if "$WINE_MANAGER_DIR/status.sh" 2>/dev/null; then
        echo ""
        read -p "Services are running. Restart them? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "🛑 Stopping existing services..."
            "$WINE_MANAGER_DIR/stop.sh"
            sleep 3
        else
            echo "✅ Using existing services"
            echo ""
            echo "🌐 Wine Manager is available at: http://localhost:$PORT"
            echo "🔑 VNC Password: \$\$Hello1\$\$"
            echo ""
            echo "📋 Management commands:"
            echo "   🛑 Stop:   $WINE_MANAGER_DIR/stop.sh"
            echo "   📊 Status: $WINE_MANAGER_DIR/status.sh"
            echo "   🔍 Health: $WINE_MANAGER_DIR/healthcheck.sh"
            exit 0
        fi
    fi
fi

# Step 12: Check port availability
echo ""
echo "🌐 Step 12: Checking Port Availability..."

if command -v netstat >/dev/null 2>&1; then
    if netstat -tuln | grep ":$PORT " >/dev/null; then
        echo "⚠️  Port $PORT is already in use"
        echo "💡 Try setting a different port: PORT=8081 $0"
        exit 1
    fi
elif command -v ss >/dev/null 2>&1; then
    if ss -tuln | grep ":$PORT " >/dev/null; then
        echo "⚠️  Port $PORT is already in use"
        echo "💡 Try setting a different port: PORT=8081 $0"
        exit 1
    fi
fi

echo "✅ Port $PORT is available"

# Step 13: Start services
echo ""
echo "🚀 Step 13: Starting Wine Manager Services..."

cd "$WINE_MANAGER_DIR"

# Start in background and monitor
"$WINE_MANAGER_DIR/start.sh" &
START_PID=$!

# Wait for services to initialize
echo "⏳ Initializing services..."
sleep 10

# Check if services started successfully
if ! kill -0 $START_PID 2>/dev/null; then
    echo "❌ Failed to start Wine Manager services"
    echo "📋 Check logs in: $WINE_MANAGER_DIR/logs/"
    exit 1
fi

# Wait for noVNC to be available
echo "🔍 Waiting for web interface to be ready..."
RETRY_COUNT=0
MAX_RETRIES=30

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    if curl -f -s "http://localhost:$PORT/vnc_lite.html" >/dev/null 2>&1 || \
       wget --quiet --spider "http://localhost:$PORT/vnc_lite.html" 2>/dev/null; then
        break
    fi
    
    sleep 2
    RETRY_COUNT=$((RETRY_COUNT + 1))
    
    if [ $((RETRY_COUNT % 5)) -eq 0 ]; then
        echo "⏳ Still waiting... ($RETRY_COUNT/$MAX_RETRIES)"
    fi
done

if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
    echo "❌ Web interface failed to start within expected time"
    echo "📋 Check logs in: $WINE_MANAGER_DIR/logs/"
    echo "🔍 Try running: $WINE_MANAGER_DIR/healthcheck.sh"
else
    echo "✅ Web interface is ready!"
fi

echo ""
echo "🎉 === Wine Manager Successfully Started! ==="
echo ""
echo "🌐 Web Interface: http://localhost:$PORT"
echo "🔑 VNC Password: \$\$Hello1\$\$"
echo ""
echo "📱 Available Applications:"
echo "   🎮 Roblox Studio (Vinegar) - Game development"
echo "   🎮 Roblox Player (Vinegar) - Game playing"
echo "   🌐 Firefox - Web browser"
echo "   ⌨️  Virtual Keyboard - Touch device support"
echo "   💻 Terminal - Command line access"
echo "   📁 File Manager - File system browser"
echo ""
echo "📋 Management Commands:"
echo "   🛑 Stop:   $WINE_MANAGER_DIR/stop.sh"
echo "   📊 Status: $WINE_MANAGER_DIR/status.sh"
echo "   🔍 Health: $WINE_MANAGER_DIR/healthcheck.sh"
echo ""
echo "📁 Wine Manager Directory: $WINE_MANAGER_DIR"
echo "📋 Logs Directory: $WINE_MANAGER_DIR/logs/"
echo ""
echo "💡 Tip: Keep this terminal open to see service logs, or press Ctrl+C to run in background"

# Show logs
tail -f "$WINE_MANAGER_DIR/logs/supervisord.log"
