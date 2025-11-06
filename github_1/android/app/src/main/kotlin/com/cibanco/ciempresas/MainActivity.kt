package com.cibanco.ciempresas

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.verisec.freja.mobile.core.FmcManager
import com.example.ciempresas_mock.verisec.VerisecViewModel
import com.example.ciempresas_mock.verisec.VerisecTest
import androidx.annotation.NonNull
import kotlinx.coroutines.*
import android.os.Bundle
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen

class MainActivity : FlutterActivity(){
    private val CHANNEL = "com.cibanco.superapp/channel";
    private lateinit var verisecVM: VerisecViewModel

    
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

         

            //VERISEC
            FmcManager.setContext(this)
            verisecVM = VerisecViewModel()
            if (call.method == "performAffiliation") {
                //val clientCode: String = call.arguments.toString()

                GlobalScope.launch {
                    result.success(verisecVM.performAffiliation("857479"))
                
            }  
            } else if (call.method == "performLogin") {
                val nip: String = call.arguments.toString()
                GlobalScope.launch {
                    result.success(verisecVM.performLogin(nip))
                }
            }else if (call.method == "generateOTP") {
                val nip: String = call.arguments.toString()
                GlobalScope.launch {
                    result.success(verisecVM.generateOTP(nip))
                }
            }
        }
    }
}
