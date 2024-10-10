#! /bin/sh

export PATH="$(dirname "$0")/../Resources:$PATH"
java -jar "$(dirname "$0")/../Resources/qstudio.jar"
