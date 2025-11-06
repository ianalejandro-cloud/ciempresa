# ProGuard rules para Verisec frejaMobile SDK

# ===============================
# REGLAS ESPECÍFICAS PARA VERISEC
# ===============================

# Mantener todas las clases del SDK de Verisec
-keep class com.verisec.** { *; }
-keeppackagenames com.verisec.**
-dontwarn com.verisec.**

# Mantener las interfaces y enums de Verisec
-keep interface com.verisec.** { *; }
-keep enum com.verisec.** { *; }

# Mantener FmcManager y FmcWSHandler
-keep class com.verisec.freja.mobile.core.FmcManager { *; }
-keep class com.verisec.freja.mobile.core.wsHandler.** { *; }

# ===============================
# REGLAS PARA BOUNCYCASTLE
# ===============================

# Mantener todas las clases de BouncyCastle (requerido por Verisec)
-keep class org.bouncycastle.jcajce.provider.** { *; }
-keep class org.bouncycastle.jce.provider.** { *; }
-keep class org.bouncycastle.crypto.** { *; }
-keep class org.bouncycastle.util.** { *; }
-keep class org.bouncycastle.asn1.** { *; }

# No advertir sobre clases de naming (típico en crypto)
-dontwarn javax.naming.**

# ===============================
# REGLAS PARA REFLECTION/CERTIFICADOS
# ===============================

# Mantener clases relacionadas con certificados y SSL
-keep class java.security.cert.** { *; }
-keep class javax.net.ssl.** { *; }
-keep class javax.security.** { *; }

# ===============================
# REGLAS PARA KOTLIN COROUTINES
# ===============================

# Mantener clases de Kotlin Coroutines (usado por VerisecViewModel)
-keep class kotlinx.coroutines.** { *; }
-keep class kotlin.coroutines.** { *; }
-dontwarn kotlinx.coroutines.**

# ===============================
# REGLAS PARA ANDROIDX LIFECYCLE
# ===============================

# Mantener ViewModel y clases relacionadas
-keep class androidx.lifecycle.** { *; }
-keep class * extends androidx.lifecycle.ViewModel {
    <init>(...);
}

# ===============================
# REGLAS PARA FLUTTER METHOD CHANNEL
# ===============================

# Mantener MainActivity y métodos de comunicación con Flutter
-keep class com.example.ciempresas_mock.MainActivity { *; }
-keep class com.example.ciempresas_mock.verisec.** { *; }

# Mantener métodos que son llamados por reflection desde Flutter
-keepclassmembers class * {
    @io.flutter.plugin.common.MethodChannel$MethodCallHandler *;
}

# ===============================
# REGLAS GENERALES DE SEGURIDAD
# ===============================

# No optimizar/ofuscar clases relacionadas con seguridad
-keep class java.security.** { *; }
-keep class javax.crypto.** { *; }

# Mantener atributos necesarios para reflection
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses

# ===============================
# REGLAS PARA JSON/SERIALIZACIÓN
# ===============================

# Si se usa Gson (común en SDKs)
-keep class com.google.gson.** { *; }
-keepattributes Signature
-keepattributes *Annotation*

# Mantener clases que podrían ser serializadas
-keep class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# ===============================
# REGLAS PARA MULTIDEX
# ===============================

# Mantener clases de MultiDex
-keep class androidx.multidx.** { *; }
-keep class android.support.multidex.** { *; }

# ===============================
# REGLAS PARA DEBUGGING (OPCIONAL)
# ===============================

# Mantener números de línea para stack traces útiles
-keepattributes SourceFile,LineNumberTable

# Renombrar fuentes obfuscadas
-renamesourcefileattribute SourceFile 