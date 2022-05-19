import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_otp_test/login_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:sms_receiver/sms_receiver.dart';


class PhoneVarifyPage extends StatefulWidget {
  String verificationId;
  String phoneNumber;

  PhoneVarifyPage({required this.verificationId, required this.phoneNumber});

  @override
  State<PhoneVarifyPage> createState() => _PhoneVarifyPageState();
}

class _PhoneVarifyPageState extends State<PhoneVarifyPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late TextEditingController otpController;

  SmsReceiver? _smsReceiver;


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    otpController = TextEditingController();

    initMessageReceiver();

  }

  void initMessageReceiver(){
    _smsReceiver = SmsReceiver(onSmsReceived, onTimeout: onTimeout);
    _startListening();
  }
  void onSmsReceived(String? message) {
    setState(() {

      otpController.text=message!.substring(0,5);
      log("message = $message");
      _smsReceiver!.stopListening();

    });
  }

  void onTimeout() {
    setState(() {
      _smsReceiver?.startListening();

      // _textContent.text = 'Timeout!!!';
    });
  }

  void _startListening() async {
    if (_smsReceiver == null) return;
    await _smsReceiver?.startListening().then((value) {

    });
    setState(() {
      // _textContent.text = 'Waiting for messages...';
    });
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
        title: const Text("OTP"),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.number,
              controller: otpController,
            ),
            ElevatedButton(
                onPressed: () {
                  final AuthCredential credential = PhoneAuthProvider.credential(
                    verificationId: widget.verificationId,
                    smsCode: otpController.text.trim().toString(),
                  );

                  FirebaseAuth.instance.signInWithCredential(credential).then((authRes) {
                    if (authRes.user != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginSuccessScreen(phoneNumber: authRes.user!.phoneNumber!)),
                      );
                    }
                  });
                },
                child: const Text("Submit"))
          ],
        ),
      ),
    );
  }

  void initMessagereceiver() {}

}
