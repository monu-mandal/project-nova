# Nova — ProGuard rules
# Keep Flutter classes
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep Nova classes
-keep class com.nova.assistant.** { *; }

# Keep SQLite / Drift
-keep class com.tekartik.sqflite.** { *; }

# Keep overlay window
-keep class com.example.flutter_overlay_window.** { *; }

# Suppress warnings
-dontwarn io.flutter.**
-dontwarn okhttp3.**
-dontwarn okio.**
