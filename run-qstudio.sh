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

# Launch the java app
java -jar "$(dirname "$0")/../Resources/qstudio.jar"
