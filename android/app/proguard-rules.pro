## Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-keep public class io.flutter.embedding.android.FlutterSplashView.$SavedState { *; }
-dontwarn io.flutter.embedding.**

## flutter_local_notification plugin rules
-keep class com.dexterous.** { *; }