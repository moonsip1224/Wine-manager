#!/bin/bash
set -e

echo "📝 Configuring Services"
echo "======================"

WINE_MANAGER_DIR="$HOME/wine-manager"
export PORT=${PORT:-4000}

echo "⚙️  Creating supervisord configuration..."

# Create supervisord configuration
cat > "$WINE_MANAGER_DIR/config/supervisord-local.conf" << EOF
[supervisord]
nodaemon=true
logfile=$WINE_MANAGER_DIR/logs/supervisord.log
pidfile=$WINE_MANAGER_DIR/supervisord.pid
childlogdir=$WINE_MANAGER_DIR/logs

[unix_http_server]
file=$WINE_MANAGER_DIR/supervisor.sock

[supervisorctl]
serverurl=unix://$WINE_MANAGER_DIR/supervisor.sock

[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

[program:xvfb]
command=/usr/bin/Xvfb :99 -screen 0 1024x768x24 -ac +extension GLX +render -noreset
autorestart=true
stdout_logfile=$WINE_MANAGER_DIR/logs/xvfb.log
stderr_logfile=$WINE_MANAGER_DIR/logs/xvfb.log
environment=DISPLAY=":99"
priority=100

[program:x11vnc]
command=/usr/bin/x11vnc -display :99 -noxrecord -usepw -passwdfile $HOME/.vnc_password -forever -shared
autorestart=true
stdout_logfile=$WINE_MANAGER_DIR/logs/x11vnc.log
stderr_logfile=$WINE_MANAGER_DIR/logs/x11vnc.log
environment=DISPLAY=":99"
priority=200

[program:novnc]
command=$WINE_MANAGER_DIR/venv/bin/python $WINE_MANAGER_DIR/novnc/utils/websockify/websockify.py --web $WINE_MANAGER_DIR/novnc --listen $PORT localhost:5900
autorestart=true
stdout_logfile=$WINE_MANAGER_DIR/logs/novnc.log
stderr_logfile=$WINE_MANAGER_DIR/logs/novnc.log
priority=300

[program:xfce4]
command=/usr/bin/startxfce4
autorestart=true
stdout_logfile=$WINE_MANAGER_DIR/logs/xfce4.log
stderr_logfile=$WINE_MANAGER_DIR/logs/xfce4.log
environment=DISPLAY=":99",HOME="$HOME",USER="$USER"
priority=400

[program:onboard]
command=/usr/bin/onboard --size 1024x300 --startup-delay=10
autorestart=true
stdout_logfile=$WINE_MANAGER_DIR/logs/onboard.log
stderr_logfile=$WINE_MANAGER_DIR/logs/onboard.log
environment=DISPLAY=":99",HOME="$HOME"
priority=600
startretries=3
EOF

echo "🎨 Configuring desktop environment..."

# Set up XFCE configuration
mkdir -p "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml"

# Configure XFCE desktop
cat > "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-desktop" version="1.0">
  <property name="backdrop" type="empty">
    <property name="screen0" type="empty">
      <property name="monitor0" type="empty">
        <property name="workspace0" type="empty">
          <property name="color-style" type="int" value="0"/>
          <property name="image-style" type="int" value="5"/>
        </property>
      </property>
    </property>
  </property>
</channel>
EOF

# Configure onboard virtual keyboard
mkdir -p "$HOME/.config/onboard"
cat > "$HOME/.config/onboard/onboard.conf" << EOF
[main]
layout=Compact
theme=Droid
show-status-icon=False
auto-show-enabled=True
auto-hide-enabled=True
docking-enabled=True
docking-edge=bottom

[auto-show]
enabled=True
hide-on-key-press=False
hide-on-focus-change=True
EOF

echo "✅ Services configuration completed!"
