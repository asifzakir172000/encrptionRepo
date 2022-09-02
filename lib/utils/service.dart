import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  String fingerprint = "9f72dda2b7557a6ad0a59cf21802d18a4dbdd0ce";
  List<String> certificateSHA256Fingerprints = [];
  String baseUrl = "https://posdemo.aiolos.solutions";

  ApiClient._internal();
  static final ApiClient _instance = ApiClient._internal();
  static ApiClient get instance => _instance;

  myRepositoryMethod(String data, String eKey) async {
    var body = {
      "databinder": data,
      "dataload": eKey,
    };
     var token = "";
    try{
      var client = http.Client();
      var endpointUrl = 'https://softpos.indianbank.in.worldline-solutions.com/api/checkVersion';
      var url = Uri.parse(endpointUrl);
      debugPrint("url: $url");
      var response = await client.post(url, body: jsonEncode(body), headers: {
          'Accept': 'application/json',
          "Authorization": "Bearer $token",
          'Content-Type': 'application/json'
        });
      debugPrint("response: ${response.body}");
    }catch(err){
      debugPrint("response Error $err");
    }
  }

  // List<String> getFingerprint(){
  //   certificateSHA256Fingerprints.add(fingerprint);
  //   return certificateSHA256Fingerprints;
  // }
  
  // SecureHttpClient getClient(List<String> allowedSHAFingerprints){
  //   final secureClient = SecureHttpClient.build(allowedSHAFingerprints);
  //     return secureClient;
  // }

  // myRepositoryMethod(String data, String eKey) async {
  //   var body = {
  //     "databinder": data,
  //     "dataload": eKey,
  //   };
  //   var token = "";
  //   final secureClient = getClient(getFingerprint());
  //   // var url = Uri.parse(baseUrl + "/login.php");
  //   List<String> allowedShA1FingerprintList = [];
  //   allowedShA1FingerprintList.add(fingerprint);
  //   try{
  //     var headerHttp = <String, String>{};
  //     var response = await HttpCertificatePinning.check(serverURL: "https://flutter.dev/",
  //         headerHttp: headerHttp,
  //         sha: SHA.SHA256,
  //         allowedSHAFingerprints: allowedShA1FingerprintList,
  //         timeout: 50);
  //     // var response = await secureClient.post(url, body: jsonEncode(body), headers: {
  //     //   'Accept': 'application/json',
  //     //   "Authorization": "Bearer $token",
  //     //   'Content-Type': 'application/json'
  //     // } );
  //     debugPrint("response $response");
  //   }catch(err){
  //     debugPrint("response Error $err");
  //   }

      
  // } 

}