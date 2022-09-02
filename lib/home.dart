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
  var key;
  var iv;

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
                key = EncryptUtils.instance.getSecretKey();
                iv = EncryptUtils.instance.getIv();
                debugPrint("Key ${key.base64}");
                debugPrint("iv ${iv.base64}");

                setState(() {
                    // Map<String,String> body = {"username": "8268270311", "pin":"0000"};
                    Map<String,dynamic> body = {"companyid": 1, "version":1};
                    var jsonEncod = jsonEncode(body);
                    enc = EncryptUtils.instance.encyptionFunc(msg: jsonEncod.toString(), iv: iv, key: key);
                    debugPrint("Encrypt ${enc.base64}");
                });
                
                var eKey = await EncryptUtils.instance.encryptSecretKey(keys: key.toString());
                debugPrint("Encrypt Key $eKey");
                ApiClient.instance.myRepositoryMethod(enc.base64, eKey);

              },
            ),
            MaterialButton(
              child: const Text('Decrypt Data'),
              onPressed: () {
               
               if(key != null && iv != null){
                debugPrint("Key ${key.base64}");
                debugPrint("iv ${iv.base64}");
                setState(() {
                  var de = EncryptUtils.instance.decyptionFunc(msg: enc, iv: iv, key: key);
                  debugPrint("Decrypt $de");
               });
               }
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