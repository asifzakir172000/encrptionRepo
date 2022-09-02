import 'package:encrypt/encrypt.dart';
import 'package:fast_rsa/fast_rsa.dart' as rsa;

class EncryptUtils {

  EncryptUtils._internal();
  static final EncryptUtils _instance = EncryptUtils._internal();
  static EncryptUtils get instance => _instance;


  final plainText = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit';
  final encryptionKey = '''-----BEGIN RSA PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCsIL91oVsuy/3VnNfdgClJ5d/xcfgmu4OE44lRxhi6jy25awQ5ZiSKSZI8X2pAYvAvj1Duv7/aeipU4w+rQIkXgoZG3eMbu5hhLHnCgNDtfI0MWmoOwZ7AcbLZPc4j3PGQKjaGTVz+XFFvTYls1Reo38ON03N3yqHEmIa57uvvSwIDAQAB
-----END RSA PUBLIC KEY-----''';
  
  //creating dynamic AES256 key
  getSecretKey(){
    return Key.fromLength(32);
  }

  //creating dynamic IV
  getIv(){
    return IV.fromLength(16);
  }

  //message encryption logic 
  encyptionFunc({msg, key, iv}){
    final encrypter = Encrypter(AES(key));
    return encrypter.encrypt(msg, iv: iv);
  }

  //covert to base64
  base64({encryptText}){
    return encryptText.base64;
  }

  //message decryption logic 
  decyptionFunc({msg, key, iv}){
    final encrypter = Encrypter(AES(key));
    return encrypter.decrypt(msg, iv: iv);
  }

  //key encryption logic with RSA 
  encryptSecretKey({keys}) async {
    var result = await rsa.RSA.encryptPKCS1v15(keys, encryptionKey);
    return result;
  }

}