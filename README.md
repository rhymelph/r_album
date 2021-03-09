# r_album
[![pub package](https://img.shields.io/pub/v/r_album.svg)](https://pub.dartlang.org/packages/r_album)

![](screen/r_album.png)

[中文](README_CN.md)

A  Flutter Plugin about image or video file save in album ,support Android and IOS.


## How to Use

- 1.add this in `pubspec.yaml`.

```dart
dependencies:
  r_album: lastVersion

```

- 2.import it

```dart
import 'package:r_album/r_album.dart';
```

- 3.create a new album.

```dart
bool isSuccess = await RAlbum.createAlbum("your album name");
```

- 4.save image or video file in album, use it.

```dart
bool isSuccess = await RAlbum.saveAlbum("your album name",["file1","file2",...]);
```

