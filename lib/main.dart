import 'package:flutter/material.dart';
import 'login/log_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main()  async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
     options: const FirebaseOptions(
         apiKey: "AIzaSyBsCZbQPSA1X-a3XJ_z_HitgmVS9K_Fu0s",
         appId: "1:197241802386:android:d51e1616f326cb415b204b",
         messagingSenderId: "197241802386",
         projectId: "markaz-maifadoun-b258c")
   );

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  await messaging.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: false,
    criticalAlert: true,
    provisional: false,
    sound: true,
  );

  await Permission.notification.isDenied.then((value) {
    print(value);
    print(value);
    print(value);
    if (value) {
      Permission.notification.request();
    }
  });



  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,

      home: LoginScreen(),

    );
  }
}
