# Create qStudio.app - a clickable macOS app bundle

The [qStudio application](https://www.timestored.com/qstudio/prql-ide)
is currently distributed as a `.jar` file.
On macOS, people need to launch it from the command line.
Furthermore, using
[PRQL](https://prql-lang.org) requires the presence of
the `prqlc` compiler.
Installing the compiler is also difficult
for people who are not
comfortable with the command line.

The _create-qstudio-macos-app.sh_ script solves those problems
by combining the required
resources into a macOS application that can be downloaded
and double-clicked.

**Provisos:** One-time actions to use the app

* Double-clicking the app launches qStudio as desired, but
  this app bundle is not signed.
  The Finder will produce an "unverified developer" warning.
  Go to **System Preference -> Security** to accept and open the app.
* If the Mac does not already have Java installed, a message
  will appear to the effect that "you must install a Java SDK"
  and provide a link to the installer.

## How it works

The script bundles the qStudio `.jar` file,
the `prqlc` compilers for both for x86 and arm64 (Apple Silicon),
an icon for the application,
and the necessary startup script.
It also sets the Finder version info to
the string "qStudio VERSION - prqlc VERSION". 

The build script runs on any Linux/macOS computer.
In addition to the shell, it requires `python3`.
It is not tied to any macOS-specific utilities.

The script downloads current versions of all the resources
from canonical URLs and places them
in the proper directory of the bundle.
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

## Usage

To use the script:

1. Edit the three constants
  (QSTUDIO\_VERSION, PRQLC\_VERSION, QSTUDIO\_DOWNLOAD)
  to match the software versions you are bundling.
2. Run these commands

  ```
  cd this-repo
  sh ./create-qstudio-macos-app.sh
  ```
3. The qStudio.app bundle is built in the top level
  of the directory. 
  Immediately after being built, the bundle's icon
  may not appear in the Finder.
  **Get info...** usually forces the Finder to update it.

## Testing

The result has received minimal testing
and seems to work as expected on:
macos 10.15 (Catalina - Intel),
macOS 12.7.6 (Intel),
macOS 14.6.1 (arm64, Apple Silicon),
macOS 15.1 (Apple Silicon), and
macOS 15.0.1 (Intel)

## icns generation

There are several steps to produce the `.icns` file.
The [png-to-icns]()
script takes a 1024x1024 pixel PNG file and creates
the `.icns` file with all the various size icons.

But... the default Apple logo "style" is a rounded rectangle
inset from the outer bounds by about 10%.
The _Crusader-in-rrect.svg_ file is a good template.
To use it:

* Open the _Crusader-in-rrect.svg_ file in Inkscape
  (or other vector drawing program).
* Notice the black rounded rectangle surrounding the icon.
  It is about 90% of the height/width of the full icon,
  and has rounded corners.
* Update the icon image inside the rounded-rectangld as needed.
* Change the stroke for the rounded rectangle to "X" (none)
  to make it invisible.
* Save the file as `.svg`
* Export as PNG: Select the "Page" tab, and ensure that the
  border is a checkerboard, indicating that it's transparent.

Copy the saved `.png` file to the _png-to-icns_ folder.
Use this command: `sh ./png-to-icns.sh -i path-to-png`
Rename the resulting `.icns` file, and move back to the
desired folder.

## Uploading qStudio.app

Until the qStudio site includes the macOS bundle
as a standard build, I have placed it on my website at:

[https://randomneuronsfiring.com/wp-content/uploads/qStudio.zip](https://randomneuronsfiring.com/wp-content/uploads/qStudio.zip)

Create a `.zip` archive of _qStudio.app_, then
use the File Manager of the web hosting
software to upload new versions.
