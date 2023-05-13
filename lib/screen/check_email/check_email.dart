import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:herafy/screen/check_email/verify_email.dart';
import 'package:nb_utils/nb_utils.dart';

import '../DTDashboardScreen.dart';

class SendVerificationPage extends StatefulWidget {
  const SendVerificationPage({super.key});

  @override
  _SendVerificationPageState createState() => _SendVerificationPageState();
}

class _SendVerificationPageState extends State<SendVerificationPage> {
  Future _sendVerificationEmail() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (!user!.emailVerified) {
        await user.sendEmailVerification();
        // Email sent.
      }
    } catch (e) {
      // Handle errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Verification Email'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            MaterialButton(
              color: Colors.blueAccent,
              onPressed: () {
                _sendVerificationEmail().then((value) {
                  const DTDashboardScreen().launch(context);
                });
              },
              child: const Text('Send Verification Email'),
            ),
          ],
        ),
      ),
    );
  }
}
