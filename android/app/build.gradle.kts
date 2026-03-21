@file:Suppress("DEPRECATION")

import java.time.LocalDate
import java.time.format.DateTimeFormatter
import org.jetbrains.kotlin.gradle.dsl.JvmTarget

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val releaseApkNamePrefix = rootProject.rootDir.parentFile.name
val releaseApkDate = LocalDate.now().format(DateTimeFormatter.BASIC_ISO_DATE)

fun normalizeAbiName(abi: String): String {
    return when (abi) {
        "armeabi-v7a" -> "armeabiv7a"
        "arm64-v8a" -> "arm64v8a"
        "x86" -> "x86"
        "x86_64" -> "x86_64"
        else -> abi.replace("-", "")
    }
}

fun resolveAbiNameFromFileName(fileName: String): String {
    val knownAbis =
        listOf(
            "arm64-v8a",
            "armeabi-v7a",
            "x86_64",
            "x86",
        )

    return knownAbis.firstOrNull(fileName::contains)?.let(::normalizeAbiName) ?: "universal"
}

android {
    signingConfigs {
        create("release") {
            storeFile = file("E:\\workspace\\flutter\\sign.jks")
            storePassword = "ww20041101"
            keyAlias = "sign"
            keyPassword = "ww20041101"
        }
    }

    namespace = "com.gabriel.schulte_grid"
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.gabriel.schulte_grid"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 26
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

val copyFormattedReleaseApks by tasks.registering {
    doLast {
        val releaseOutputDir = layout.buildDirectory.dir("outputs/apk/release").get().asFile
        val flutterOutputDir = layout.buildDirectory.dir("outputs/flutter-apk").get().asFile
        val releaseApks =
            releaseOutputDir.listFiles { file -> file.isFile && file.extension == "apk" }
                ?: emptyArray()

        flutterOutputDir.mkdirs()

        releaseApks.forEach { apkFile ->
            val abiName = resolveAbiNameFromFileName(apkFile.name)
            val targetFile =
                flutterOutputDir.resolve(
                    "${releaseApkNamePrefix}_${releaseApkDate}_${abiName}_release.apk"
                )

            apkFile.copyTo(targetFile, overwrite = true)
        }
    }
}

tasks.matching { it.name == "assembleRelease" }.configureEach {
    finalizedBy(copyFormattedReleaseApks)
}

kotlin {
    compilerOptions {
        jvmTarget = JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
