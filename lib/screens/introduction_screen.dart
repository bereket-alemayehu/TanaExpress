import 'package:flutter/material.dart';
import 'package:tana_web_commerce/screens/home_screen.dart'; // Replace with your actual home screen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Delay for 3 seconds before navigating to HomeScreen
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        // ✅ Check if the widget is still in the tree
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png',
                height: 150), // Your logo/image
            const SizedBox(height: 20),
            const Text(
              "Welcome to TanaExpress",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
                color: Colors.red), // Loading indicator
          ],
        ),
      ),
    );
  }
}
