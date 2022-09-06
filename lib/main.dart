import 'package:encryption_file/home.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Secure App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const EncryptionScreen(),
    );
  }
}
