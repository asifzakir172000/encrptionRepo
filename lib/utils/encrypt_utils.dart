
import 'dart:io';

import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt_io.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:path_provider/path_provider.dart';

class EncryptUtils {

  EncryptUtils._internal();
  static final EncryptUtils _instance = EncryptUtils._internal();
  static EncryptUtils get instance => _instance;


  final plainText = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit';
  final key = Key.fromLength(32);
  final iv = IV.fromLength(8);

  getSecretKey(){
    return Key.fromLength(32);
  }


  encyptionFunc({msg}){
    final encrypter = Encrypter(AES(key));
    print(encrypter.encrypt(msg, iv: iv).base64);
    return encrypter.encrypt(msg, iv: iv);
  }

  base64({encryptText}){
    return encryptText.base64;
  }

  decyptionFunc({msg}){
    final encrypter = Encrypter(AES(key));
    return encrypter.decrypt(msg, iv: iv);
  }

  encryptSecretKey({msg}) async {
    final publicKey = await parseKeyFromFile<RSAPublicKey>('D:/aiolos/flutter practies pro/encryption_file/lib/public.pem');
    final encrypter = Encrypter(RSA(publicKey: publicKey));
    print("key ${encrypter.encrypt(msg)}");
    return encrypter.encrypt(msg);
  }

}