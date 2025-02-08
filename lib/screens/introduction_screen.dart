import 'package:flutter/material.dart';
import 'package:tana_web_commerce/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // this is used to ensure the state<SplashScreen> is initialized properly.
    super.initState();

    Future.delayed(
      // here we don't need to use async and await  because  it is future-based function that schedules an  operation to run after a certain duration rather wating  for undetermined time long.
      const Duration(seconds: 3),
      () {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            // this means user can't go back to this screen by pressing back button.
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      },
    );
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
                height: 150), // this is using image.asset from assets folder
            const SizedBox(height: 20),
            const Text(
              "Welcome to TanaExpress",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: Colors.red),
          ],
        ),
      ),
    );
  }
}
