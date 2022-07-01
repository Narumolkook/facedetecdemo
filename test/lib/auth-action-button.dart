import 'app_button.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart';
import '../home.dart';
import 'package:test/ml_services.dart';
import 'package:test/camera.services.dart';
import 'package:test/locator.dart';

class AuthActionButton extends StatefulWidget {
  AuthActionButton(
      {Key? key,
      required this.onPressed,
      required this.isLogin,
      required this.reload});
  final Function onPressed;
  final bool isLogin;
  final Function reload;
  @override
  _AuthActionButtonState createState() => _AuthActionButtonState();
}

class _AuthActionButtonState extends State<AuthActionButton> {
  final MLService _mlService = locator<MLService>();
  final CameraService _cameraService = locator<CameraService>();

  Future onTap() async {
    // try {
    //   bool faceDetected = await widget.onPressed();
    //   PersistentBottomSheetController bottomSheetController =
    //         Scaffold.of(context)
    //             .showBottomSheet((context) => signSheet(context));
    //     bottomSheetController.closed.whenComplete(() => widget.reload());
    // } catch (e) {
    //   print(e);
    // }
    var faceDetected = await widget.onPressed();
  }

  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue[200],
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.blue.withOpacity(0.1),
              blurRadius: 1,
              offset: Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        width: MediaQuery.of(context).size.width * 0.8,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'CAPTURE',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(Icons.camera_alt, color: Colors.white)
          ],
        ),
      ),
    );
  }


  @override
  void dispose() {
    super.dispose();
  }
}
