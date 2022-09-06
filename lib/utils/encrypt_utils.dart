import 'dart:convert' as convert;
import 'dart:io';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart' as cryptography;
import 'package:encryption_file/utils/service.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/export.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/pointycastle.dart';

class EncryptUtils {

  EncryptUtils._internal();
  static final EncryptUtils _instance = EncryptUtils._internal();
  static EncryptUtils get instance => _instance;


  final plainText = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit';
//   final publicKey = '''-----BEGIN PUBLIC KEY-----
// MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCsIL91oVsuy/3VnNfdgClJ5d/x
// cfgmu4OE44lRxhi6jy25awQ5ZiSKSZI8X2pAYvAvj1Duv7/aeipU4w+rQIkXgoZG
// 3eMbu5hhLHnCgNDtfI0MWmoOwZ7AcbLZPc4j3PGQKjaGTVz+XFFvTYls1Reo38ON
// 03N3yqHEmIa57uvvSwIDAQAB
// -----END PUBLIC KEY-----''';

final publicKey = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCsIL91oVsuy/3VnNfdgClJ5d/xcfgmu4OE44lRxhi6jy25awQ5ZiSKSZI8X2pAYvAvj1Duv7/aeipU4w+rQIkXgoZG3eMbu5hhLHnCgNDtfI0MWmoOwZ7AcbLZPc4j3PGQKjaGTVz+XFFvTYls1Reo38ON03N3yqHEmIa57uvvSwIDAQAB";
// final publicKey = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCzoN1rGpG4oIam1m2fup1ruY5enRGxF9KJtnhc2XZZoTn2mRz+oqFJEvgN0DsfNrjpAJRModM9qHFx4u2wEZgSjHvI2IgVp0t5R2Ji/v3bwwcYKy9MUhL6Qp24EYyi6awh8uK8BovNCM7IzWFOgBxTtOJ8oBUkko01QfIIG+uoAQIDAQAB";

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

  //covert to base64
  base64({encryptText}){
    return encryptText.base64;
  }

  Uint8List _processInBlocks(AsymmetricBlockCipher engine, Uint8List input) {
    final numBlocks = input.length ~/ engine.inputBlockSize +
        ((input.length % engine.inputBlockSize != 0) ? 1 : 0);

    final output = Uint8List(numBlocks * engine.outputBlockSize);

    var inputOffset = 0;
    var outputOffset = 0;
    while (inputOffset < input.length) {
      final chunkSize = (inputOffset + engine.inputBlockSize <= input.length)
          ? engine.inputBlockSize
          : input.length - inputOffset;

      outputOffset += engine.processBlock(
          input, inputOffset, chunkSize, output, outputOffset);

      inputOffset += chunkSize;
    }

    return (output.length == outputOffset)
        ? output
        : output.sublist(0, outputOffset);
  }

  ASN1Sequence _parseSequence(String keyTest) {
    final keyBytes = Uint8List.fromList(convert.base64.decode(keyTest));
    final asn1Parser = ASN1Parser(keyBytes);
    return asn1Parser.nextObject() as ASN1Sequence;
  }

  ASN1Sequence _pkcs8PublicSequence(ASN1Sequence sequence) {
    final ASN1Object bitString = sequence.elements![1];
    final bytes = bitString.valueBytes?.sublist(1);
    final parser = ASN1Parser(Uint8List.fromList(bytes!));

    return parser.nextObject() as ASN1Sequence;
  }

  RSAAsymmetricKey _parsePublic(String keyTest) {
    ASN1Sequence sequence = _pkcs8PublicSequence(_parseSequence(keyTest));
    final modulus = (sequence.elements![0] as ASN1Integer).integer;
    final exponent = (sequence.elements![1] as ASN1Integer).integer;

    return RSAPublicKey(modulus!, exponent!);
  }

  //key encryption logic with RSA 
  encryptSecretKey({keys}) async {
    final myPublicKey = _parsePublic(publicKey) as RSAPublicKey;
    final p = AsymmetricBlockCipher('RSA/NONE/OAEPWithSHA256AndMGF1Padding');
    p.init(true, PublicKeyParameter<RSAPublicKey>(myPublicKey));
    final result = _processInBlocks(p, keys);
    final encode = convert.base64.encode(result);
    return encode;
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

    var eKey = await encryptSecretKey(keys: secretKeyBytes);
    // 6. pass your encrypted json and key to api
    ApiClient.instance.myRepositoryMethod(encyptedData, eKey);
    
  }

}