import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("LOGIN / SIGN UP"),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 50,),
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "EMAIL...",
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 50,),
              child: TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: "PASSWORD...",
                ),
                obscureText: true,
              ),
            ),
            SizedBox(height: 20,),
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width / 3,
              color: Colors.blue,
              child: ElevatedButton(
                onPressed: () {
                  final String email = emailController.text.trim();
                  final String password = passwordController.text.trim();

                  if(email.isEmpty){
                    print("Email is Empty");
                  } else {
                    if(password.isEmpty){
                      print("Password is Empty");
                    } else {
                      context.read<Auth>().login(
                        email,
                        password,
                      );
                    }
                  }
                },
                child: Text("LOG IN", style: TextStyle(color: Colors.white))
              ),
            ),
            SizedBox(height: 20,),
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width / 3,
              color: Colors.red,
              child: ElevatedButton(
                onPressed: () {
                  final String email = emailController.text.trim();
                  final String password = passwordController.text.trim();

                  if(email.isEmpty){
                    ("Email is Empty");
                  } else {
                    if(password.isEmpty){
                      print("Password is Empty");
                    } else {
                      context.read<Auth>().signUp(
                        email,
                        password,
                      ).then((value) async {
                        User? user = FirebaseAuth.instance.currentUser;

                        await FirebaseFirestore.instance.collection("users").doc(user!.uid).set({
                          'uid': user.uid,
                          'email': email,
                          'password': password,
                        });
                      });
                    }
                  }
                },
                child: Text("SIGN UP"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}