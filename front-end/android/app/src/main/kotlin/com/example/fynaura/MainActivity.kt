package com.example.fynAura

import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugins.flutter_local_notifications.FlutterLocalNotificationsPlugin
import android.os.Build
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Create a notification channel (needed for Android 8.0+)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                "default_channel_id",
                "Default Channel",
                NotificationManager.IMPORTANCE_DEFAULT
            )
            val notificationManager: NotificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }
}
