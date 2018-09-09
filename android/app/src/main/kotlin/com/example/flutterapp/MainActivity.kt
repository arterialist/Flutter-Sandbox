package com.example.flutterapp

import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodCall
import android.content.Intent;


class MainActivity() : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        MethodChannel(this.getFlutterView(), "channel:share").setMethodCallHandler(object : MethodChannel.MethodCallHandler {
            override fun onMethodCall(methodCall: MethodCall, result: MethodChannel.Result) {
                if (methodCall.method == "share") {
                    val intent = Intent(Intent.ACTION_SEND)
                    intent.setType("text/plain")
                    intent.putExtra(Intent.EXTRA_TEXT, methodCall.arguments as String)
                    startActivity(intent)
                }
            }
        })
    }
}
