#! /bin/bash

# Create a clickable macOS app bundle from the downloaded qStudio

# Usage: sh ./create-qstudio-macos-app.sh 
#
# For example:
#  sh ./create-qstudio-macos-app.sh 

# Output is a clickable app, saved within the repo
# The app bundle is .gitignored, so the repo isn't too big

QSTUDIO_VERSION="3.86"
PRQLC_VERSION="0.13.2"
QSTUDIO_DOWNLOAD="https://www.timestored.com/qstudio/files/beta/qstudio.jar"

# qStudio download is at: https://www.timestored.com/qstudio/download
# prqlc downloads are at: https://github.com/PRQL/prql/releases

echo ""
echo "*** Update qStudio and prqlc version numbers within the script before running..."
echo ""

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

echo "Downloading prqlc binary x86"
wget -O - -q "https://github.com/PRQL/prql/releases/download/$PRQLC_VERSION/prqlc-$PRQLC_VERSION-x86_64-apple-darwin.tar.gz" | \
	tar -xz -f - -C qStudio.app/Contents/Resources/x86/ ./prqlc 

echo "Downloading prqlc binary arm64"
wget -O - -q "https://github.com/PRQL/prql/releases/download/$PRQLC_VERSION/prqlc-$PRQLC_VERSION-aarch64-apple-darwin.tar.gz" | \
	tar -xz -f - -C qStudio.app/Contents/Resources/arm64/ ./prqlc 

# Copy the script that launches the .jar file into the bundle & make it executable
echo "Adding startup script"
mkdir -p qStudio.app/Contents/MacOS
cp run-qstudio.sh qStudio.app/Contents/MacOS/run-qstudio.sh
chmod +x qStudio.app/Contents/MacOS/run-qstudio.sh

# Copy in the Info.plist & update short version string
echo "Updating Info.plist"
cp Info.plist qStudio.app/Contents
NEW_VERSION="qStudio $QSTUDIO_VERSION - prqlc $PRQLC_VERSION"
plist_path="qStudio.app/Contents/Info.plist"
python3 ./update_plist.py "$plist_path" "$NEW_VERSION"
# cat qStudio.app/Contents/Info.plist

# Copy in the .icns file
echo "Adding .icns"
cp qStudio.icns qStudio.app/Contents/Resources

echo "Done"
