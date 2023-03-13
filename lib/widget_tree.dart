import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_with_firebase/pages/login_register_page.dart';
import 'package:flutter_app_with_firebase/pages/verify_email_page.dart';
import 'package:provider/provider.dart';

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();

    if(user != null){
      return const VerifyEmailPage();
    }
    return LoginPage();
  }
}