import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../DTDashboardScreen.dart';

class CheckVerificationPage extends StatefulWidget {
  const CheckVerificationPage({super.key});

  @override
  _CheckVerificationPageState createState() => _CheckVerificationPageState();
}

class _CheckVerificationPageState extends State<CheckVerificationPage> {
  final auth = FirebaseAuth.instance;
  User? user;
  Timer? timer;

  @override
  void initState() {
    user = auth.currentUser;
    // user?.sendEmailVerification();
    // timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    //   checkVerifyingEmail();
    // });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Verification Status'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            MaterialButton(
              color: Colors.blueAccent,
              onPressed: () async {
                user = auth.currentUser;
                // await user?.reload();
                if (user!.emailVerified) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DTDashboardScreen()));
                }
              },
              child: const Text('Check Verification Status'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
