import 'dart:convert';
import 'dart:isolate';
import 'dart:math';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:health/login.dart';
import 'package:health/started.dart';
import 'package:health/globals.dart' as globals;
// ignore: depend_on_referenced_packages
import 'package:http/http.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:internet_connection_checker/internet_connection_checker.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:optimize_battery/optimize_battery.dart';

@pragma('vm:entry-point')
void printHello() {
  final DateTime now = DateTime.now();
  final int isolateId = Isolate.current.hashCode;
  print("[$now] Hello, world! isolate=${isolateId} function='$printHello'");
  showNotification();
}

Future showNotification() async {

  bool result = await InternetConnectionChecker().hasConnection;
  if (result == true) {
    final uri1 = Uri.parse('${globals.url}appnotification');
    final headers1 = {'Content-Type': 'application/json'};

    Map<String, dynamic> body1 = {};

    String jsonBody1 = json.encode(body1);
    final encoding1 = Encoding.getByName('utf-8');
    Response response1 = await post(
      uri1,
      headers: headers1,
      body: jsonBody1,
      encoding: encoding1,
    );

    String responseBody1 = response1.body;
    final data1 = await json.decode(responseBody1);



  

        FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

        const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

        var initializationSettingsIOS = DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
            onDidReceiveLocalNotification: (int id, String? title, String? body,
                String? payload) async {});

        InitializationSettings initializationSettings = InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

        await flutterLocalNotificationsPlugin.initialize(
          initializationSettings,
        );

        AndroidNotificationChannel channel = const AndroidNotificationChannel(
          'alzunified',
          'Very important notification!!',
          description: 'the first notification',
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
        );

        Random random = Random();

        int randomNumber1 = random.nextInt(50);

        await flutterLocalNotificationsPlugin.show(
          randomNumber1,
         "AlzUnified",
         "You may have new notifications",
          NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                channelDescription: channel.description),
          ),
        );



  }
}


Future<void> main() async {
  // Be sure to add this line if initialize() call happens before runApp()
  WidgetsFlutterBinding.ensureInitialized();
  await OptimizeBattery.stopOptimizingBatteryUsage();
  await AndroidAlarmManager.initialize();
   runApp(MaterialApp(
    home: const MyApp(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.grey),
  ));

  const int helloAlarmID = 0;
  await AndroidAlarmManager.periodic(
      const Duration(minutes: 15), helloAlarmID, printHello,wakeup: true,rescheduleOnReboot: true);
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState(){
    Future.delayed(const Duration(milliseconds: 5000), () {
      setState(() {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const StartedPage()));
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Image.asset(
                "assets/images/fLogo.jpg",
                fit: BoxFit.scaleDown,
              )),
        ));
  }
}
