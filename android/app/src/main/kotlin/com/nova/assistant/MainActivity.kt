package com.nova.assistant

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.os.BatteryManager
import android.media.AudioManager

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.nova.assistant/system"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getBatteryLevel" -> result.success(getBatteryLevel())
                    "setVolume" -> {
                        val level = call.argument<Int>("level") ?: 50
                        setVolume(level)
                        result.success(true)
                    }
                    "setMobileData" -> {
                        // Phase 6: implement via reflection or shell
                        result.success(false)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun getBatteryLevel(): Int {
        val bm = getSystemService(BATTERY_SERVICE) as BatteryManager
        return bm.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
    }

    private fun setVolume(level: Int) {
        val am = getSystemService(AUDIO_SERVICE) as AudioManager
        val max = am.getStreamMaxVolume(AudioManager.STREAM_MUSIC)
        am.setStreamVolume(AudioManager.STREAM_MUSIC, (level / 100.0 * max).toInt(), 0)
    }
}
