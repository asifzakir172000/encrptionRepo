import 'package:encryption_file/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String encryptedData = '';
  String decryptedData = '';

  static const encryptionChannel = MethodChannel('enc/dec');

  Future<void> encryptData(String encrypted, String key) async {
    var myJson = {"name": "bezkoder", "age": 30};
    try {
      var result = await encryptionChannel.invokeMethod(
        'encrypt',
        {
          'data': myJson.toString(),
          'key': key,
        },
      );
      debugPrint('RETURNED FROM PLATFORM');
      debugPrint(result);
      setState(() {
        encryptedData = result;
      });
    } on PlatformException catch (e) {
      debugPrint('${e.message}');
    }
  }

  Future<void> decryptData(String encrypted, String key) async {
  
    try {
      var result =  await encryptionChannel.invokeMethod('decrypt', {
        'data': encrypted,
        'key': key,
      });
      debugPrint('RETURNED FROM PLATFORM');
      debugPrint(result);
      setState(() {
        decryptedData = result;
      });
    } on PlatformException catch (e) {
      debugPrint('${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MaterialButton(
              child: const Text('Encrypt Data'),
              onPressed: () {
                encryptData('data to be encrypted', '16 character long key');
              },
            ),
            MaterialButton(
              child: const Text('Decrypt Data'),
              onPressed: () {
                decryptData('data to be decrypted', '16 character long key');
                // same key used to encrypt
              },
            ),
            Text(encryptedData),
            Text(decryptedData),
          ],
        ),
      ),
    );
  }
}
