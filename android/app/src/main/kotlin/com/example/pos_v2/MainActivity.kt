package com.fosshati.sa

import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        allowScreenshots()
    }

    override fun onResume() {
        super.onResume()
        allowScreenshots()
    }

    private fun allowScreenshots() {
        @Suppress("DEPRECATION")
        window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
    }
}
