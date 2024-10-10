#! /bin/bash

# Create a clickable macOS app bundle from a java .jar file

# Usage: sh ./create-qstudio-macos-app.sh ./qstudio.jar
#
# 
# First argument is the .jar file itself
# Output is a clickable app, saved within the repo

# Remove the previous version
rm -rf qStudio.app

# Copy the qStudio .jar file into the bundle
mkdir -p qStudio.app/Contents/Resources
cp "$1" qStudio.app/Contents/Resources/qstudio.jar
cp /usr/local/bin/prqlc qStudio.app/Contents/Resources/prqlc
 
# Copy the "script to execute" into the bundle
# Maybe see: https://github.com/timeseries/qstudio/issues/93

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
