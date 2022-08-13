

import 'dart:convert';

import 'package:http_certificate_pinning/http_certificate_pinning.dart';

class ApiClient {
  String fingerprint = "sha256/3SCU0lCY5I5XnQl8Cl4FENppDbRmlWnzX5e5Uj8lVsI=";
  List<String> certificateSHA256Fingerprints = [];
  String baseUrl = "https://posdemo.aiolos.solutions";

  ApiClient._internal();
  static final ApiClient _instance = ApiClient._internal();
  static ApiClient get instance => _instance;

  List<String> getFingerprint(){
    certificateSHA256Fingerprints.add(fingerprint);
    return certificateSHA256Fingerprints;
  }

  
  SecureHttpClient getClient(List<String> allowedSHAFingerprints){
    final secureClient = SecureHttpClient.build(allowedSHAFingerprints);
      return secureClient;
  }

  myRepositoryMethod(Map data){
    var token = "";
    final secureClient = getClient(getFingerprint());
    var url = Uri.parse(baseUrl + "/login.php");
    secureClient.post(url, body: "jsonEncode(data)", headers: {
        'Accept': 'application/json',
        "Authorization": "Bearer $token",
        'Content-Type': 'application/json'
      } );
  } 

}