# Basic Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Flutter embedding
-keep class io.flutter.embedding.android.** { *; }
-keep class io.flutter.embedding.engine.** { *; }

# Platform channels
-keep class * extends io.flutter.plugin.common.MethodCall {
    <init>(java.lang.String, java.lang.Object);
}

# Your package
-keep class com.fosshati.sa.** { *; }

# Basic Android
-keep public class * extends android.app.Activity
-keep public class * extends android.app.Application

# Don't warn about anything temporarily
-dontwarn **

# Keep everything temporarily
-keep class ** { *; }