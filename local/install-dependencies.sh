#!/bin/bash
set -e

echo "🔧 Installing Wine Manager Local Dependencies"
echo "=============================================="

# Detect the Linux distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
    DISTRO=$ID
    VERSION=$VERSION_ID
else
    echo "❌ Cannot detect Linux distribution"
    exit 1
fi

echo "📍 Detected OS: $OS ($DISTRO $VERSION)"

# Function to install packages based on distribution
install_packages() {
    case $DISTRO in
        ubuntu|debian)
            echo "📦 Installing packages for Debian/Ubuntu..."
            
            # Update package lists
            sudo apt-get update
            
            # Add i386 architecture for Wine
            sudo dpkg --add-architecture i386
            
            # Install comprehensive system dependencies
            sudo apt-get install -y \
                python3 python3-pip python3-venv python3-dev python3-setuptools \
                xvfb x11vnc xdotool wget tar git curl unzip zip p7zip-full \
                software-properties-common gnupg2 apt-utils lsb-release \
                xfce4 xfce4-goodies xfce4-terminal thunar firefox \
                fonts-liberation fonts-dejavu-core fonts-freefont-ttf \
                fonts-noto fonts-noto-color-emoji fonts-roboto onboard \
                build-essential pkg-config cmake make gcc g++ \
                libasound2-dev libpulse-dev pulseaudio pulseaudio-utils \
                mesa-utils libgl1-mesa-dri libgl1-mesa-glx \
                libglu1-mesa libglu1-mesa-dev libglew-dev \
                supervisor net-tools x11-utils xauth xterm \
                ca-certificates apt-transport-https \
                libx11-dev libxext-dev libxrandr-dev libxinerama-dev \
                libxcursor-dev libxi-dev libxss-dev libxxf86vm-dev \
                libc6:i386 libncurses5:i386 libstdc++6:i386 \
                lib32z1 lib32ncurses5 lib32bz2-1.0 \
                libxrandr2:i386 libgstreamer-plugins-base1.0-0:i386 \
                gstreamer1.0-plugins-ugly:i386 \
                ubuntu-restricted-extras gstreamer1.0-libav \
                gstreamer1.0-plugins-bad gstreamer1.0-plugins-good \
                libavcodec-extra ffmpeg
            
            # Add Wine repository
            wget -qO - https://dl.winehq.org/wine-builds/winehq.key | sudo apt-key add -
            echo "deb https://dl.winehq.org/wine-builds/ubuntu/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/winehq.list
            
            # Update and install Wine
            sudo apt-get update
            sudo apt-get install -y --install-recommends winehq-stable winetricks
            ;;
            
        fedora|centos|rhel)
            echo "📦 Installing packages for Fedora/CentOS/RHEL..."
            
            # Install EPEL for CentOS/RHEL
            if [[ $DISTRO == "centos" || $DISTRO == "rhel" ]]; then
                sudo dnf install -y epel-release
            fi
            
            # Install comprehensive system dependencies
            sudo dnf install -y \
                python3 python3-pip python3-devel python3-setuptools \
                xorg-x11-server-Xvfb x11vnc xdotool wget tar git curl unzip zip p7zip \
                xfce4-session xfce4-panel xfce4-desktop xfce4-terminal thunar \
                firefox liberation-fonts dejavu-fonts google-noto-fonts \
                google-noto-emoji-fonts onboard \
                supervisor net-tools xorg-x11-utils xauth xterm \
                gcc gcc-c++ make pkgconfig cmake \
                alsa-lib-devel pulseaudio-libs-devel pulseaudio-utils \
                mesa-dri-drivers mesa-libGL mesa-libGLU mesa-libGLU-devel \
                libX11-devel libXext-devel libXrandr-devel libXinerama-devel \
                libXcursor-devel libXi-devel libXss-devel \
                glibc.i686 ncurses-libs.i686 libstdc++.i686 \
                zlib.i686 gstreamer1-plugins-base.i686 \
                gstreamer1-plugins-ugly gstreamer1-libav \
                gstreamer1-plugins-bad-free gstreamer1-plugins-good \
                ffmpeg
            
            # Install Wine (might need additional setup)
            sudo dnf install -y wine winetricks
            ;;
            
        arch|manjaro)
            echo "📦 Installing packages for Arch Linux..."
            
            # Update package database
            sudo pacman -Sy
            
            # Install comprehensive system dependencies
            sudo pacman -S --noconfirm \
                python python-pip python-setuptools xorg-server-xvfb x11vnc xdotool \
                wget tar git curl unzip zip p7zip xfce4 xfce4-goodies \
                xfce4-terminal thunar firefox ttf-liberation ttf-dejavu \
                ttf-noto-noto noto-fonts-emoji ttf-roboto onboard \
                supervisor net-tools xorg-utils xauth xterm \
                base-devel cmake alsa-lib libpulse pulseaudio \
                mesa mesa-utils lib32-mesa \
                libx11 libxext libxrandr libxinerama libxcursor libxi libxss \
                lib32-glibc lib32-ncurses lib32-gcc-libs lib32-zlib \
                gstreamer gst-libav gst-plugins-base gst-plugins-good \
                gst-plugins-bad gst-plugins-ugly ffmpeg
            
            # Install Wine
            sudo pacman -S --noconfirm wine winetricks
            ;;
            
        opensuse*)
            echo "📦 Installing packages for openSUSE..."
            
            # Install comprehensive system dependencies
            sudo zypper install -y \
                python3 python3-pip python3-devel python3-setuptools \
                xvfb x11vnc xdotool wget tar git curl unzip zip p7zip \
                xfce4-session xfce4-panel xfce4-terminal thunar firefox \
                liberation-fonts dejavu-fonts noto-sans-fonts \
                noto-coloremoji-fonts google-roboto-fonts onboard \
                supervisor net-tools xorg-x11-utils xauth xterm \
                gcc gcc-c++ make pkgconfig cmake \
                alsa-devel libpulse-devel pulseaudio-utils \
                Mesa Mesa-dri Mesa-libGL1 Mesa-libGLU1 Mesa-devel \
                libX11-devel libXext-devel libXrandr-devel libXinerama-devel \
                libXcursor-devel libXi-devel libXss-devel \
                glibc-32bit ncurses-devel-32bit libstdc++6-32bit \
                zlib-devel-32bit gstreamer-plugins-base-32bit \
                gstreamer-plugins-ugly gstreamer-plugins-libav \
                gstreamer-plugins-bad gstreamer-plugins-good ffmpeg
            
            # Install Wine
            sudo zypper install -y wine winetricks
            ;;
            
        *)
            echo "⚠️  Unsupported distribution: $DISTRO"
            echo "Please install the following packages manually:"
            echo "- Python 3.8+ with pip and venv"
            echo "- Xvfb, x11vnc, xdotool"
            echo "- XFCE4 desktop environment"
            echo "- Wine and winetricks"
            echo "- Build tools (gcc, make, etc.)"
            echo "- Audio libraries (ALSA, PulseAudio)"
            exit 1
            ;;
    esac
}

