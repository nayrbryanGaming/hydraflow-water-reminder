# Flutter Proguard Rules
# Add project-specific Proguard rules here.

# Flutter Specific
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Firebase Specific
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Google Fonts
-keep class com.google.fonts.** { *; }

# Removal of Log Messages for Production Performance
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
}

# Keep the following for reflection-based libraries
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
