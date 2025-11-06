package com.example.ciempresas_mock.verisec

import com.verisec.freja.mobile.core.FmcManager
import android.content.Context

class VerisecTest {
    companion object {
        fun testConfiguration(context: Context): String {
            return try {
                println("🧪 Iniciando prueba de configuración Verisec...")
                
                // Establecer contexto
                FmcManager.setContext(context)
                println("✅ Contexto establecido")
                
                // Obtener manager
                val manager = FmcManager.getFmcManager()
                if (manager == null) {
                    println("❌ Manager es null")
                    return "ERROR: Manager es null"
                }
                println("✅ Manager obtenido")
                
                // Obtener WSHandler
                val wsHandler = manager.getFmcWSHandler()
                if (wsHandler == null) {
                    println("❌ WSHandler es null")
                    return "ERROR: WSHandler es null"
                }
                println("✅ WSHandler obtenido")
                
                println("✅ Configuración Verisec OK")
                "SUCCESS: Configuración válida"
                
            } catch (e: Exception) {
                println("❌ Error en prueba: ${e.message}")
                println("❌ Stack trace: ${e.stackTrace?.contentToString()}")
                "ERROR: ${e.message}"
            }
        }
    }
} 