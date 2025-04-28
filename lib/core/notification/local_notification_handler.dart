import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static StreamController<NotificationResponse> streamController =
      StreamController();
  static onTap(NotificationResponse notificationResponse) {
    // log(notificationResponse.id!.toString());
    // log(notificationResponse.payload!.toString());
    streamController.add(notificationResponse);
    // Navigator.push(context, route);
  }

  static Future init() async {
    InitializationSettings settings = const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: onTap,
      onDidReceiveBackgroundNotificationResponse: onTap,
    );
  }

  //basic Notification
  static void showBasicNotification(RemoteMessage message) async {
    // final http.Response image = await http
    //     .get(Uri.parse(message.notification?.android?.imageUrl ?? ''));
    // BigPictureStyleInformation bigPictureStyleInformation =
    //     BigPictureStyleInformation(
    //   ByteArrayAndroidBitmap.fromBase64String(
    //     base64Encode(image.bodyBytes),
    //   ),
    //   largeIcon: ByteArrayAndroidBitmap.fromBase64String(
    //     base64Encode(image.bodyBytes),
    //   ),
    // );
    AndroidNotificationDetails android = const AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
      icon:
          '@drawable/ic_notification', // Ensure this icon exists in res/drawable
      // styleInformation: bigPictureStyleInformation,
      // playSound: true,
      // sound: RawResourceAndroidNotificationSound(
      //     'long_notification_sound'.split('.').first),
    );
    NotificationDetails details = NotificationDetails(
      android: android,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      details,
    );
  }
}


/*
1. Add Notification Icon to Drawable Folder:
    -android/app/src/main/res/drawable/ic_notification.png
    -The icon should be a white (transparent background) PNG with a size of 24x24 or 32x32 pixels.

2. Modify AndroidManifest.xml:
    -android/app/src/main/AndroidManifest.xml
    -Add the following code inside the <application> tag:
          <meta-data
              android:name="com.google.firebase.messaging.default_notification_icon"
              android:resource="@drawable/ic_notification" />

          <meta-data
              android:name="com.google.firebase.messaging.default_notification_color"
              android:resource="@color/notification_color" />
    -This code sets the default notification icon for your app.

3. Add notification Colors to Colors.xml:
    -android/app/src/main/res/values/colors.xml (Create the file if it doesn't exist)
    -Add the following code inside the <resources> tag:
          <resources>
              <color name="notification_color">#FF5722</color> <!-- Notification accent color -->
          </resources>
    -This code sets the default notification color for your app.
4. Add notification theme to styles.xml:
    -android/app/src/main/res/values/styles.xml
    -Add the following code inside the <resources> tag:
          <style name="LaunchTheme" parent="@android:style/Theme.Black.NoTitleBar">
              <!-- Show the status bar -->
              <item name="android:windowFullscreen">true</item>
              <!-- Set the color of the status bar -->
              <item name="android:statusBarColor">@android:color/transparent</item>
          </style>
          OR ADD vvvvvvvvvvvvvv
              <!-- Notification Style (Optional) -->
          <style name="NotificationTheme">
              <item name="android:colorBackground">@android:color/transparent</item>
              <item name="android:statusBarColor">@color/notification_color</item>
          </style>
    -This code sets the theme for the app's launch screen.
*/