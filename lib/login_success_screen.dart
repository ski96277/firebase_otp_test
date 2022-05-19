import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_otp_test/phone_number_screen.dart';
import 'package:flutter/material.dart';

class LoginSuccessScreen extends StatefulWidget {
  String phoneNumber;

  LoginSuccessScreen({required this.phoneNumber});

  @override
  State<LoginSuccessScreen> createState() => _LoginSuccessScreenState();
}

class _LoginSuccessScreenState extends State<LoginSuccessScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LoginSuccessScreen"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("${widget.phoneNumber}\n\nYou are "
                "logged in"),

            const SizedBox(height: 100,),

            ElevatedButton(onPressed: (){

              FirebaseAuth.instance.signOut().then((value) {

                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                    const PhnNumberInputScreen()), (Route<dynamic> route) => false);

              });

            }, child: const Text("Log out"))
          ],
        ),
      ),
    );
  }
}
