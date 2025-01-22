import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tana_web_commerce/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyD8NWehL-J6luwkJhAXS0jR1nwzqPUfQiM',
      appId: '1:259663845785:android:1f70c1db4c3985af321b08',
      messagingSenderId: '259663845785',
      projectId: 'tana-commerce',
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
