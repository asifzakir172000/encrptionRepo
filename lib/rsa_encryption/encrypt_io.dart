import 'dart:io';

import 'package:encryption_file/rsa_encryption/algorithms/rsa.dart';
import 'package:pointycastle/asymmetric/api.dart';

Future<T> parseKeyFromFile<T extends RSAAsymmetricKey>(String filename) async {
  final file = File(filename);
  final key = await file.readAsString();
  final parser = RSAKeyParser();
  print("public key ${parser.parse(key)}");
  return parser.parse(key) as T;
}

T parseKeyFromFileSync<T extends RSAAsymmetricKey>(String filename) {
  final file = File(filename);
  final key = file.readAsStringSync();
  final parser = RSAKeyParser();
  return parser.parse(key) as T;
}
