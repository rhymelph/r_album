import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:r_album/r_album.dart';
import 'package:r_album_example/video_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File _file;
  bool _isSaving;

  bool isClickVideo;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: _isSaving == true
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: <Widget>[
                  _buildPickedImage(),
                  _buildImagePickerButton(),
                  _buildVideoPickerButton(),
                  _buildSaveToAlbumButton(),
                  _buildCreateAlbumButton(),
                ],
              ),
      ),
    );
  }

  Widget _buildPickedImage() {
    return Container(
      margin: EdgeInsets.all(16),
      height: 300.0,
      child: isClickVideo != null
          ? isClickVideo
              ? VideoWidget(
                  file: _file,
                )
              : Image.file(
                  _file,
                  fit: BoxFit.fill,
                )
          : Center(
              child: Container(
                child: Text("No selected image or video"),
              ),
            ),
      decoration: isClickVideo != null
          ? null
          : BoxDecoration(border: Border.all(width: 1)),
    );
  }

  Widget _buildImagePickerButton() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            tooltip: 'select image from camera',
            icon: Icon(Icons.camera_alt),
            onPressed: () async {
              var image =
                  await ImagePicker.pickImage(source: ImageSource.camera);
              if (image != null) {
                isClickVideo = false;
                setState(() {
                  _file = image;
                });
              }
            },
          ),
          IconButton(
            tooltip: 'select image from gallery',
            icon: Icon(Icons.folder),
            onPressed: () async {
              var image =
                  await ImagePicker.pickImage(source: ImageSource.gallery);
              if (image != null) {
                isClickVideo = false;
                setState(() {
                  _file = image;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPickerButton() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            tooltip: 'select video from camera',
            icon: Icon(Icons.videocam),
            onPressed: () async {
              var video =
                  await ImagePicker.pickVideo(source: ImageSource.camera);
              if (video != null) {
                isClickVideo = true;
                setState(() {
                  _file = video;
                });
              }
            },
          ),
          IconButton(
            tooltip: 'select video from gallery',
            icon: Icon(Icons.folder),
            onPressed: () async {
              var video =
                  await ImagePicker.pickVideo(source: ImageSource.gallery);
              if (video != null) {
                isClickVideo = true;
                setState(() {
                  _file = video;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSaveToAlbumButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: RaisedButton(
        color: Colors.blue,
        textColor: Colors.white,
        child: Text("Save to album"),
        onPressed: () async {
          setState(() {
            _isSaving = true;
          });
          if (_file != null) {
            if(await canReadStorage()){

              await RAlbum.saveAlbum(
                  filePaths: [_file.path], albumName: "test_album_saver2");
              setState(() {
                _isSaving = false;
              });
            }
          } else {
            setState(() {
              _isSaving = false;
            });
          }
        },
      ),
    );
  }
  Future<bool> canReadStorage() async {
    if(Platform.isIOS) return true;
    var status = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (status != PermissionStatus.granted) {
      var future = await PermissionHandler()
          .requestPermissions([PermissionGroup.storage]);
      for (final item in future.entries) {
        if (item.value != PermissionStatus.granted) {
          return false;
        }
      }
    } else {
      return true;
    }
    return true;
  }

  Widget _buildCreateAlbumButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: RaisedButton(
        color: Colors.blue,
        textColor: Colors.white,
        child: Text("Create a album named MyTestAlbum"),
        onPressed: () async {
          if(await canReadStorage()){
            setState(() {
              _isSaving = true;
            });
            await RAlbum.createAlbum(albumName: "MyTestAlbum");
            setState(() {
              _isSaving = false;
            });
          }

        },
      ),
    );
  }
}
