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

                //1. genrate key and iv
                // key = EncryptUtils.instance.getSecretKey();
                // iv = EncryptUtils.instance.getIv();
                // debugPrint("Key ${key.base64}");
                // debugPrint("iv ${iv.base64}");

                setState(() {
                    // 2. make your request
                    Map<String,String> body = {"companyid": "1", "version":"1"};
                    // 3. convert to jsonEncode
                    var jsonEncod = jsonEncode(body);
                    // 4. convert your jsonEncode request to string and pass to encryption with key and iv
                    // enc = EncryptUtils.instance.encyptionFunc(msg: jsonEncod.toString(), key: key);
                    EncryptUtils.instance.newEnc(msg: body.toString());
                    // debugPrint("new $newEnc");
                });
                
                // 5. Encryption your key with RSA encryption logic
                // var eKey = await EncryptUtils.instance.encryptSecretKey(keys: key.toString());

                // 6. pass your encrypted json and key to api
                // ApiClient.instance.myRepositoryMethod(enc.base64, eKey);

              },
            ),
            MaterialButton(
              child: const Text('Decrypt Data'),
              onPressed: () {
               
               if(key != null && iv != null){
                debugPrint("Key ${key.base64}");
                debugPrint("iv ${iv.base64}");
                setState(() {
                  // 7. decypt the response with same key and iv that you created for encryption
                  // var de = EncryptUtils.instance.decyptionFunc(msg: enc, key: key);
                  // debugPrint("Decrypt $de");
               });
               }

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