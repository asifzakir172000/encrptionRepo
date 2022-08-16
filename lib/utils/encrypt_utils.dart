
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
  final iv = IV.fromLength(16);
  final encryptionKey = '''-----BEGIN RSA PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCsIL91oVsuy/3VnNfdgClJ5d/xcfgmu4OE44lRxhi6jy25awQ5ZiSKSZI8X2pAYvAvj1Duv7/aeipU4w+rQIkXgoZG3eMbu5hhLHnCgNDtfI0MWmoOwZ7AcbLZPc4j3PGQKjaGTVz+XFFvTYls1Reo38ON03N3yqHEmIa57uvvSwIDAQAB
-----END RSA PUBLIC KEY-----''';

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

  encryptSecretKey({key}) async {
    final publicKey = await parseKeyFromString<RSAPublicKey>(encryptionKey);
    final encrypter = Encrypter(RSA(publicKey: publicKey));
    // print("key ${encrypter.encrypt(msg)}");
    return encrypter.encrypt(key).base64;
  }

  Future<T> parseKeyFromString<T extends RSAAsymmetricKey>(String filename) async {
    final parser = RSAKeyParser();
    return parser.parse(filename) as T;
  }

}