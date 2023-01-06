# swifty_proteins

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.




- Need to modify native_screenshoot to remove permission asking (cause sdk 33 new permission system)

 =>	.pub-cache/hosted/pub.dartlang.org/native_screenshot-0.0.5/android/src/main/java/jpg/ivan/native_screenshot/NativeScreenshotPlugin.java
 => comment line 135 to 140

- change directory where screen is saved 

 => Line 206 change line to -> String externalDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES).getAbsolutePath();

