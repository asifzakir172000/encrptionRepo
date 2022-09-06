import 'dart:convert' as convert;
import 'dart:io';
import 'package:cryptography/cryptography.dart' as cryptography;
import 'package:encryption_file/rsa_encryption/algorithms/rsa.dart';
import 'package:encryption_file/rsa_encryption/encrypt_io.dart';
import 'package:encryption_file/rsa_encryption/encrypter.dart';
import 'package:encryption_file/utils/service.dart';
import 'package:pointycastle/asymmetric/api.dart';

class EncryptUtils {

  EncryptUtils._internal();
  static final EncryptUtils _instance = EncryptUtils._internal();
  static EncryptUtils get instance => _instance;


  final plainText = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit';
  final publicKey = '''-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCsIL91oVsuy/3VnNfdgClJ5d/x
cfgmu4OE44lRxhi6jy25awQ5ZiSKSZI8X2pAYvAvj1Duv7/aeipU4w+rQIkXgoZG
3eMbu5hhLHnCgNDtfI0MWmoOwZ7AcbLZPc4j3PGQKjaGTVz+XFFvTYls1Reo38ON
03N3yqHEmIa57uvvSwIDAQAB
-----END PUBLIC KEY-----''';

// final publicKey = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCsIL91oVsuy/3VnNfdgClJ5d/xcfgmu4OE44lRxhi6jy25awQ5ZiSKSZI8X2pAYvAvj1Duv7/aeipU4w+rQIkXgoZG3eMbu5hhLHnCgNDtfI0MWmoOwZ7AcbLZPc4j3PGQKjaGTVz+XFFvTYls1Reo38ON03N3yqHEmIa57uvvSwIDAQAB";
  
  //creating dynamic AES256 key
  getSecretKey() async {
    final algorithm = cryptography.AesGcm.with256bits();
    final secretKey = await algorithm.newSecretKey();
    return secretKey;
  }

  //creating dynamic IV
  List<int> getIv({key}){
    var tagIv = <int>[];
    for(var i=0; i < key.length ; i++){
      tagIv.add(key[i]); 
      if(i == 11){
        break;
      }
    }
    return tagIv;
  }

  //message encryption logic 
  // encyptionFunc({msg, key}){
  //   var iv = getIv(key: key);
  //   final encrypter = Encrypter(AES(key));
  //   return encrypter.encrypt(msg, iv: iv);
  // }

  //covert to base64
  base64({encryptText}){
    return encryptText.base64;
  }

  //message decryption logic 
  // decyptionFunc({msg, key}){
  //   var iv = getIv(key: key);
  //   final encrypter = Encrypter(AES(key));
  //   return encrypter.decrypt(msg, iv: iv);
  // }

  Future<T> parseKeyFromString<T extends RSAAsymmetricKey>(String key) async {
  final parser = RSAKeyParser();
  return parser.parse(key) as T;
}

  //key encryption logic with RSA 
  encryptSecretKey({keys}) async {
    // var result = await rsa.RSA.encryptPKCS1v15(keys, publicKey);
    // return result;
    final result = await parseKeyFromString<RSAPublicKey>(publicKey);
    // final result = await parseKeyFromFile<RSAPublicKey>("test/public.pem");
    // final encrypter = Encrypter(enc.RSA(publicKey: result, encoding: enc.RSAEncoding.OAEP, digest: ));
     final encrypter = Encrypter(
         RSA(
           publicKey: result,
           encoding: RSAEncoding.OAEP,
           digest: RSADigest.SHA256,
         )
     );
    // final signer = Signer(RSASigner(RSASignDigest.SHA256, publicKey: result, ));
    final encrypted = encrypter.encryptBytes(keys);
    // final encrypted = signer.sign(keys).base64;
    return encrypted.base64;
  }


  newEnc({msg}) async {
    print('msg: $msg');
    final algorithm = cryptography.AesGcm.with256bits();
    final secretKey = await algorithm.newSecretKey();
    final secretKeyBytes = await secretKey.extractBytes(); 
    List<int> nonce = getIv(key: secretKeyBytes);
    final clearText = convert.utf8.encode(msg);
    print('clearText: $clearText');
    final secretBox = await algorithm.encrypt(
      clearText,
      secretKey: secretKey,
      nonce: nonce,
    );

    var encyptedData = convert.base64.encode(secretBox.cipherText);

    print('encyptedData: ${convert.base64.encode(secretBox.cipherText)}');
    print('mac: ${secretBox.mac}');

    // var decyptData = convert.base64.decode(encyptedData);
    //
    // final decrypt = await algorithm.decrypt(
    //   cryptography.SecretBox(decyptData, nonce: nonce, mac: secretBox.mac),
    //   secretKey: secretKey
    // );
    //
    // String encoded = convert.utf8.decode(decrypt);
    // print('decrypt: $encoded');

    var eKey = await EncryptUtils.instance.encryptSecretKey(keys: secretKeyBytes);
    // 6. pass your encrypted json and key to api
    ApiClient.instance.myRepositoryMethod(encyptedData, eKey);
    
  }

}