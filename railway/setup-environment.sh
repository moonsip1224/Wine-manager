#!/bin/bash
set -e

echo "🔧 Setting Up Railway Environment"
echo "================================"

export PORT=${PORT:-8080}
export DISPLAY=:0
export HOME=/root

echo "📁 Creating directory structure..."

# Create all necessary directories
mkdir -p /root/.local/bin
mkdir -p /root/.config
mkdir -p /root/Desktop
mkdir -p /root/.vnc
mkdir -p /var/log/supervisor

echo "🔐 Setting up VNC passwords..."

# Set up VNC password file
echo '$$Hello1$$' > /root/x11vnc_password.txt
echo '$$Hello1$$' > /root/.vnc/passwd
chmod 600 /root/.vnc/passwd

echo "✅ Environment setup completed!"
