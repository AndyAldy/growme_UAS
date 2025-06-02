plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.growme"
    compileSdk = 34 // Ganti sesuai versi compileSdk Flutter kamu

    ndkVersion = "25.1.8937393" // Ganti jika kamu pakai versi berbeda atau ambil dari flutter.gradle

    defaultConfig {
        applicationId = "com.example.growme"
        minSdk = 21
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
            signingConfig = signingConfigs.getByName("debug") // Opsional: jika belum punya release key
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }
}

dependencies {
    // Firebase BoM (bisa tambahkan modul lain seperti auth, firestore, dll)
    implementation(platform("com.google.firebase:firebase-bom:33.14.0"))
    implementation("com.google.firebase:firebase-analytics")
    // Tambahkan Firebase Auth jika digunakan:
    implementation("com.google.firebase:firebase-auth")
}

flutter {
    source = "../.."
}
