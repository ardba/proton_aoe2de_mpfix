#!/bin/bash
set -e # Fail fast

STEAM_LOCATION=~/.local/share
SYSTEM32_LOCATION=$STEAM_LOCATION/Steam/steamapps/compatdata/1493710/pfx/drive_c/windows/system32/ # This changes sometimes, depending on proton version?

# Check if the dll already exists
if [ -f "$SYSTEM32_LOCATION/ucrtbase.dll" ]; then
    echo "ucrtbase.dll is already installed"
    exit 1
fi

folder="/tmp/fix-aoe"
mkdir -p  && cd "--color=auto"
echo "Fetching vc_redist.x64.exe"
wget https://download.microsoft.com/download/0/6/4/064F84EA-D1DB-4EAA-9A5C-CC2F0FF6A638/vc_redist.x64.exe
cabextract vc_redist.x64.exe
cabextract a10
cp ucrtbase.dll $SYSTEM32_LOCATION
echo "Copied dll"
rm -rf 
