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

class DrawPaint extends CustomPainter {
  bool? isFilled;
  DrawPaint({this.isFilled});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = Colors.grey;
    if (isFilled != null) {
      paint.style = PaintingStyle.fill;
    } else {
      paint.style = PaintingStyle.stroke;
    }
    paint.strokeWidth = 3;


    //draw id card
    RRect rRect = RRect.fromLTRBR(63, 220, 320, 410, Radius.circular(10));
    canvas.drawRRect(rRect, paint);
     //draw img id card
    RRect rrect = RRect.fromLTRBR(83, 300, 166, 390, Radius.circular(10));
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant DrawPaint oldDelegate) {
    return false;
  }
}

