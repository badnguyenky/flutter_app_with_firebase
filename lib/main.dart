import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app_with_firebase/auth.dart';
import 'package:flutter_app_with_firebase/widget_tree.dart';
import 'package:provider/provider.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Auth>(
          create: (_) => Auth(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<Auth>().authStateChanges, initialData: null,
        ),
      ],
      child: MaterialApp(
        title: "Login Page",
        home: WidgetTree(),
      ),
    );
  }
}