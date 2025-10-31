# audio_query

A Flutter plugin for querying audio files (songs, music, recordings) from device storage on **Android** and **iOS**. Easily retrieve metadata such as title, artist, album, duration, and more.

## Features

- Query **all audio files** on the device  
- Retrieve detailed metadata for each audio file (title, artist, album, duration, etc.)  
- Cross-platform support: Android & iOS  
- Simple, easy-to-use API  

## Getting Started

### Installation

Add `audio_query` to your `pubspec.yaml`:

```yaml
dependencies:
  audio_query: ^0.0.6
```

#### Then run:
```bash
flutter pub get
```

#### Usage
```dart
Import the package:

import 'package:audio_query/audio_query.dart';


Fetch audio files:

void fetchAudios() async {
  final audioQuery = AudioQuery();
  final audios = await audioQuery.getAudios();
  
  for (var audio in audios) {
    print('Title: ${audio.title}, Artist: ${audio.artist}');
  }
}
```
See the `example/` directory for a complete working example.

## Platform-specific Setup
### Android

Add the following permission to your `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
```

For Android 13+ (API level 33+), you may need to request:
`android.permission.READ_MEDIA_AUDIO`.

### iOS
Add the following key to your `Info.plist`:
```xml
<key>NSAppleMusicUsageDescription</key>
<string>This app needs access to your music library.</string>
```


### API Reference
`Future<List<AudioItemModel>> getAudios()`

Returns a list of `AudioItemModel` objects representing audio files available on the device.

### Contributing

Contributions are welcome! Please open issues or submit pull requests on GitHub.

### License

See the [LICENSE]("./LICENSE") file for details.