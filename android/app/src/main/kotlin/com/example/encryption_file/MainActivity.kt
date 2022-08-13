package com.example.encryption_file

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "enc/dec";
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler{ call, result ->
            if(call.method.equals("encrypt")){
                val data = call.argument<String>("data")
                val key = call.argument<String>("key")
                val cipher = CryptoHelper.encrypt(data, key)
                result.success(cipher)
            }else if(call.method.equals("decrypt")){
                val data = call.argument<String>("data")
                val key = call.argument<String>("key")
                val jsonString = CryptoHelper.decrypt(data, key)
                result.success(jsonString)
            }else{
                result.notImplemented()
            }
        }
    }
}
