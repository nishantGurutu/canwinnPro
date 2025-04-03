import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_management/controller/bottom_bar_navigation_controller.dart';
import 'package:task_management/controller_binding.dart';
import 'package:task_management/firebase_messaging/notification_service.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/view/screen/bootom_bar.dart';
import 'package:task_management/view/screen/calender_screen.dart';
import 'package:task_management/view/screen/message.dart';
import 'package:task_management/view/screen/project.dart';
import 'package:task_management/view/screen/splash_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:task_management/view/screen/task_list.dart';
import 'package:task_management/view/screen/todo_list.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import 'component/location_service.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

final BottomBarController bottomBarController = Get.put(BottomBarController());

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  String? messageData = jsonEncode(message.data);
  Map<String, dynamic> payloadData = jsonDecode(messageData);
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('notification_data', payloadData['message'].toString());

  final service = FlutterBackgroundService();
  service.invoke("play_audio");
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) {
  final player = AudioPlayer();
  service.on("play_audio").listen(
    (event) async {
      try {
        debugPrint("Playing audio in background...");
        await player.play(AssetSource('mp3/emergency_alarm_69780.mp3'));
      } catch (e) {
        debugPrint("Error playing audio: $e");
      }
    },
  );
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  tz.initializeTimeZones();
  initializeService();
  await requestPermissions();
  await StorageHelper.initialize();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  LocationService.initialize();
  await EasyLocalization.ensureInitialized();

  LocalNotificationService.initialize();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();

  String? firebasePayload =
      initialMessage != null ? jsonEncode(initialMessage.data) : null;

  String? localPayload =
      notificationAppLaunchDetails?.notificationResponse?.payload;

  debugPrint('Firebase remote message: $firebasePayload');
  debugPrint('Local notification payload: $localPayload');

  String? initialPayload = firebasePayload ?? localPayload;

  runApp(
    EasyLocalization(
      path: 'assets/translations',
      supportedLocales: const [Locale('en')],
      fallbackLocale: const Locale('en'),
      child: MyApp(
        initialPayload: initialPayload,
      ),
    ),
  );
}

Future<void> requestPermissions() async {
  await [
    Permission.notification,
    Permission.locationWhenInUse,
    Permission.locationAlways,
    Permission.accessMediaLocation,
    Permission.location,
    Permission.camera,
  ].request();
}

void initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: false,
    ),
    iosConfiguration: IosConfiguration(
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );

  service.startService();
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  return true;
}

Future<void> requestNotificationPermission() async {
  final NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  debugPrint('Notification permission status: ${settings.authorizationStatus}');
}

class MyApp extends StatelessWidget {
  final String? initialPayload;

  const MyApp({super.key, this.initialPayload});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 760),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, widget) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          title: 'Task Management',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          initialBinding: ControllerBinding(),
          home: _getInitialScreen(),
        );
      },
    );
  }

  Widget _getInitialScreen() {
    if (initialPayload == null) {
      return const SplashScreen();
    }

    try {
      Map<String, dynamic> payloadData = jsonDecode(initialPayload!);

      if (payloadData['type'] == "chat") {
        return MessageScreen(
            payloadData['sendername'].toString(),
            payloadData['productid'].toString(),
            payloadData['senderid'].toString(),
            '',
            [],
            '',
            '',
            '',
            'notification');
      } else if (payloadData['type'].toString().contains("task") ||
          payloadData['type'].toString().contains("task_list")) {
        return TaskListPage(
            taskType: "All Task",
            assignedType: "Assigned to me",
            'notification',
            '');
      } else if (payloadData['type'].toString().contains("todo")) {
        return ToDoList('');
      } else if (payloadData['type'].toString().contains("sos")) {
        Get.find<BottomBarController>().currentPageIndex.value = 2;
        return BottomNavigationBarExample(from: '');
      } else if (payloadData['type'].toString().contains("project")) {
        return Project('notification');
      } else if (payloadData['page'].toString().contains("task")) {
        return TaskListPage(
            taskType: "All Task",
            assignedType: "Assigned to me",
            'notification',
            '');
      } else if (payloadData['page'].toString().contains("event")) {
        Get.find<BottomBarController>().currentPageIndex.value = 2;
        return BottomNavigationBarExample(from: '');
      } else if (payloadData['page'].toString().contains("calender")) {
        return CalenderScreen('notification');
      }
    } catch (e) {
      debugPrint("Error decoding initial payload: $e");
    }

    return const SplashScreen();
  }
}
