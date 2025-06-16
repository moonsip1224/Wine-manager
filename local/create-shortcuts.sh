#!/bin/bash
set -e

echo "🖥️  Creating Desktop Shortcuts"
echo "============================="

export HOME="$HOME"

# Create desktop shortcuts
echo "📱 Creating application shortcuts..."

# Firefox shortcut
cat > "$HOME/Desktop/Firefox.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Firefox Web Browser
Comment=Browse the World Wide Web
Exec=env DISPLAY=:99 firefox %u
Terminal=false
Icon=firefox
Categories=Network;WebBrowser;
StartupNotify=true
EOF

# Virtual Keyboard shortcut
cat > "$HOME/Desktop/Virtual Keyboard.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Virtual Keyboard
Comment=On-screen keyboard for touch devices
Exec=env DISPLAY=:99 onboard
Terminal=false
Icon=onboard
Categories=Utility;Accessibility;
EOF

# Terminal shortcut
cat > "$HOME/Desktop/Terminal.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Terminal
Comment=Use the command line
Exec=env DISPLAY=:99 xfce4-terminal
Terminal=false
Icon=utilities-terminal
Categories=Utility;
StartupNotify=true
EOF

# File Manager shortcut
cat > "$HOME/Desktop/File Manager.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=File Manager
Comment=Browse the file system
Exec=env DISPLAY=:99 thunar
Terminal=false
Icon=system-file-manager
Categories=Utility;FileManager;
StartupNotify=true
EOF

# Roblox Studio shortcut
cat > "$HOME/Desktop/Roblox Studio (Vinegar).desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Roblox Studio (Vinegar)
Comment=Roblox Studio via Vinegar - Optimized Wine setup
Exec=env DISPLAY=:99 PATH="$HOME/.local/bin:\$PATH" "$HOME/.local/bin/vinegar" studio
Icon=applications-games
Terminal=false
Categories=Game;Development;
StartupNotify=true
EOF

# Roblox Player shortcut
cat > "$HOME/Desktop/Roblox Player (Vinegar).desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Roblox Player (Vinegar)
Comment=Roblox Player via Vinegar - Optimized Wine setup
Exec=env DISPLAY=:99 PATH="$HOME/.local/bin:\$PATH" "$HOME/.local/bin/vinegar" player
Icon=applications-games
Terminal=false
Categories=Game;Entertainment;
StartupNotify=true
EOF

chmod +x "$HOME/Desktop"/*.desktop

# Make desktop shortcuts trusted
if command -v gio >/dev/null 2>&1; then
    echo "🔐 Making shortcuts trusted..."
    for desktop_file in "$HOME/Desktop"/*.desktop; do
        gio set "$desktop_file" metadata::trusted true 2>/dev/null || true
    done
fi

echo "✅ Desktop shortcuts created!"
