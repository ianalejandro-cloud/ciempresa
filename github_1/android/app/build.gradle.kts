plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.cibanco.ciempresas"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "26.3.11579264"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.cibanco.ciempresas"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 24
        targetSdk = 34
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // Para habilitar MultiDex
        multiDexEnabled = true

        // Configuración específica para Verisec SDK
        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
        
        // Vector drawables support
        vectorDrawables {
            useSupportLibrary = true
        }
    }

    buildTypes {
        debug {
            // Configuración de debug para desarrollo con Verisec
            isMinifyEnabled = false
            isShrinkResources = false
            isDebuggable = true
            
            // ProGuard rules para debug (opcional)
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
        
        release {
            // Configuración de release con ProGuard habilitado
            isMinifyEnabled = true
            isShrinkResources = true
            isDebuggable = false
            
            // ProGuard configuration files
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
    
    // Configuración de empaquetado específica para SDKs de seguridad
    packagingOptions {
        pickFirst("**/libc++_shared.so")
        pickFirst("**/libjsc.so")
        
        // Exclusiones generales de META-INF
        exclude("META-INF/DEPENDENCIES")
        exclude("META-INF/LICENSE")
        exclude("META-INF/LICENSE.txt")
        exclude("META-INF/license.txt")
        exclude("META-INF/NOTICE")
        exclude("META-INF/NOTICE.txt")
        exclude("META-INF/notice.txt")
        exclude("META-INF/ASL2.0")
        exclude("META-INF/*.kotlin_module")
        
        // Solución para conflictos específicos de BouncyCastle
        pickFirst("META-INF/versions/9/OSGI-INF/MANIFEST.MF")
        pickFirst("META-INF/MANIFEST.MF")
        pickFirst("META-INF/versions/*/OSGI-INF/MANIFEST.MF")
        
        // Exclusiones adicionales para BouncyCastle
        exclude("META-INF/BC1024KE.RSA")
        exclude("META-INF/BC1024KE.SF")
        exclude("META-INF/BC2048KE.RSA")
        exclude("META-INF/BC2048KE.SF")
        exclude("META-INF/versions/*/module-info.class")
        
        // Conflictos potenciales de módulos
        exclude("module-info.class")
    }
    
    // Lint options para manejar warnings específicos de Verisec
    lint {
        checkReleaseBuilds = false
        abortOnError = false
        disable.addAll(listOf("MissingTranslation", "ExtraTranslation"))
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Para ViewModel y viewModelScope
    implementation("androidx.lifecycle:lifecycle-viewmodel-ktx:2.7.0")
    implementation("androidx.lifecycle:lifecycle-runtime-ktx:2.7.0")
    
    // Dependencia de Lottie para Android
    implementation("com.airbnb.android:lottie:6.1.0")
    
    // Dependencia de ConstraintLayout para el layout del splash screen
    implementation("androidx.constraintlayout:constraintlayout:2.1.4")
    implementation("androidx.appcompat:appcompat:1.6.1")
    
    // Dependencia para el Splash Screen API de Android 12+
    implementation("androidx.core:core-splashscreen:1.0.1")
    
    // Dependencias de Verisec (actualizadas y mejoradas)
    implementation("org.bouncycastle:bcprov-jdk18on:1.78.1")
    implementation("org.bouncycastle:bcpkix-jdk18on:1.78.1") // Agregado para certificados
    implementation("androidx.core:core-ktx:1.12.0")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.7.3") // Versión actualizada
    implementation(files("libs/frejaMobileCore.aar"))
    implementation("androidx.multidex:multidex:2.0.1")
    
    // Dependencias adicionales para seguridad y networking
    implementation("androidx.security:security-crypto:1.1.0-alpha06")
    implementation("androidx.work:work-runtime-ktx:2.9.0")
    
    // Dependencias para debugging y testing (opcional)
    debugImplementation("com.squareup.leakcanary:leakcanary-android:2.12")
    
    // Test dependencies
    testImplementation("junit:junit:4.13.2")
    androidTestImplementation("androidx.test.ext:junit:1.1.5")
    androidTestImplementation("androidx.test.espresso:espresso-core:3.5.1")
}
