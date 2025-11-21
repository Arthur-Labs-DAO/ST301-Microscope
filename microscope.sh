#!/bin/bash
# ST301 Microscope Auto-Detector and VLC Launcher

# Install dependencies if missing
if ! command -v vlc &> /dev/null || ! command -v v4l2-ctl &> /dev/null; then
    echo "Installing required packages..."
    sudo apt update && sudo apt install -y vlc v4l-utils
fi

# Auto-detect ST301 microscope
echo "Detecting ST301 microscope..."
DEVICE_PATH=""
DEVICE_LIST=$(v4l2-ctl --list-devices 2>/dev/null)

while IFS= read -r line; do
    if [[ "$line" == *"ST301"* ]]; then
        found_st301=true
    elif [[ $found_st301 == true && "$line" =~ ^[[:space:]]*(/dev/video[0-9]+) ]]; then
        DEVICE_PATH="${BASH_REMATCH[1]}"
        break
    elif [[ $found_st301 == true && "$line" != *"/dev/"* && "$line" != "" && ! "$line" =~ ^[[:space:]] ]]; then
        break
    fi
done <<< "$DEVICE_LIST"

if [ -z "$DEVICE_PATH" ]; then
    echo "❌ ST301 microscope not found!"
    echo "Available devices:"
    v4l2-ctl --list-devices
    exit 1
fi

echo "✅ Found ST301 at: $DEVICE_PATH"
echo "🚀 Launching VLC..."
vlc "v4l2://$DEVICE_PATH" 2>/dev/null &
