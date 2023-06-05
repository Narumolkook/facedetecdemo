import 'dart:io';
import 'dart:math' as math;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:test/home.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath1;
  final String imagePath2;

  const DisplayPictureScreen(
      {Key? key, required this.imagePath1, required this.imagePath2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: Center(
        child: FutureBuilder<Data>(
          future: postimage(imagePath1, imagePath2),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.file(
                          File(imagePath1),
                          width: 150,
                          height: 150,
                        ),
                        SizedBox(width: 20),
                        Image.file(File(imagePath2), width: 150, height: 150),
                      ],
                    ),
                    SizedBox(height: 100),
                    Text(
                      snapshot.data!.score,
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 150),
                    // TextButton(
                    //   onPressed: () {
                    //     Navigator.pop(
                    //         context); // Navigate back to the previous screen (home screen)
                    //   },
                    //   child: Text('Go Back'),
                    // ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

Future<Data> postimage(String path1, String path2) async {
  //call vam api
  //กำหนดไฟล์ที่จะอัปโหลด
  //สร้าง [MultipartFile] ใหม่จากพาธไปยังไฟล์บนดิสก์
  var fileA = await http.MultipartFile.fromPath(
    'ImageA', //ตัวแปรที่ api req
    path1, // path ภาพ
  );
  var fileB = await http.MultipartFile.fromPath(
    'ImageB', //ตัวแปรที่ api req
    path2, // path ภาพ
  );
  print("---- fileA and fileB ----");
  print(fileA);
  print(fileB);

  //กำหนด url ของ api
  final uri = Uri.parse('http://58.137.58.164:8500/CompareFace');
  var request = http.MultipartRequest('POST', uri);

  print("---- request ----");
  print(request);
  request.files.add(fileA);
  request.files.add(fileB);

  var response = await request.send();
  var responseString = await response.stream.bytesToString();

  print("_____________API response_____________");

  if (response.statusCode == 200) {
    print('Uploaded!');
    // response.stream.transform(utf8.decoder).listen((value) {
    //   debugPrint(value);
    // });
    return Data.fromJson(jsonDecode(responseString));
  } else {
    throw Exception('Failed to upload.');
  }
}

class Data {
  final bool success;
  final String score;
  Data({
    required this.success,
    required this.score,
  });
  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(success: json['success'], score: json['score'].toString());
}
