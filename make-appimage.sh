#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q gpu-t-git | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/512x512/apps/gpu-t.png
export DESKTOP=/usr/share/applications/gpu-t.desktop
export DEPLOY_DOTNET=1
export DEPLOY_VULKAN=1

# Deploy dependencies
mkdir -p ./AppDir/bin
echo '#!/bin/sh
exec dotnet "$APPDIR"/lib/GPU-T/GPU-T.dll' > ./AppDir/bin/gpu-t
chmod +x ./AppDir/bin/gpu-t

quick-sharun /usr/lib/GPU-T /usr/bin/vulkan-info

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the app normally quits before that time
# then skip this or check if some flag can be passed that makes it stay open
quick-sharun --test ./dist/*.AppImage
