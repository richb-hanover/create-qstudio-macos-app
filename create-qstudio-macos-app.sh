#! /bin/bash

# Create a clickable macOS app bundle from the downloaded qStudio

# Usage: sh ./create-qstudio-macos-app.sh [beta]
#
# For example:
#  sh ./create-qstudio-macos-app.sh 

# If a "beta" option is provided, this script downloads and builds the beta-test qStudio
# The script does NOT automatically update the qStudio version based on production/beta

# Output is a clickable app, saved within the repo
# .gitignore the app bundle and its .zip, so the repo isn't too big

PRQLC_VERSION="0.13.2"
QSTUDIO_PRODUCTION_VERSION="4.01"
QSTUDIO_BETA_VERSION="3.86"

QSTUDIO_DOWNLOAD="https://github.com/timestored/qstudio/releases/download/$QSTUDIO_PRODUCTION_VERSION/qstudio.jar"
QSTUDIO_BETA_DOWNLOAD="https://www.timestored.com/qstudio/files/beta/qstudio.jar"
PRQLC_RELEASES="https://github.com/PRQL/prql/releases"

VERSION_FILE="CFBundleVersion.txt"
if [[ -f "$VERSION_FILE" ]]; then
  CURRENT_VERSION=$(cat "$VERSION_FILE")
else
  echo "Version file not found!"
  exit 1
fi
# Increment the version
NEW_VERSION=$((CURRENT_VERSION + 1))
# Update the version file
echo "$NEW_VERSION" > "$VERSION_FILE"

echo ""
echo "*** Update qStudio and prqlc version numbers within the script before running..."
if [ "$1" == "" ]; then
	QSTUDIO_URL="$QSTUDIO_DOWNLOAD"
	QSTUDIO_VERSION="$QSTUDIO_PRODUCTION_VERSION"
	echo "*** Building production release: Version $QSTUDIO_PRODUCTION_VERSION"
elif [ "$1" == "beta" ]; then
	QSTUDIO_URL="$QSTUDIO_BETA_DOWNLOAD"
	QSTUDIO_VERSION="$QSTUDIO_BETA_VERSION"
	echo "*** Building beta release: Version $QSTUDIO_BETA_VERSION"
else
	echo "*** Unknown option '$1' ***"
	exit
fi
echo ""

# Remove the previous qStudio.app bundle and rebuild anew
rm -rf qStudio.app

# Download the qStudio .jar file from the qStudio server
echo "Downloading qStudio.jar"
mkdir -p qStudio.app/Contents/Resources
wget  -q -O qStudio.app/Contents/Resources/qstudio.jar "$QSTUDIO_URL"

# Get both the x86 and arm64 versions of `prqlc`
# prqlc is about 18 megabytes, so it's not too big a deal to import both

echo "Downloading prqlc binary x86"
mkdir -p qStudio.app/Contents/Resources/x86/
wget -O - -q "$PRQLC_RELEASES/download/$PRQLC_VERSION/prqlc-$PRQLC_VERSION-x86_64-apple-darwin.tar.gz" | \
	tar -xz -f - -C qStudio.app/Contents/Resources/x86/ ./prqlc 

echo "Downloading prqlc binary arm64"
mkdir -p qStudio.app/Contents/Resources/arm64/
wget -O - -q "$PRQLC_RELEASES/download/$PRQLC_VERSION/prqlc-$PRQLC_VERSION-aarch64-apple-darwin.tar.gz" | \
	tar -xz -f - -C qStudio.app/Contents/Resources/arm64/ ./prqlc 

# Copy the script that launches the .jar file into the bundle & make it executable
echo "Adding startup script"
mkdir -p qStudio.app/Contents/MacOS
cp run-qstudio.sh qStudio.app/Contents/MacOS/run-qstudio.sh
chmod +x qStudio.app/Contents/MacOS/run-qstudio.sh

# Copy in the Info.plist & update short version string
echo "Updating Info.plist"
cp Info.plist qStudio.app/Contents
TODAY=`date +"%d%b%Y"`
NEW_STRING="qStudio $QSTUDIO_VERSION - prqlc $PRQLC_VERSION - $TODAY"
plist_path="qStudio.app/Contents/Info.plist"
python3 ./update_plist.py "$plist_path" "$NEW_STRING" "$NEW_VERSION"
# cat qStudio.app/Contents/Info.plist

# Copy in the .icns file
echo "Adding .icns"
cp qStudio.icns qStudio.app/Contents/Resources

echo "Done"
