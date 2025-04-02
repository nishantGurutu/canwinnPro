import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:task_management/controller/bottom_bar_navigation_controller.dart';
import 'package:task_management/view/screen/bootom_bar.dart';
import 'package:task_management/view/screen/calender_screen.dart';
import 'package:task_management/view/screen/message.dart';
import 'package:task_management/view/screen/project.dart';
import 'package:task_management/view/screen/task_list.dart';
import 'package:task_management/view/screen/todo_list.dart';
import 'package:timezone/timezone.dart' as tz;

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  debugPrint('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    debugPrint(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static String? pendingPayload;

  static void initialize() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      onDidReceiveNotificationResponse: (response) {
        print(
            'notification payload ------------------------------////////////// ${response.payload}');
        handleNavigation(response.payload);
      },
    );

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification clicked when app was in background: ${message.data}");
      handleNavigation(jsonEncode(message.data));
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        debugPrint(
            "Notification clicked when app was terminated: ${message.data}");
        handleNavigation(jsonEncode(message.data));
      }
    });
  }

  static void onStart(ServiceInstance service) {
    debugPrint("Background service running...");
  }

  static Future<void> createAndDisplayNotification(
      RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        "pushnotificationapp",
        "Push Notification App",
        channelDescription: "This channel is for push notifications",
        importance: Importance.max,
        priority: Priority.high,
      );

      const NotificationDetails notificationDetails =
          NotificationDetails(android: androidDetails);

      await _notificationsPlugin.show(
        id,
        message.notification?.title ?? "No Title",
        message.notification?.body ?? "No Body",
        notificationDetails,
        payload: jsonEncode(message.data),
      );
    } catch (e) {
      debugPrint("Error displaying notification: $e");
    }
  }

  Future<void> scheduleNotification(
      DateTime dateTime, int notificationId, String title, String s) async {
    debugPrint('Scheduled Notification Time: $dateTime');

    int millisecondsUntilNotification =
        dateTime.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch;

    await _notificationsPlugin.zonedSchedule(
      notificationId,
      '$title $s reminder',
      '${s.contains('task') ? "Task is due!" : s.contains('sos') ? "SOS Reminder" : s.contains('event') ? "Event Reminder" : "Calendar Reminder"}',
      tz.TZDateTime.now(tz.local)
          .add(Duration(milliseconds: millisecondsUntilNotification)),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'your_channel_id',
          'your_channel_name',
          channelDescription: 'your channel description',
          sound: RawResourceAndroidNotificationSound("alarm"),
          autoCancel: false,
          playSound: true,
          priority: Priority.max,
          fullScreenIntent: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: jsonEncode({'page': s}),
    );

    Future.delayed(
        Duration(milliseconds: millisecondsUntilNotification), () {});
  }

  final BottomBarController bottomBarController =
      Get.put(BottomBarController());
  static void handleNavigation(String? payload) {
    if (payload == null) return;

    try {
      Map<String, dynamic> payloadData = jsonDecode(payload);
      debugPrint("Navigating to screen with payload: $payloadData");

      if (Get.context == null) {
        pendingPayload = payload;
        return;
      }

      String? page = payloadData['page'];

      if (payloadData['type'] == "chat") {
        Get.to(() => MessageScreen(
            payloadData['sendername'].toString(),
            payloadData['productid'].toString(),
            payloadData['senderid'].toString(),
            '',
            [],
            '',
            '',
            '',
            ''));
      } else if (payloadData['type'].toString().contains("task")) {
        Get.to(() => TaskListPage(
            taskType: "All Task", assignedType: "Assigned to me", '', ''));
      } else if (payloadData['type'].toString().contains("todo")) {
        Get.to(() => ToDoList(''));
      } else if (payloadData['type'].toString().contains("project")) {
        Get.to(() => Project(''));
      } else if (page.toString().contains('task')) {
        Get.to(() => TaskListPage(
            taskType: "All Task", assignedType: "Assigned to me", '', ''));
      } else if (page.toString().contains('event')) {
        Get.find<BottomBarController>().currentPageIndex.value = 2;
        Get.to(() => BottomNavigationBarExample(from: ''));
      } else if (page.toString().contains('calender')) {
        Get.to(() => CalenderScreen(''));
      } else if (page.toString().contains('todo')) {
        Get.to(() => ToDoList(''));
      }
    } catch (e) {
      debugPrint("Error decoding navigation payload: $e");
    }
  }

  // Call this in your main app widget (after ensuring GetX context is available)
  static void checkPendingNotification() {
    if (pendingPayload != null) {
      handleNavigation(pendingPayload);
      pendingPayload = null;
    }
  }
}
