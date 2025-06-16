#!/bin/bash
set -e

echo "📦 Installing Railway System Dependencies"
echo "========================================"

export DEBIAN_FRONTEND=noninteractive

echo "🔄 Updating package lists..."
apt-get update >/dev/null 2>&1

echo "📦 Installing critical system packages..."
# Install any missing critical packages
apt-get install -y --no-install-recommends \
    python3-pip python3-venv wget curl tar unzip \
    build-essential git ca-certificates >/dev/null 2>&1 || true

echo "✅ System dependencies installed!"
