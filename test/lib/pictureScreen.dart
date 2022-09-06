import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:math' as math;
// import 'package:gallery_saver/gallery_saver.dart';

import 'package:test/sign-up.dart';
import 'package:test/api.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      // body: Center(
      //   child: Container(
      //     width: 480,
      //     height: 720,
      //     child: Transform(
      //       alignment: Alignment.center,
      //       transform: Matrix4.rotationY(math.pi),
      //       child: FittedBox(
      //         fit: BoxFit.cover,
      //         child: Image.file(File(imagePath)),
      //       ),
      //     ),
      //     padding: const EdgeInsets.all(10),
      //   ),

      // ),

      // floatingActionButton: FloatingActionButton(onPressed: () {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => const SignUp()),
      //       );
      //     },
      // tooltip: 'picture',
      // child: const Text('back'),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: 480,
              height: 720,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Image.file(File(imagePath)),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUp()),
                    );
                  },
                  child:
                      const Text('Try Again', style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                  child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ApiService()),
                  );
                },
                child: const Text(
                  'Next',
                  style: TextStyle(fontSize: 18)
                  ,
                ),
              ))
            ],
          )
        ],
      ),
    );
  }
}
