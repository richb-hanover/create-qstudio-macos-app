# Create qStudio.app - a clickable macOS app bundle

The [qStudio application](https://www.timestored.com/qstudio/prql-ide)
is currently distributed as a `.jar` file.
Furthermore, using qStudio with
[PRQL](https://prql-lang.org) require the presence of
the `prqlc` compiler.
Installing either of these components are inconvenient
tasks for people who are not
comfortable with the command line.

The _create-qstudio-macos-app.sh_ script builds a
double-clickable macOS application bundle.
It contains both the qStudio
`.jar` file and the `prqlc` compilers that have been
built both for x86 and arm64 (Apple Silicon).
The bundle also contains an icon for the application.

The script downloads all the resources and places them
in the proper location of the bundle.
The final layout is:

```
qStudio.app/
├── Contents/
    ├── MacOS/
    │   └── run-qstudio.sh
    ├── Resources/
    │   │── qstudio.jar
    │   │── qStudio.icns
    │   |── arm64
    │   |   └── prqlc
    │   └── x86
    │       └── prqlc  
    └── Info.plist

```

To use the script:

1. Edit the three constants
  (QSTUDIO_VERSION, PRQLC_VERSION, QSTUDIO_DOWNLOAD)
  to match the sofware versions you are building.
2. `sh ./create-qstudio-macos-app.sh`

## Testing

The build script runs on any Linux/macOS computer.
The result has been tested on macOS 12.7.5 (Intel)
and macOS 14.6.1 (arm64, Apple Silicon).
