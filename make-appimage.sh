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
export DEPLOY_VULKAN=0
export STRACE_MODE=0

# Deploy dependencies
mkdir -p ./AppDir/bin
cp -r /usr/lib/GPU-T/* ./AppDir/bin
cp -r /usr/bin/gpu-t   ./AppDir/bin
quick-sharun \
	./AppDir/bin/*     \
	/usr/lib/libSM.so* \
	/usr/lib/libICE.so*
echo 'DOTNET_ROOT=${SHARUN_DIR}/bin' >> ./AppDir/.env

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the app normally quits before that time
# then skip this or check if some flag can be passed that makes it stay open
quick-sharun --test ./dist/*.AppImage
