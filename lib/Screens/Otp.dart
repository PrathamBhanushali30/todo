import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';
import 'package:todolist/Screens/PhoneLogin.dart';
import 'package:todolist/Screens/Register.dart';

import '../utils/Strings.dart';

class otp extends StatefulWidget {
  const otp({Key? key}) : super(key: key);

  @override
  State<otp> createState() => _otpState();
}

class _otpState extends State<otp> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  var otp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 50.0,
          ),
          Center(
              child: Text(
                "Enter the OTP",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              )),
          SizedBox(
            height: 90.0,
          ),
          Pinput(
            length: 6,
            showCursor: true,
            defaultPinTheme: PinTheme(
                width: 56,
                height: 56,
                textStyle: TextStyle(
                    fontSize: 30.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(20),
                )),
            onChanged: (value) {
              otp = value;
            },
          ),
          SizedBox(
            height: 30.0,
          ),
          Center(
            child: SizedBox(
              height: 30.0,
              width: 150.0,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    PhoneAuthCredential credential =
                    PhoneAuthProvider.credential(
                        verificationId: loginWithPhone.verify,
                        smsCode: otp);
                    await auth.signInWithCredential(credential);
                       DocumentSnapshot snapshot = await _firestore
                           .collection('user').doc(auth.currentUser?.uido).get(GetOptions());
                    print(snapshot.data());
                    if(snapshot.data()==null){
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Register()), (route) => false);
                    }else{
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/home', (route) => false);

                    }
                    /*
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/home', (route) => false);
*/
                  } catch (e) {
                    Fluttertoast.showToast(msg: Strings.wrong_otp);
                  }
                },
                child: Text(
                  'verify',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
          )
        ],
      ),

    );
  }
}
