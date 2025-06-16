#!/bin/bash
set -e

echo "📜 Creating Management Scripts"
echo "============================"

WINE_MANAGER_DIR="$HOME/wine-manager"

echo "📝 Creating Wine Manager control scripts..."

# Create start script
cat > "$WINE_MANAGER_DIR/start.sh" << 'EOF'
#!/bin/bash
set -e

WINE_MANAGER_DIR="$HOME/wine-manager"
export PORT=${PORT:-4000}
export DISPLAY=:99

echo "🚀 Starting Wine Manager Local Environment"
echo "Port: $PORT | Display: $DISPLAY"

# Activate virtual environment
source "$WINE_MANAGER_DIR/venv/bin/activate"

# Start supervisord
cd "$WINE_MANAGER_DIR"
exec "$WINE_MANAGER_DIR/venv/bin/supervisord" -c "$WINE_MANAGER_DIR/config/supervisord-local.conf"
EOF

# Create stop script
cat > "$WINE_MANAGER_DIR/stop.sh" << 'EOF'
#!/bin/bash

WINE_MANAGER_DIR="$HOME/wine-manager"

echo "🛑 Stopping Wine Manager services..."

if [ -f "$WINE_MANAGER_DIR/supervisord.pid" ]; then
    source "$WINE_MANAGER_DIR/venv/bin/activate"
    "$WINE_MANAGER_DIR/venv/bin/supervisorctl" -c "$WINE_MANAGER_DIR/config/supervisord-local.conf" shutdown
    rm -f "$WINE_MANAGER_DIR/supervisord.pid"
fi

# Kill any remaining processes
pkill -f "Xvfb :99" 2>/dev/null || true
pkill -f "x11vnc.*:99" 2>/dev/null || true
pkill -f "websockify" 2>/dev/null || true
pkill -f "startxfce4" 2>/dev/null || true

echo "✅ Wine Manager stopped"
EOF

# Create status script
cat > "$WINE_MANAGER_DIR/status.sh" << 'EOF'
#!/bin/bash

WINE_MANAGER_DIR="$HOME/wine-manager"

if [ -f "$WINE_MANAGER_DIR/supervisord.pid" ]; then
    source "$WINE_MANAGER_DIR/venv/bin/activate"
    echo "📊 Wine Manager Status:"
    "$WINE_MANAGER_DIR/venv/bin/supervisorctl" -c "$WINE_MANAGER_DIR/config/supervisord-local.conf" status
else
    echo "❌ Wine Manager is not running"
fi
EOF

# Create health check script
cat > "$WINE_MANAGER_DIR/healthcheck.sh" << EOF
#!/bin/bash

WINE_MANAGER_DIR="$HOME/wine-manager"
PORT=\${PORT:-4000}

echo "🔍 Running Wine Manager Health Check..."

# Check if supervisord is running
if [ ! -f "\$WINE_MANAGER_DIR/supervisord.pid" ]; then
    echo "❌ Supervisord is not running"
    exit 1
fi

# Check if noVNC is responding
if curl -f -s "http://localhost:\$PORT/vnc_lite.html" > /dev/null 2>&1; then
    echo "✅ Health check passed: Wine Manager is running on port \$PORT"
    echo "🌐 Access: http://localhost:\$PORT"
    echo "🔑 Password: \$\$Hello1\$\$"
    exit 0
else
    echo "❌ Health check failed: noVNC not responding on port \$PORT"
    exit 1
fi
EOF

chmod +x "$WINE_MANAGER_DIR"/*.sh

echo "✅ Management scripts created!"
