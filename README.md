# Create a clickable macOS binary from a .jar

This advice comes from: https://chatgpt.com/c/67081a99-78f0-8003-ba0c-9f40e341110a

---
To convert a Java `.jar` file into a double-clickable macOS app, you can follow these steps:

### 1. **Create an Executable Script**
Create a shell script to run the `.jar` file. Here’s an example script:
```bash
#!/bin/bash
java -jar /path/to/your-app.jar
```
- Replace `/path/to/your-app.jar` with the actual path to your `.jar` file.
- Save this script as `run-your-app.sh` (for example) and make it executable:
  ```bash
  chmod +x run-your-app.sh
  ```

### 2. **Create a macOS App Bundle**
An app bundle is a directory structure that macOS recognizes as an app. Follow these steps:

1. **Create the app directory structure**:
   ```bash
   mkdir -p YourApp.app/Contents/MacOS
   ```

2. **Move the script to the bundle**:
   Move the shell script (`run-your-app.sh`) to the `MacOS` folder:
   ```bash
   mv run-your-app.sh YourApp.app/Contents/MacOS/
   ```

3. **Create a `Info.plist` file**:
   Inside `YourApp.app/Contents/`, create a `Info.plist` file with the following content:
   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
   <plist version="1.0">
   <dict>
       <key>CFBundleName</key>
       <string>YourApp</string>
       <key>CFBundleDisplayName</key>
       <string>YourApp</string>
       <key>CFBundleIdentifier</key>
       <string>com.yourcompany.yourapp</string>
       <key>CFBundleVersion</key>
       <string>1.0</string>
       <key>CFBundleExecutable</key>
       <string>run-your-app.sh</string>
       <key>CFBundlePackageType</key>
       <string>APPL</string>
   </dict>
   </plist>
   ```
   This `Info.plist` file tells macOS how to execute the app.

### 3. **Make the Bundle Executable**
To make the entire app bundle executable, run:
```bash
chmod +x YourApp.app/Contents/MacOS/run-your-app.sh
```

### 4. **Optional: Add an Icon (Optional)**
You can add a custom icon by placing a `.icns` file in `YourApp.app/Contents/Resources/` and adding an `CFBundleIconFile` key in the `Info.plist`.

### 5. **Test the App**
Now you should be able to double-click `YourApp.app` and have it execute the Java `.jar` file.

This process will convert the `.jar` file into a macOS app that can be double-clicked to run.

----

No, the `.jar` file does not need to be inside the `YourApp.app/Contents/MacOS` directory. However, you need to ensure that the path to the `.jar` file in your shell script is correct.

Here are two common approaches:

### 1. **Keep the `.jar` Outside the App Bundle**
You can store the `.jar` file anywhere on your system, and the shell script just needs to reference its location.

Example script:
```bash
#!/bin/bash
java -jar /path/to/your-app.jar
```
Make sure to update `/path/to/your-app.jar` with the full absolute path to the `.jar` file.

### 2. **Keep the `.jar` Inside the App Bundle**
If you prefer to keep everything self-contained within the `.app` bundle, you can place the `.jar` file inside the `YourApp.app/Contents/Resources` directory, which is standard for app resources.

1. **Move the `.jar` file**:
   ```bash
   mkdir -p YourApp.app/Contents/Resources
   mv your-app.jar YourApp.app/Contents/Resources/
   ```

2. **Update the shell script**:
   Modify the script to point to the internal location of the `.jar` file:
   ```bash
   #!/bin/bash
   java -jar "$(dirname "$0")/../Resources/your-app.jar"
   ```

In this case, the script dynamically finds the path to the `.jar` file relative to the app's location, keeping everything within the app bundle.
