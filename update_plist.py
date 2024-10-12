 # Update the plist

 # Run with: 
 # python3 update_plist.py path/to/Info.plist 1.2.3

import plistlib
import sys

def update_version(plist_path, new_version):
    # Load the plist
    with open(plist_path, 'rb') as f:
        plist = plistlib.load(f)

    # Update CFBundleShortVersionString
    plist['CFBundleShortVersionString'] = new_version

    # Write back the updated plist
    with open(plist_path, 'wb') as f:
        plistlib.dump(plist, f)

    # print(f"Updated {plist_path} with CFBundleShortVersionString: {new_version}")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: script.py <path_to_plist> <new_version>")
        sys.exit(1)

    plist_path = sys.argv[1]
    new_version = sys.argv[2]

    update_version(plist_path, new_version)
