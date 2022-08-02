import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:test/image_converter.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as imglib;
import 'package:path_provider/path_provider.dart';

class MLService {
  Interpreter? _interpreter;
  double threshold = 0.5;

  // List _predictedData = [];
  // List get predictedData => _predictedData;

  Future initialize() async {
    // late Delegate delegate;
    try {
      var interpreterOptions = InterpreterOptions()..useNnApiForAndroid = true;
      final interpreter = await Interpreter.fromAsset('model.tflite',
          options: interpreterOptions);

      // if (Platform.isAndroid) {
      //   delegate = GpuDelegateV2(
      //     options: GpuDelegateOptionsV2(
      //       isPrecisionLossAllowed: false,
      //       inferencePreference: TfLiteGpuInferenceUsage.fastSingleAnswer,
      //       inferencePriority1: TfLiteGpuInferencePriority.minLatency,
      //       inferencePriority2: TfLiteGpuInferencePriority.auto,
      //       inferencePriority3: TfLiteGpuInferencePriority.auto,
      //     ),
      //   );
      // } else if (Platform.isIOS) {
      //   delegate = GpuDelegate(
      //     options: GpuDelegateOptions(
      //         allowPrecisionLoss: true,
      //         waitType: TFLGpuDelegateWaitType.active),
      //   );
      // }
      // var interpreterOptions = InterpreterOptions()..addDelegate(delegate);

      // this._interpreter = await Interpreter.fromAsset('model.tflite',
      //     options: interpreterOptions);

    } catch (e) {
      print('Failed to load model.');
      print(e);
    }
  }

  void setCurrentPrediction(CameraImage cameraImage, Face? face) {
    if (_interpreter == null) throw Exception('Interpreter is null');
    if (face == null) throw Exception('Face is null');
    List input = _preProcess(cameraImage, face);

    input = input.reshape([1, 112, 112, 3]);
    
    List output = List.generate(1, (index) => List.filled(192, 0));

    this._interpreter?.run(input, output);
    output = output.reshape([192]);

    // print(input.runtimeType);

    // this._predictedData = List.from(output);
  }

  

  List _preProcess(CameraImage image, Face faceDetected) {
    imglib.Image croppedImage = _cropFace(image, faceDetected);
    imglib.Image img = imglib.copyResizeCropSquare(croppedImage, 112);

    Float32List imageAsList = imageToByteListFloat32(img);
    return imageAsList;
  }

  imglib.Image _cropFace(CameraImage image, Face faceDetected) {
    imglib.Image convertedImage = _convertCameraImage(image);
    double x = faceDetected.boundingBox.left;
    double y = faceDetected.boundingBox.top;
    double w = faceDetected.boundingBox.width;
    double h = faceDetected.boundingBox.height;
    return imglib.copyCrop(
        convertedImage, x.round(), y.round(), w.round(), h.round());
  }

  imglib.Image _convertCameraImage(CameraImage image) {
    var img = convertToImage(image); //image_con
    var img1 = imglib.copyRotate(img, -90);
    return img1;
  }

  Float32List imageToByteListFloat32(imglib.Image image) {
    var convertedBytes = Float32List(1 * 112 * 112 * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;

    for (var i = 0; i < 112; i++) {
      for (var j = 0; j < 112; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (imglib.getRed(pixel) - 128) / 128;
        buffer[pixelIndex++] = (imglib.getGreen(pixel) - 128) / 128;
        buffer[pixelIndex++] = (imglib.getBlue(pixel) - 128) / 128;
      }
    }
    return convertedBytes.buffer.asFloat32List();
  }

  

  // void setPredictedData(value) {
  //   this._predictedData = value;
  // }
//   Future<String> getFilePath() async {
//     Directory appDocumentsDirectory = await getApplicationDocumentsDirectory(); // 1
//     String appDocumentsPath = appDocumentsDirectory.path; // 2
//     String filePath = '$appDocumentsPath/demoTextFile.txt'; // 3

//     return filePath;
//   }

//   void saveFile() async {
//     File file = File(await getFilePath()); // 1
//     file.writeAsString("This is my demo text that will be saved to : demoTextFile.txt"); // 2
//   }

//   void readFile() async {
//     File file = File(await getFilePath()); // 1
//     String fileContent = await file.readAsString(); // 2

//     print('File Content: $fileContent');
// }

  dispose() {}
}
