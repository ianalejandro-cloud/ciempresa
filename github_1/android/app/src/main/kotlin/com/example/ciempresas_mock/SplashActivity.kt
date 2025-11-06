package com.cibanco.ciempresas

import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.animation.AlphaAnimation
import android.view.animation.Animation
import androidx.appcompat.app.AppCompatActivity
import com.airbnb.lottie.LottieAnimationView
import com.airbnb.lottie.LottieDrawable
import com.airbnb.lottie.LottieListener
import com.airbnb.lottie.LottieComposition
import com.airbnb.lottie.LottieCompositionFactory

class SplashActivity : AppCompatActivity() {
    
    private lateinit var lottieAnimationView: LottieAnimationView
    private val splashTimeOut: Long = 3000 // 3 segundos
    private val TAG = "SplashActivity"
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        Log.d(TAG, "Iniciando SplashActivity...")
        
        try {
            // Configurar el layout del splash screen
            setContentView(R.layout.activity_splash)
            
            // Configurar la animación de Lottie
            lottieAnimationView = findViewById(R.id.lottie_animation)
            Log.d(TAG, "LottieAnimationView encontrado")
            
            // Inicialmente ocultar la animación para crear un fade in suave
            lottieAnimationView.alpha = 0f
            
            // Cargar la animación desde assets nativos de Android
            Log.d(TAG, "Intentando cargar prueba_splas.json...")
            
            // Agregar listener para detectar errores
            lottieAnimationView.setFailureListener { throwable ->
                Log.e(TAG, "❌ Error al cargar la animación Lottie: ${throwable?.message}")
                throwable?.printStackTrace()
            }
            
            // Configurar la animación
            setupLottieAnimation()
            
            Log.d(TAG, "Animación de Lottie configurada correctamente")
            
            // Crear una animación de fade in suave después de un pequeño delay
            Handler(Looper.getMainLooper()).postDelayed({
                createFadeInAnimation()
            }, 100) // Delay de 100ms para suavizar la transición
            
            // Verificar si la animación está reproduciéndose
            if (lottieAnimationView.isAnimating) {
                Log.d(TAG, "✅ La animación se está reproduciendo")
            } else {
                Log.w(TAG, "⚠️ La animación NO se está reproduciendo")
            }
            
            // Configurar el handler para navegar a MainActivity después del timeout
            Handler(Looper.getMainLooper()).postDelayed({
                try {
                    Log.d(TAG, "Navegando a MainActivity...")
                    navigateToMainActivity()
                } catch (e: Exception) {
                    Log.e(TAG, "Error al navegar a MainActivity: ${e.message}")
                    // En caso de error, cerrar la aplicación
                    finish()
                }
            }, splashTimeOut)
            
        } catch (e: Exception) {
            Log.e(TAG, "Error en onCreate: ${e.message}")
            // En caso de error, navegar directamente a MainActivity
            startActivity(Intent(this, MainActivity::class.java))
            finish()
        }
    }
    
    /**
     * Configura la animación Lottie para que se mantenga visible durante todo el splash
     */
    private fun setupLottieAnimation() {
        // Cargar la animación desde assets
        lottieAnimationView.setAnimation("prueba_splas.json")
        
        // Configurar la repetición para que dure todo el splash
        lottieAnimationView.repeatCount = LottieDrawable.INFINITE
        lottieAnimationView.repeatMode = LottieDrawable.RESTART
        
        // Agregar listener para monitorear la animación
        lottieAnimationView.addAnimatorListener(object : android.animation.Animator.AnimatorListener {
            override fun onAnimationStart(animation: android.animation.Animator) {
                Log.d(TAG, "🎬 Animación Lottie iniciada")
            }
            
            override fun onAnimationEnd(animation: android.animation.Animator) {
                Log.d(TAG, "🎬 Animación Lottie terminada")
            }
            
            override fun onAnimationCancel(animation: android.animation.Animator) {
                Log.d(TAG, "🎬 Animación Lottie cancelada")
            }
            
            override fun onAnimationRepeat(animation: android.animation.Animator) {
                Log.d(TAG, "🎬 Animación Lottie repetida")
            }
        })
        
        // Iniciar la animación
        lottieAnimationView.playAnimation()
        Log.d(TAG, "Animación iniciada - se reproducirá durante ${splashTimeOut}ms")
    }
    
    /**
     * Crea una animación de fade in suave para la transición del splash del sistema a la animación Lottie
     */
    private fun createFadeInAnimation() {
        val fadeIn = AlphaAnimation(0f, 1f)
        fadeIn.duration = 300 // 300ms de duración
        fadeIn.fillAfter = true
        
        fadeIn.setAnimationListener(object : Animation.AnimationListener {
            override fun onAnimationStart(animation: Animation?) {
                Log.d(TAG, "Iniciando animación de fade in")
            }
            
            override fun onAnimationEnd(animation: Animation?) {
                Log.d(TAG, "Animación de fade in completada")
                lottieAnimationView.alpha = 1f // Asegurar que quede visible
            }
            
            override fun onAnimationRepeat(animation: Animation?) {}
        })
        
        lottieAnimationView.startAnimation(fadeIn)
    }
    
    /**
     * Navega a MainActivity manteniendo la animación visible hasta el final
     */
    private fun navigateToMainActivity() {
        Log.d(TAG, "Tiempo del splash completado, navegando a MainActivity")
        
        // Detener la animación justo antes de navegar
        if (::lottieAnimationView.isInitialized) {
            lottieAnimationView.pauseAnimation()
        }
        
        // Navegar directamente a MainActivity
        val intent = Intent(this@SplashActivity, MainActivity::class.java)
        startActivity(intent)
        finish()
        
        // Agregar transición suave entre actividades
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out)
    }
    
    override fun onDestroy() {
        super.onDestroy()
        Log.d(TAG, "Destruyendo SplashActivity...")
        
        // Detener la animación para liberar recursos
        if (::lottieAnimationView.isInitialized) {
            lottieAnimationView.cancelAnimation()
            Log.d(TAG, "Animación de Lottie detenida")
        }
    }
    
    override fun onPause() {
        super.onPause()
        // Pausar la animación cuando la actividad se pausa
        if (::lottieAnimationView.isInitialized && lottieAnimationView.isAnimating) {
            lottieAnimationView.pauseAnimation()
            Log.d(TAG, "Animación pausada")
        }
    }
    
    override fun onResume() {
        super.onResume()
        // Reanudar la animación cuando la actividad se reanuda
        if (::lottieAnimationView.isInitialized && !lottieAnimationView.isAnimating) {
            lottieAnimationView.resumeAnimation()
            Log.d(TAG, "Animación reanudada")
        }
    }
} 