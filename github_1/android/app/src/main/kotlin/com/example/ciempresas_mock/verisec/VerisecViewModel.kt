package com.example.ciempresas_mock.verisec

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.verisec.freja.mobile.core.FmcManager
import com.verisec.freja.mobile.core.wsHandler.beans.general.response.FmcPollingResponse
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import kotlin.coroutines.resume
import kotlin.coroutines.suspendCoroutine
import java.net.MalformedURLException
import java.util.UUID

class VerisecViewModel: ViewModel() {

    //Inicialización de FmcManager
    var fmcManager = FmcManager.getFmcManager()

    suspend fun performAffiliation (clientCode: String) :String = suspendCoroutine { continuation ->
        println("🔄 Iniciando performAffiliation con clientCode: $clientCode")
        viewModelScope.launch {
           
            withContext(Dispatchers.IO){
                try {
                    println("📋 Intentando obtener activationCode del SDK de Verisec...")
                    
                    // 1. get activation code
                    //Llamado para obtener activationCode4ClientCode
                    val activationCode4ClientCode = fmcManager.getFmcWSHandler().getActivationCode(clientCode)
                    
                    if (activationCode4ClientCode != null && activationCode4ClientCode.isNotEmpty()) {
                        println("✅ ActivationCode obtenido exitosamente: $activationCode4ClientCode")
                        continuation.resume(activationCode4ClientCode)
                    } 
                    // else {
                    //     println("⚠️ ActivationCode vacío del SDK, generando código de simulación")
                    //     val mockCode = generateMockActivationCode(clientCode)
                    //     continuation.resume(mockCode)
                    // }
                    
                } catch (e: MalformedURLException) {
                    println("🚨 Error de URL malformada - Servidor MASS no configurado: ${e.message}")
                    println("🔧 Generando código de activación simulado...")
                    
                    // Generar código simulado cuando MASS no está disponible
                    val mockCode = generateMockActivationCode(clientCode)
                    println("🧪 Código de simulación generado: $mockCode")
                    continuation.resume(mockCode)
                    
                } catch (e: NullPointerException) {
                    println("🚨 Error de configuración nula - SDK no inicializado correctamente: ${e.message}")
                    val mockCode = generateMockActivationCode(clientCode)
                    continuation.resume(mockCode)
                    
                } catch (e: Exception) {
                    println("🚨 Error general en performAffiliation: ${e.javaClass.simpleName} - ${e.message}")
                    e.printStackTrace()
                    
                    // En caso de cualquier otro error, generar código simulado
                    val mockCode = generateMockActivationCode(clientCode)
                    println("🧪 Fallback: Código de simulación generado: $mockCode")
                    continuation.resume(mockCode)
                }
            }
        }
    }

    /**
     * Genera un código de activación simulado para desarrollo/testing
     * cuando el servidor MASS no está disponible
     */
    private fun generateMockActivationCode(clientCode: String): String {
        val timestamp = System.currentTimeMillis().toString().takeLast(6)
        val uniqueId = UUID.randomUUID().toString().replace("-", "").take(8)
        return "MOCK_AC_${clientCode}_${timestamp}_${uniqueId}".take(32)
    }

    /**
     * Verifica si el SDK está configurado correctamente
     */
    private fun isSdkConfigured(): Boolean {
        return try {
            val config = fmcManager.fmcConfiguration
            config != null
        } catch (e: Exception) {
            false
        }
    }

    suspend fun performLogin (nip: String): String = suspendCoroutine { continuation ->
        println("🔄 Iniciando performLogin con NIP")
        viewModelScope.launch {
            withContext(Dispatchers.IO){
                try {
                    // 2. get pin policy
                    //Llamado para saber si el Pin policy fue o no recibido
                    val pinPolicyObject = fmcManager.getFmcWSHandler().getProvisioningPinPolicy()

                    if (pinPolicyObject == null || pinPolicyObject is FmcPollingResponse) {
                        println("⚠️ Pin policy not received! $pinPolicyObject")
                        continuation.resume("")
                    } else {
                        println("✅ Pin policy received! $pinPolicyObject")

                        // 3. verify pin - perform validation on server side that user PIN and token are properly used
                        println("nip $nip")
                        val byteArray: ByteArray = nip.toByteArray(Charsets.UTF_8)
                        println("nip $byteArray")
                        fmcManager.getFmcWSHandler().verifyProvisioning(byteArray)

                        val config = FmcManager.getFmcManager().fmcConfiguration
                        var tokenSerialNumbers = ""
                        if (config.existsOnlineToken()) {
                            tokenSerialNumbers += config.onlineToken.serialNumber
                        }

                        continuation.resume(tokenSerialNumbers)
                    }
                } catch (e: MalformedURLException) {
                    println("🚨 Error de URL en performLogin: ${e.message}")
                    continuation.resume("ERROR_MASS_NOT_CONFIGURED")
                } catch (e: Exception) {
                    println("🚨 Error en performLogin: ${e.javaClass.simpleName} - ${e.message}")
                    continuation.resume("ERROR_${e.javaClass.simpleName}")
                }
            }
        }
    }

    suspend fun generateOTP (nip: String): String = suspendCoroutine { continuation ->
        println("🔄 Iniciando generateOTP")
        viewModelScope.launch {
            withContext(Dispatchers.IO){
                try {
                    //Conversión del PIN
                    val byteArray: ByteArray = nip.toByteArray(Charsets.UTF_8)
                    val otpValue = fmcManager.generateOTPValue(byteArray)
                    continuation.resume(otpValue ?: "")
                } catch (e: Exception) {
                    println("🚨 Error en generateOTP: ${e.javaClass.simpleName} - ${e.message}")
                    continuation.resume("ERROR_OTP_GENERATION")
                }
            }
        }
    }
}
