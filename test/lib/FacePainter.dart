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
 
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.face != face;
  }
  
}

