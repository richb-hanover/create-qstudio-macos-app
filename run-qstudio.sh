#! /bin/sh

# Set the path to the proper `prqlc` binary:
ARCH=$(uname -m)

if [ "$ARCH" = "x86_64" ]; then
    export PATH="$(dirname "$0")/../Resources/x86:$PATH"
elif [ "$ARCH" = "arm64" ]; then
    export PATH="$(dirname "$0")/../Resources/arm64:$PATH"
else
    echo "Unknown architecture: $ARCH"
fi

# Check if Java is functional (detecting the version)
if java -version &> /dev/null; then
    # Launch the java app
    java -jar "$(dirname "$0")/../Resources/qstudio.jar"
else
    echo "Java is not installed."
    stderr_output=$(java -version 2>&1 1>/dev/null)
    osascript -e 'display alert "Java not installed" message "$stderr_output" as critical buttons {"OK"} default button "OK"'
fi
