#!/bin/bash
set -e

THEME_NAME="HornetCursor"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/$THEME_NAME"

if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Couldn't find the icon package '$THEME_NAME'not found in the script directory! You might have renamed it or got an incomplete zip."
    exit 1
fi

if [ "$EUID" -eq 0 ]; then
    TARGET_DIR="/usr/share/icons/$THEME_NAME"
    echo "Root permission detected, installing system-wide to: $TARGET_DIR"
else
    TARGET_DIR="$HOME/.local/share/icons/$THEME_NAME"
    echo "Installing for current user to: $TARGET_DIR"
fi

mkdir -p "$(dirname "$TARGET_DIR")"
rm -rf "$TARGET_DIR"
cp -r "$SOURCE_DIR" "$TARGET_DIR"
chmod -R 755 "$TARGET_DIR"
echo "Files copied successfully."

if command -v gsettings &> /dev/null; then
    gsettings set org.gnome.desktop.interface cursor-theme "$THEME_NAME" 2>/dev/null || true
    echo "Successfully applied theme to GNOME/GTK desktop."
fi

if command -v xfconf-query &> /dev/null; then
    xfconf-query -c xsettings -p /Gtk/CursorThemeName -s "$THEME_NAME" 2>/dev/null || true
    echo "Successfully applied theme to XFCE desktop."
fi

echo "🎉 Installation complete! If the theme did not update automatically, please select '$THEME_NAME' manually in your system Appearance settings or GNOME Tweaks."
