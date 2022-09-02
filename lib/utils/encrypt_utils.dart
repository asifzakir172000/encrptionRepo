
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:fast_rsa/fast_rsa.dart' as rsa;

class EncryptUtils {

  EncryptUtils._internal();
  static final EncryptUtils _instance = EncryptUtils._internal();
  static EncryptUtils get instance => _instance;


  final plainText = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit';
  final encryptionKey = '''-----BEGIN RSA PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCsIL91oVsuy/3VnNfdgClJ5d/xcfgmu4OE44lRxhi6jy25awQ5ZiSKSZI8X2pAYvAvj1Duv7/aeipU4w+rQIkXgoZG3eMbu5hhLHnCgNDtfI0MWmoOwZ7AcbLZPc4j3PGQKjaGTVz+XFFvTYls1Reo38ON03N3yqHEmIa57uvvSwIDAQAB
-----END RSA PUBLIC KEY-----''';
  
  getSecretKey(){
    return Key.fromLength(32);
  }

  getIv(){
    return IV.fromLength(16);
  }

  encyptionFunc({msg, key, iv}){
    final encrypter = Encrypter(AES(key));
    return encrypter.encrypt(msg, iv: iv);
  }

  base64({encryptText}){
    return encryptText.base64;
  }

  decyptionFunc({msg, key, iv}){
    final encrypter = Encrypter(AES(key));
    return encrypter.decrypt(msg, iv: iv);
  }

  encryptSecretKey({keys}) async {
    var result = await rsa.RSA.encryptPKCS1v15(keys, encryptionKey);
    return result;
  }

}