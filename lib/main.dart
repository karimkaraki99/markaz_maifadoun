import 'package:flutter/material.dart';
import 'login/log_in.dart';
import 'package:firebase_core/firebase_core.dart';

import 'mainscreens/library.dart';

Future<void> main()  async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
     options: const FirebaseOptions(
         apiKey: "AIzaSyBsCZbQPSA1X-a3XJ_z_HitgmVS9K_Fu0s",
         appId: "1:197241802386:android:d51e1616f326cb415b204b",
         messagingSenderId: "197241802386",
         projectId: "markaz-maifadoun-b258c")
   );
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
