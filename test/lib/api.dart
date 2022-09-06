import 'package:flutter/material.dart';
import 'dart:io';

class ApiService extends StatefulWidget {
  const ApiService({Key? key}) : super(key: key);

  @override
  State<ApiService> createState() => _ApiServiceState();
}

class _ApiServiceState extends State<ApiService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('api'),
      ),
    );
  }
}