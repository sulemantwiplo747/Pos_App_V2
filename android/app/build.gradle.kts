plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.fosshati.sa"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled= true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.fosshati.sa"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 26
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
buildTypes {
    release {
        isMinifyEnabled = true
        isShrinkResources = true
        proguardFiles(
            getDefaultProguardFile("proguard-android-optimize.txt"),
            "proguard-rules.pro"
        )
        signingConfig = signingConfigs.getByName("debug") // Replace with your real signing later
    }
}

    // buildTypes {
    //     release {
    //      isMinifyEnabled = true
    //     isShrinkResources = true

    //         // ✅ ProGuard rules
    //         proguardFiles(
    //             getDefaultProguardFile("proguard-android-optimize.txt"),
    //             "proguard-rules.pro"
    //         )
    //         // TODO: Add your own signing config for the release build.
    //         // Signing with the debug keys for now, so `flutter run --release` works.
    //         signingConfig = signingConfigs.getByName("debug")
    //     }
    // }
}
allprojects {
  repositories {
    maven { url = uri("https://www.jitpack.io") }
  }
}
flutter {
    source = "../.."
}
dependencies {

implementation("com.google.android.material:material:1.11.0")
  implementation(platform("com.google.firebase:firebase-bom:34.6.0"))
  implementation("com.google.firebase:firebase-analytics")
  implementation ("com.google.firebase:firebase-crashlytics")
  implementation("com.google.firebase:firebase-messaging")
  coreLibraryDesugaring ("com.android.tools:desugar_jdk_libs:2.1.4")


}