# Install system packages
install_packages

echo "✅ System dependencies installed successfully!"

# Create Wine Manager directory
WINE_MANAGER_DIR="$HOME/wine-manager"
mkdir -p "$WINE_MANAGER_DIR"

echo "📁 Wine Manager directory created at: $WINE_MANAGER_DIR"

# Install noVNC and websockify
echo "🌐 Installing noVNC and websockify..."
cd "$WINE_MANAGER_DIR"

# Download noVNC
if [ ! -d "novnc" ]; then
    wget -O - https://github.com/novnc/noVNC/archive/v1.4.0.tar.gz | tar -xzv
    mv noVNC-1.4.0 novnc
    ln -sf "$WINE_MANAGER_DIR/novnc/vnc_lite.html" "$WINE_MANAGER_DIR/novnc/index.html"
fi

# Download websockify
if [ ! -d "novnc/utils/websockify" ]; then
    wget -O - https://github.com/novnc/websockify/archive/v0.12.0.tar.gz | tar -xzv
    mv websockify-0.12.0 novnc/utils/websockify
fi

echo "✅ noVNC and websockify installed!"

# Create VNC password file
echo "🔐 Setting up VNC password..."
echo '$$Hello1$$' > "$HOME/.vnc_password"
chmod 600 "$HOME/.vnc_password"

# Set up directories
mkdir -p "$HOME/.config/wine-manager"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/Desktop"

echo ""
echo "🎉 All dependencies installed successfully!"
echo ""
echo "📋 Summary of installed components:"
echo "   ✅ Python 3 with pip and venv"
echo "   ✅ X11 virtual display (Xvfb)"
echo "   ✅ VNC server (x11vnc)"
echo "   ✅ XFCE4 desktop environment"
echo "   ✅ Wine and winetricks"
echo "   ✅ noVNC web interface"
echo "   ✅ Build tools and libraries"
echo ""
echo "📁 Wine Manager installed to: $WINE_MANAGER_DIR"
echo "🔑 VNC password: $$Hello1$$"
echo ""
echo "➡️  Next step: Run the setup script to configure the environment"
