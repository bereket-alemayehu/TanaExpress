import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tana_web_commerce/screens/home_screen.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'YOUR_API_KEY',
      appId: 'YOUR_APP_ID',
      messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
      projectId: 'YOUR_PROJECT_ID',
      storageBucket: 'YOUR_STORAGE_BUCKET',
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tana Web Commerce',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomeScreen(),
    );
  }
}