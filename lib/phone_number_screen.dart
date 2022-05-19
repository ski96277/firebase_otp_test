import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_otp_test/login_success_screen.dart';
import 'package:firebase_otp_test/phone_varify_page.dart';
import 'package:flutter/material.dart';

class PhnNumberInputScreen extends StatefulWidget {
  const PhnNumberInputScreen({Key? key}) : super(key: key);

  @override
  State<PhnNumberInputScreen> createState() => _PhnNumberInputScreenState();
}

class _PhnNumberInputScreenState extends State<PhnNumberInputScreen> {
  late TextEditingController textEditingController;

  bool isLoading=false;


  @override
  void initState() {
    textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Phone number input")),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextFormField(
              // keyboardType: TextInputType.numberWithOptions(signed: true),
              controller: textEditingController,
              decoration: const InputDecoration(
                icon: Icon(Icons.phone_android),
                hintText: '01XX XXX XXX',
                labelText: 'Phone number *',
              ),
              onSaved: (String? value) {
                // This optional block of code can be used to run
                // code when the user saves the form.
              },
              validator: (String? value) {
                return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
           isLoading?const CircularProgressIndicator(): ElevatedButton(onPressed: () async {
              log(textEditingController.text);
             setState(() {
               isLoading=true;
             });

              await FirebaseAuth.instance.verifyPhoneNumber(
                phoneNumber: textEditingController.text,
                verificationCompleted: (PhoneAuthCredential credential) {

                  setState(() {
                    isLoading=false;
                  });

                  debugPrint("verificationCompleted = $credential");
                  PhoneAuthProvider.credential(
                    verificationId: credential.verificationId.toString(),
                    smsCode: credential.smsCode!.trim().toString(),
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
                verificationFailed: (FirebaseAuthException e) {
                  setState(() {
                    isLoading=false;
                  });
                  showAlertDialog(context,e.message!);
                  debugPrint("Imran verificationFailed = $e");
                },
                codeSent: (String verificationId, int? resendToken) {
                  setState(() {
                    isLoading=false;
                  });
                  debugPrint("Imran codeSent = $verificationId");
                  debugPrint("Imran codeSent = $resendToken");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  PhoneVarifyPage(
                        phoneNumber: textEditingController.text, verificationId: verificationId)),
                  );

                },
                codeAutoRetrievalTimeout: (String verificationId) {
                  setState(() {
                    isLoading=false;
                  });
                  debugPrint("Imran codeAutoRetrievalTimeout = $verificationId");
                },
              );


            }, child: const Text("Submit"))
          ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context,String content) {

    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () { Navigator.pop(context);},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Failed"),
      content: Text(content),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
