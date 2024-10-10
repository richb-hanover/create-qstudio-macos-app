#! /bin/bash

# Create a clickable macOS app bundle from a java .jar file

# Usage: sh ./create-qstudio-macos-app.sh ./qstudio.jar
#
# For example:
#  sh ./create-qstudio-macos-app.sh /Applications/qstudio.jar

# First argument is the .jar file itself
# Output is a clickable app, saved within the repo
# The app bundle is .gitignored, so the repo isn't too big

# Remove the previous qStudio.app and rebuild anew
rm -rf qStudio.app

# Copy the qStudio .jar file into the bundle
mkdir -p qStudio.app/Contents/Resources
cp "$1" qStudio.app/Contents/Resources/qstudio.jar

# Get both the x86 and arm64 versions of `prqlc`
# Should download the x86 version instead of sponging off my local copy
# prqlc is about 5 megabytes, so it's no big deal to import both
mkdir -p qStudio.app/Contents/Resources/x86/
mkdir -p qStudio.app/Contents/Resources/arm64/
cp /usr/local/bin/prqlc qStudio.app/Contents/Resources/x86/prqlc
wget -O qStudio.app/Contents/Resources/arm64/prqlc \
	https://github.com/PRQL/prql/releases/download/0.13.0/prqlc-0.13.0-aarch64-apple-darwin.tar.gz
 
# Copy the "script to execute" into the bundle
mkdir -p qStudio.app/Contents/MacOS
cp run-qstudio.sh qStudio.app/Contents/MacOS/run-qstudio.sh

# Copy in the Info.plist
cp Info.plist qStudio.app/Contents

# Copy in the .icns file
cp qStudio.icns qStudio.app/Contents/Resources

# Make the bundle executable
chmod +x qStudio.app/Contents/MacOS/run-qstudio.sh

# Make everything executable
chmod -R 755 qStudio.app
