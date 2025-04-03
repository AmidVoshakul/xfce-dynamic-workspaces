#!/bin/bash

# Устанавливаем директорию для скрипта
INSTALL_DIR="$HOME/.config/autostart"
SCRIPT_URL="https://raw.githubusercontent.com/AmidVoshakul/xfce-dynamic-workspaces/main/xfce-dynamic-workspaces.sh"

# Создаём директорию, если её нет
mkdir -p "$INSTALL_DIR"

# Загружаем скрипт
wget -O "$INSTALL_DIR/xfce-dynamic-workspaces.sh" "$SCRIPT_URL"
chmod +x "$INSTALL_DIR/xfce-dynamic-workspaces.sh"

# Создаём файл автозапуска
cat << EOF > "$INSTALL_DIR/xfce-dynamic-workspaces.desktop"
[Desktop Entry]
Type=Application
Exec=$INSTALL_DIR/xfce-dynamic-workspaces.sh
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Xfce Dynamic Workspaces
EOF

echo "Скрипт установлен и добавлен в автозапуск!"
