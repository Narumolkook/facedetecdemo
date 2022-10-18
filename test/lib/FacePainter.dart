import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter/material.dart';

class FacePainter extends CustomPainter {
  FacePainter({required this.imageSize, required this.face});
  final Size imageSize;
  Face? face;
  @override
  void paint(Canvas canvas, Size size) {
    if (face == null) return;

    Paint paint ;

    if (this.face!.headEulerAngleY! > 3 || this.face!.headEulerAngleY! < -3) {
      paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5.0
        ..color = Colors.red;
    } else {
      paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5.0
        ..color = Colors.green;
    }

    Offset center = Offset(size.width/2, size.height/2);
    Rect rect = Rect.fromCenter(center: center, width: size.width/2, height: size.height/2);
    canvas.drawOval(rect, paint);

    // scaleX = size.width / imageSize.width;
    // scaleY = size.height / imageSize.height;

    // canvas.drawRRect(
    //     _scaleRect(
    //         rect: face!.boundingBox,
    //         imageSize: imageSize,
    //         // widgetSize: size,
    //         scaleX: scaleX ?? 1,
    //         scaleY: scaleY ?? 1),
    //     paint);
    //     print("---------------------------------------------------------------------------------------------------------------------------------------");
    //     print(_scaleRect(rect: face!.boundingBox, imageSize: imageSize));
        
        
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.face != face;
  }
  
}

// RRect _scaleRect(
//     {required Rect rect,
//     required Size imageSize,
//     // required Size widgetSize,
//     double scaleX = 1,
//     double scaleY = 1
//     }) {
//       // LTRBR(ซ้าย, บน, ขวา, ล่าง)
//   return RRect.fromLTRBR(
//       (rect.left.toDouble() * scaleX ),
//       (rect.top.toDouble() * scaleY),
//       ((rect.right.toDouble() * scaleX) + (rect.left.toDouble() * scaleX)),
//       ((rect.bottom.toDouble() * scaleX) + (rect.top.toDouble() * scaleX)),
//       // (rect.left.toDouble() * scaleX),
//       // (rect.top.toDouble() * scaleY),
//       // (rect.right.toDouble() * scaleX ),
//       // (rect.bottom.toDouble() * scaleX),
//       Radius.circular(10)
      
//       );
    
// }
