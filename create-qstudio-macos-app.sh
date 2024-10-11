#! /bin/bash

# Create a clickable macOS app bundle from the downloaded qStudio

# Usage: sh ./create-qstudio-macos-app.sh 
#
# For example:
#  sh ./create-qstudio-macos-app.sh 

# Output is a clickable app, saved within the repo
# The app bundle is .gitignored, so the repo isn't too big

QSTUDIO_VERSION="3.10"
PRQLC_VERSION="0.13.1"
QSTUDIO_DOWNLOAD="https://www.timestored.com/qstudio/files/qstudio.jar"

# Remove the previous qStudio.app bundle and rebuild anew
rm -rf qStudio.app

# Download the qStudio .jar file from the qStudio server
echo "Downloading qStudio.jar"
mkdir -p qStudio.app/Contents/Resources
wget  -q -O qStudio.app/Contents/Resources/qstudio.jar "$QSTUDIO_DOWNLOAD"

# Get both the x86 and arm64 versions of `prqlc`
# prqlc is about 18 megabytes, so it's not too big a deal to import both
mkdir -p qStudio.app/Contents/Resources/x86/
mkdir -p qStudio.app/Contents/Resources/arm64/

echo "Downloading prqlc x86 binary"
wget -O - -q "https://github.com/PRQL/prql/releases/download/$PRQLC_VERSION/prqlc-$PRQLC_VERSION-x86_64-apple-darwin.tar.gz" | \
	tar -xz -C qStudio.app/Contents/Resources/x86/   prqlc

echo "Downloading prql arm64 binary"
wget -O - -q "https://github.com/PRQL/prql/releases/download/$PRQLC_VERSION/prqlc-$PRQLC_VERSION-aarch64-apple-darwin.tar.gz" | \
	tar -xz -C qStudio.app/Contents/Resources/arm64/ prqlc

# Copy the "script to execute" into the bundle & make it executable
echo "Adding startup script"
mkdir -p qStudio.app/Contents/MacOS
cp run-qstudio.sh qStudio.app/Contents/MacOS/run-qstudio.sh
chmod +x qStudio.app/Contents/MacOS/run-qstudio.sh

# Copy in the Info.plist & update short version string
echo "Updating Info.plist"
cp Info.plist qStudio.app/Contents
NEW_VERSION="qStudio $QSTUDIO_VERSION - prqlc $PRQLC_VERSION"
plist_path="qStudio.app/Contents/Info.plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $NEW_VERSION" "$plist_path"

# Copy in the .icns file
echo "Adding .icns"
cp qStudio.icns qStudio.app/Contents/Resources

echo "Done"