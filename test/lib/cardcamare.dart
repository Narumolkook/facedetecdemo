import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:image/image.dart' as IMG;
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter/material.dart';
import 'package:test/face_detector.services.dart';
import 'package:test/camera.services.dart';
import 'package:test/locator.dart';
import 'package:test/camera_header.dart';
import 'package:test/FacePainter.dart';

import 'package:test/pictureScreen.dart';

class Cardcam extends StatefulWidget {
  final String imagePath;
  const Cardcam({super.key, required this.imagePath});


  @override
  CardcamState createState() => CardcamState();
}

class CardcamState extends State<Cardcam> {
  String? imagePath;
  Face? faceDetected;
  Size? imageSize;

  bool _detectingFaces = false;
  bool pictureTaken = false;

  bool _initializing = false;

  bool _saving = false;
  bool _bottomSheetVisible = false;

  // service injection
  FaceDetectorService _faceDetectorService = locator<FaceDetectorService>();
  CameraService _cameraService = locator<CameraService>();
 

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }

  _start() async {
    setState(() => _initializing = true);
    await _cameraService.initialize();
    setState(() => _initializing = false);

    _frameFaces();
  }


  Future<bool> onShot() async {
    if (faceDetected == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('No face detected!'),
          );
        },
      );
      return false;
    } else {
      _saving = true;
     
      XFile? image = await _cameraService.takePicture();
      
      var dir = Directory.systemTemp.createTempSync();
      File temp = File("${dir.path}/cropPath");
      final File croppedImage2 = await ImageProcessor.cropSquareWithCoordinates(
          image!.path, temp.path, 280, 360, 110, 150, true);

      
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(
            // Pass the automatically generated path to
            // the DisplayPictureScreen widget.
            imagePath1: croppedImage2.path,
            imagePath2: widget.imagePath
          ),
        ),
      );

      setState(() {
        _bottomSheetVisible = true;
        pictureTaken = true;
      });

      return true;
    }
  }

  _frameFaces() {
    imageSize = _cameraService.getImageSize();

    _cameraService.cameraController?.startImageStream((image) async {
      if (_cameraService.cameraController != null) {
        if (_detectingFaces) return;

        _detectingFaces = true;

        try {
          await _faceDetectorService.detectFacesFromImage(image);

          if (_faceDetectorService.faces.isNotEmpty) {
            setState(() {
              faceDetected = _faceDetectorService.faces[0];
            });
            
          } else {
            setState(() {
              faceDetected = null;
            });
          }

          _detectingFaces = false;
        } catch (e) {
          print(e);
          _detectingFaces = false;
        }
      }
    });
  }

  _onBackPressed() {
    Navigator.of(context).pop();
  }

  _reload() {
    setState(() {
      _bottomSheetVisible = false;
      pictureTaken = false;
    });
    this._start();
  }

  @override
  Widget build(BuildContext context) {
    final double mirror = math.pi;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    late Widget body;
    if (_initializing) {
      body = Center(
        child: CircularProgressIndicator(),
      );
    }

    if (!_initializing && !pictureTaken) {
      body = Transform.scale(
        scale: 1.0,
        child: AspectRatio(
          aspectRatio: MediaQuery.of(context).size.aspectRatio,
          child: OverflowBox(
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Container(
                width: width,
                height:
                    width * _cameraService.cameraController!.value.aspectRatio,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    CameraPreview(_cameraService.cameraController!),
                    CustomPaint(
                      painter: DrawPaint(
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          body,
          CameraHeader(
            "Card detector",
            onBackPressed: _onBackPressed,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onShot,
        child: Icon(
          Icons.camera,
          color: Colors.white,
          size: 29,
        ),
        backgroundColor: Colors.black,
        tooltip: 'Capture Picture',
        elevation: 5,
        splashColor: Colors.grey,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class ImageProcessor {
  static Future<File> cropSquareWithCoordinates(
    String srcFilePath,
    String destFilePath,
    int x,
    int y,
    int width,
    int height,
    bool flip,
  ) async {
    var bytes = await File(srcFilePath).readAsBytes();
    IMG.Image src = IMG.decodeImage(bytes) as IMG.Image;

    IMG.Image destImage = IMG.copyCrop(src, x, y, width, height);

    if (flip) {
      destImage = IMG.flipHorizontal(destImage);
    }

    var jpg = IMG.encodeJpg(destImage);
    var file = File(destFilePath);
    await file.writeAsBytes(jpg);

    return file;
  }
}
