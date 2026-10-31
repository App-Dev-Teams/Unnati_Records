# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Google Play Core / Deferred Components
-dontwarn com.google.android.play.core.**

# ZEGOCLOUD Express Engine
-keep class **.zego.** { *; }
-keep class im.zego.** { *; }
-dontwarn im.zego.**
-keep class com.zego.** { *; }
-dontwarn com.zego.**

# Permission Handler
-keep class com.baseflow.permissionhandler.** { *; }

# OkHttp & HTTP
-dontwarn okhttp3.**
-dontwarn okio.**
-keep class okhttp3.** { *; }
-keep class okio.** { *; }
