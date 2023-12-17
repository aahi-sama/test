import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/SplashScreen';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () async {
      checkAuthentication(); // Add your delayed code here
    });
  }

  void checkAuthentication() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // User is logged in, navigate to HomeScreen
      Navigator.of(context).pushReplacementNamed('/HomeScreen');
    } else {
      // User is not logged in, navigate to LoginScreen
      Navigator.of(context).pushReplacementNamed('/LoginScreen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Welcome to',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Text(
                  'Class Management',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 100),
          // Uncomment and replace 'your_image_asset' with your actual image asset path
          // Image.asset('your_image_asset'),
        ],
      ),
    );
  }
}
