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

## License
    Copyright 2021 rhymelph

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

           http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.