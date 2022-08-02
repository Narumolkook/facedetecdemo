import 'package:test/camera.services.dart';
// import 'package:test/ml_services.dart';
import 'package:test/face_detector.services.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setupServices() {
  locator.registerLazySingleton<CameraService>(() => CameraService());
  locator.registerLazySingleton<FaceDetectorService>(() => FaceDetectorService());
  // locator.registerLazySingleton<MLService>(() => MLService());
}
