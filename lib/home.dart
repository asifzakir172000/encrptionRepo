import 'dart:convert';

import 'package:encryption_file/utils/encrypt_utils.dart';
import 'package:encryption_file/utils/service.dart';
import 'package:flutter/material.dart';

class EncryptionScreen extends StatefulWidget {
  const EncryptionScreen({Key? key}) : super(key: key);

  @override
  State<EncryptionScreen> createState() => _EncryptionScreenState();
}

class _EncryptionScreenState extends State<EncryptionScreen> {

  String encryptedData = '';
  String decryptedData = '';
  var enc;

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
              onPressed: () async {
               setState(() {
                  enc = EncryptUtils.instance.encyptionFunc(msg: 'data to be encrypted');
                  encryptedData = enc.base64;
               });
               Map<String,String> body = {"username": "8268270311", "pin":"0000"};
               var jsonEncod = jsonEncode(body);
               var encyptRequest = EncryptUtils.instance.encyptionFunc(msg: jsonEncod.toString());
               print("encyptRequest: ${encyptRequest.base64}");
               var de = EncryptUtils.instance.decyptionFunc(msg: encyptRequest);
               print("decryptedData: $de");
              //ApiClient.instance.myRepositoryMethod(encyptRequest);
              final key = EncryptUtils.instance.getSecretKey();
              var sKey = await EncryptUtils.instance.encryptSecretKey(key: key.base64);
              print("sKey: ${sKey.base64}");

              },
            ),
            MaterialButton(
              child: const Text('Decrypt Data'),
              onPressed: () {
                setState(() {
                  decryptedData = EncryptUtils.instance.decyptionFunc(msg: enc);
               });
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