<p align="center"><img src="https://socialify.git.ci/prownie/swifty-proteins/image?language=1&amp;name=1&amp;theme=Light" alt="project-image"></p>

<p id="description">Subject : build an application using RCSB API to make a protein 3D visualizer according to standardized representation</p>

<h2>Project Screenshots:</h2>

<img src="[url=https://postimg.cc/crpbDscK][img]https://i.postimg.cc/crpbDscK/Screenshot-2023-01-09-at-13-02-55.png[/img][/url]" alt="project-screenshot" width="400" height="400/">

<img src="[url=https://postimg.cc/1gH75D16][img]https://i.postimg.cc/1gH75D16/Screenshot-2023-01-09-at-13-03-56.png[/img][/url]" alt="project-screenshot" width="400" height="400/">

  
  
<h2>🧐 Features</h2>

Here're some of the project's best features:

*   3D rendering in mobile app
*   social Sharing
*   SearchBar
*   Basic understanding of biochemy
*   compact view
*   save to gallery
*   fingerprint / face ID login
*   atom selector

<h2>🛠️ Installation Steps:</h2>

<p>1. Clone the repo</p>

<p>2. Get dependencies</p>

```
flutter pub get
```

<p>3. Need to modify native_screenshoot to remove permission asking (cause sdk 33 new permission system)</p>

``` 
 =>	.pub-cache/hosted/pub.dartlang.org/native_screenshot-0.0.5/android/src/main/java/jpg/ivan/native_screenshot/NativeScreenshotPlugin.java
 => comment line 135 to 140

- change directory where screen is saved 

 => Line 206 change line to -> String externalDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES).getAbsolutePath(); 
```

<p>4. Run your favorite emulator</p>

<p>5. Run the project</p>

```
flutter run
```

  
<h2>💻 Built with</h2>

Technologies used in the project:

*   Flutter
*   android studio

