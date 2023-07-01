import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:image/image.dart' as IMG;
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter/material.dart';
import 'package:test/cardcamare.dart';
import 'package:test/face_detector.services.dart';
import 'package:test/camera.services.dart';
import 'package:test/locator.dart';
import 'package:test/camera_header.dart';
import 'package:test/FacePainter.dart';

import 'package:test/pictureScreen.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  String? imagePath;
  Face? faceDetected;
  Size? imageSize;

  bool _detectingFaces = false;
  bool pictureTaken = false;

  bool _initializing = false;

  bool _saving = false;
  bool _bottomSheetVisible = false;

  bool _isGreenBoxDetected = false;

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
      final File croppedImage =
          await ImageProcessor.cropSquare(image!.path, temp.path, false)
              as File;

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Cardcam(
            // Pass the automatically generated path to
            // the DisplayPictureScreen widget.
            imagePath: croppedImage.path,
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
            _isGreenBoxDetected = _isGreenBoxVisible(faceDetected);
          });

          if (_isGreenBoxDetected) {
            await onShot();
          }
        } else {
          setState(() {
            faceDetected = null;
            _isGreenBoxDetected = false;
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

bool _isGreenBoxVisible(Face? face) {
  if (face == null) return false;

  double headEulerAngleY = face.headEulerAngleY ?? 0.0;

  return (headEulerAngleY > -3 && headEulerAngleY < 3);
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
                      painter: FacePainter(
                          face: faceDetected, imageSize: imageSize!),
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
            "face detector",
            onBackPressed: _onBackPressed,
          )
        ],
      ),
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
