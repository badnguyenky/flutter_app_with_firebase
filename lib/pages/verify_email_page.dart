import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_with_firebase/pages/home_page.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  Timer? timer;
  
  bool canResendEmail = true;
  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerified());
    }
  }
  Future checkEmailVerified() async {
      await FirebaseAuth.instance.currentUser!.reload();
      setState(() {
        isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      });
  }
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
  Future sendVerificationEmail() async {
    try {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
      setState(() {
        canResendEmail = false;
      });
      Timer(const Duration(seconds: 30), () {
        setState(() {
          canResendEmail = true;
        });
      });
    } on Exception catch (e) {
      print(e);
    }
  }
    @override
    Widget build(BuildContext context) => isEmailVerified
        ? HomePage()
        : Scaffold(
            appBar: AppBar(
              title: Text('Verify Email!'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('A verification email has been sent to your email address. Please verify your email address to continue.',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,),
                  const SizedBox(height: 20,),
                  ElevatedButton(
                    onPressed: () => canResendEmail ? sendVerificationEmail() : null,
                    child: const Text('Resend Email'),
                  ),
                  ElevatedButton(
                    onPressed: () => FirebaseAuth.instance.signOut(),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ),
          );
  }
