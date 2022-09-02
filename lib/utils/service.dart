import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:ssl_pinning_plugin/ssl_pinning_plugin.dart';

class ApiClient {
  String fingerprint = "9f72dda2b7557a6ad0a59cf21802d18a4dbdd0ce";
  List<String> certificateSHA256Fingerprints = [];
  String baseUrl = "https://posdemo.aiolos.solutions";

  ApiClient._internal();
  static final ApiClient _instance = ApiClient._internal();
  static ApiClient get instance => _instance;

  Future<bool> checkSSL({url}) async {
  try {
    bool checked = false;
    // String _fingerprint = 'SHA256_FINGERPRINT';
    List<String> allowedShA1FingerprintList = [fingerprint];
    Map<String,String> headerHttp = {};
    String _status = await SslPinningPlugin.check(
      serverURL: url,
      headerHttp: headerHttp,
      httpMethod: HttpMethod.Get,
      sha: SHA.SHA256,
      allowedSHAFingerprints: allowedShA1FingerprintList,
      timeout: 100,
    );
    if (_status == "CONNECTION_SECURE") {
      checked = true;
    }
    return checked;
  } catch (error) {
    print('SSL Pinning Error $error');
    return false;
  }
}

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

      /* // check ssl pinning certificate  if ssl value is true then call the api
      var ssl = await checkSSL(url: endpointUrl);
      debugPrint("ssl: $ssl");*/

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