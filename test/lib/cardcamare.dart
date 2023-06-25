import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:image/image.dart' as IMG;
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter/material.dart';
import 'package:test/face_detector.services.dart';
// import 'package:test/ml_services.dart';
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
  // MLService _mlService = locator<MLService>();

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
      final File croppedImage2 =
          await ImageProcessor.cropSquare(image!.path, temp.path, false)
              as File;

      
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
      // GallerySaver.saveImage(imagePath!);
      // GallerySaver.saveImage(imagePath.path).then((String path);

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
            // if (_saving) {
            //   _mlService.setCurrentPrediction(image, faceDetected);
            //   setState(() {
            //     _saving = false;
            //   });
            // }
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

    // if (!_initializing && pictureTaken) {
    // body = Center(
    //   child: Container(
    //     width: 480,
    //     height: 720,
    //     child: Transform(
    //         alignment: Alignment.center,
    //         transform: Matrix4.rotationY(mirror),
    //         child: FittedBox(
    //           fit: BoxFit.cover,
    //           child: Image.file(File(imagePath!)),
    //         ),
    //         ),
    //   ),
    // );
    //   print(
    //       "IMAGE PATH --------------------------------------------------------------------------------------------");
    //   print(imagePath);
    //   print(width);
    //   print(height);
    // }

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
      print(
          "================================================================================================================================================");
      print(imageSize);
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
  static Future cropSquare(
      String srcFilePath, String destFilePath, bool flip) async {
    var bytes = await File(srcFilePath).readAsBytes();
    IMG.Image src = IMG.decodeImage(bytes) as IMG.Image;

    var cropSize = math.min(src.width, src.height);
    print(cropSize);

    int offsetX = (src.width - math.min(src.width, src.height)) ~/ 2;
    int offsetY = (src.height - math.min(src.width, src.height)) ~/ 2;
    print(offsetX);
    print(offsetY);

    IMG.Image destImage =
        IMG.copyCrop(src, offsetX, offsetY, cropSize, cropSize);

    if (flip) {
      destImage = IMG.flipVertical(destImage);
    }

    var jpg = IMG.encodeJpg(destImage);
    return await File(destFilePath).writeAsBytes(jpg);
  }
}
