package com.example.astrology_app

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.astrology_app/notification"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getInitialNotification" -> {
                    val notificationData = getInitialNotificationData()
                    result.success(notificationData)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        handleIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleIntent(intent)
    }

    private fun handleIntent(intent: Intent?) {
        if (intent?.action == "FLUTTER_NOTIFICATION_CLICK") {
            // Handle notification click
            val notificationData = intent.extras
            // You can pass this data to Flutter if needed
        }
    }

    private fun getInitialNotificationData(): Map<String, Any>? {
        val intent = intent
        if (intent?.action == "FLUTTER_NOTIFICATION_CLICK") {
            val extras = intent.extras
            if (extras != null) {
                val data = mutableMapOf<String, Any>()
                for (key in extras.keySet()) {
                    extras.get(key)?.let { value ->
                        data[key] = value
                    }
                }
                return data
            }
        }
        return null
    }
}