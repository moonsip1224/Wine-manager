#!/bin/bash
set -e

echo "🔧 Setting Up Wine Manager Environment"
echo "====================================="

# Get the current directory and set up paths
LOCAL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WINE_MANAGER_DIR="$HOME/wine-manager"

export PORT=${PORT:-4000}
export DISPLAY=:99
export HOME="$HOME"

echo "📁 Local directory: $LOCAL_DIR"
echo "📁 Wine Manager directory: $WINE_MANAGER_DIR"
echo "🌐 Port: $PORT"
echo "🖥️  Display: $DISPLAY"

# Create Wine Manager directory structure
echo "📁 Creating directory structure..."
mkdir -p "$WINE_MANAGER_DIR"
mkdir -p "$WINE_MANAGER_DIR/config"
mkdir -p "$WINE_MANAGER_DIR/logs"
mkdir -p "$WINE_MANAGER_DIR/scripts"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.config"
mkdir -p "$HOME/Desktop"

echo "✅ Directory structure created"

# Create Python virtual environment
echo "🐍 Creating Python Virtual Environment..."

if [ ! -d "$WINE_MANAGER_DIR/venv" ] || [ ! -f "$WINE_MANAGER_DIR/venv/bin/activate" ]; then
    python3 -m venv "$WINE_MANAGER_DIR/venv"
    echo "✅ Virtual environment created"
else
    echo "✅ Virtual environment already exists"
fi

# Activate virtual environment and install Python dependencies
echo "📦 Installing Python dependencies..."
source "$WINE_MANAGER_DIR/venv/bin/activate"
pip install --upgrade pip

# Install comprehensive Python packages
pip install supervisor==4.2.5 psutil==5.9.5 requests==2.31.0 websockify==0.11.0 \
    numpy==1.24.3 pillow==10.0.0 setuptools wheel \
    lxml beautifulsoup4 six packaging \
    tornado flask gunicorn

echo "✅ Python dependencies installed"

# Set up VNC password
echo "🔐 Setting up VNC password..."
echo '$$Hello1$$' > "$HOME/.vnc_password"
chmod 600 "$HOME/.vnc_password"
echo "✅ VNC password configured"

echo "✅ Environment setup completed!"
