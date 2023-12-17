import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogoutWidget extends StatelessWidget {
  const LogoutWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
          // Navigate to the login screen or any other screen after logging out
          Navigator.of(context).pushReplacementNamed('/LoginScreen');
        },
        child: const Text('Logout'),
      ),
    );
  }
}