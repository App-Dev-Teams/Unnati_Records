# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Google Play Core / Deferred Components
-dontwarn com.google.android.play.core.**

# Agora RTC Engine
-keep class io.agora.** { *; }
-dontwarn io.agora.**

# Permission Handler
-keep class com.baseflow.permissionhandler.** { *; }

# OkHttp & HTTP
-dontwarn okhttp3.**
-dontwarn okio.**
-keep class okhttp3.** { *; }
-keep class okio.** { *; }
