#!/bin/bash
# Instala el servidor como LaunchAgent en macOS
# → arranca automáticamente al login y se mantiene vivo

NODE_PATH=$(which node 2>/dev/null || echo "/opt/homebrew/bin/node")
SERVER_DIR="$(cd "$(dirname "$0")" && pwd)"
PLIST_NAME="com.agallery.server"
PLIST_DEST="$HOME/Library/LaunchAgents/$PLIST_NAME.plist"
LOG_DIR="$SERVER_DIR/logs"

mkdir -p "$LOG_DIR"

# ── Genera el .plist con los paths reales de esta máquina ────────────────────
cat > "$PLIST_DEST" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>$PLIST_NAME</string>

  <key>ProgramArguments</key>
  <array>
    <string>$NODE_PATH</string>
    <string>$SERVER_DIR/server.js</string>
  </array>

  <key>WorkingDirectory</key>
  <string>$SERVER_DIR</string>

  <!-- Arranca al cargar el agente y se reinicia si muere -->
  <key>RunAtLoad</key>
  <true/>
  <key>KeepAlive</key>
  <true/>

  <key>StandardOutPath</key>
  <string>$LOG_DIR/server.log</string>
  <key>StandardErrorPath</key>
  <string>$LOG_DIR/server.error.log</string>

  <key>EnvironmentVariables</key>
  <dict>
    <key>PATH</key>
    <string>/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin</string>
    <key>NODE_ENV</key>
    <string>production</string>
  </dict>
</dict>
</plist>
EOF

# ── Registra / recarga el agente ─────────────────────────────────────────────
launchctl unload "$PLIST_DEST" 2>/dev/null
launchctl load -w "$PLIST_DEST"

echo ""
echo "✅ LaunchAgent instalado"
echo "   Node:   $NODE_PATH"
echo "   Server: $SERVER_DIR/server.js"
echo "   Logs:   $LOG_DIR/"
echo ""
echo "── Comandos útiles ─────────────────────────────────────"
echo "  Ver logs en vivo:  tail -f $LOG_DIR/server.log"
echo "  Estado:            launchctl list | grep agallery"
echo "  Detener:           launchctl unload $PLIST_DEST"
echo "  Reiniciar:         launchctl kickstart -k gui/$(id -u)/$PLIST_NAME"
echo "────────────────────────────────────────────────────────"
