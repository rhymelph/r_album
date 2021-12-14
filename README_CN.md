# r_album
[![pub package](https://img.shields.io/pub/v/r_album.svg)](https://pub.dartlang.org/packages/r_album)

![](screen/r_album.png)


Flutter 图片或者视频保存到相册插件，支持Android和IOS.


## 如何使用

- 1.在`./pubspec.yaml`文件下添加插件

```dart
dependencies:
  r_album: lastVersion

```

- 2.导入包

```dart
import 'package:r_album/r_album.dart';
```

- 3.创建专辑

```dart
await RAlbum.createAlbum("你的专辑名字");
```

- 4.将图片或视频添加到专辑中（添加后即可在系统相册中找到）

```dart
await RAlbum.saveAlbum("你的专辑名",["文件路径1","文件路径2",...]);
```

## end

- 欢迎关注微信订阅号：`Dart客栈`

- 交流群：29380453

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