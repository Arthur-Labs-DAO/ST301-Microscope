#!/bin/bash
# ST301 Microscope Installer

echo "🔬 Installing ST301 Microscope..."

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo "❌ Don't run this as root! Run as regular user with sudo access."
   exit 1
fi

# Install the microscope command
sudo cp microscope /usr/local/bin/microscope
sudo chmod +x /usr/local/bin/microscope

# Create desktop application
mkdir -p ~/.local/share/applications

cat > ~/.local/share/applications/ST301-Microscope.desktop << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=ST301 Microscope
Comment=Auto-detect and launch ST301 USB Microscope with VLC
Exec=microscope
Icon=camera-video
Terminal=true
Categories=Science;Graphics;Photography;
Keywords=microscope;camera;science;ST301;vlc;
StartupNotify=true
EOF

chmod +x ~/.local/share/applications/ST301-Microscope.desktop

# Update desktop database
if command -v update-desktop-database &> /dev/null; then
    update-desktop-database ~/.local/share/applications/ 2>/dev/null
fi

echo ""
echo "✅ Installation complete!"
echo ""
echo "Usage:"
echo "  Command line: microscope"
echo "  Applications: Search for 'ST301 Microscope'"
echo ""
echo "The command will auto-install VLC and v4l-utils if needed."
