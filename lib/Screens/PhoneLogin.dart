import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todolist/utils/Strings.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class loginWithPhone extends StatefulWidget {
  const loginWithPhone({Key? key}) : super(key: key);

  static String verify = "";

  @override
  State<loginWithPhone> createState() => _loginWithPhoneState();
}

class _loginWithPhoneState extends State<loginWithPhone> {

  String? phone;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth=FirebaseAuth.instance;
// Future<bool> checkExist()async{
//   var exist=false;
// try{
//   var data= _firestore.collection('user').where('phone',isEqualTo: phone).get().then((value) {
//     if(value.size>0){
//       exist=true;
//     } else{
//       exist=false;
//     }
//
//   });
//   return true;
// }catch(e){
//   return false;
// }
//
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 60.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(Strings.login_phone,style: TextStyle(color: Colors.black,fontSize: 30.0,fontWeight: FontWeight.bold),),
            ],
          ),
          SizedBox(height: 150.0,),
          IntlPhoneField(
            // controller: controllerMob,
            decoration: InputDecoration(
              hintText: Strings.mob,
              //labelText: string.mob,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            initialCountryCode: 'IN',
            onChanged: (value) {
              phone = value.completeNumber;
            },
          ),
          SizedBox(height: 50.0,),
          Center(
            child: SizedBox(
              height: 40.0,
              width: 150.0,
              child: ElevatedButton(
                  onPressed: () async{

                      // Navigator.pushNamedAndRemoveUntil(context, '/otp', (route) => false);
                      await FirebaseAuth.instance.verifyPhoneNumber(
                        phoneNumber: phone,
                        verificationCompleted: (PhoneAuthCredential credential) {},
                        verificationFailed: (FirebaseAuthException e) {},
                        codeSent: (String verificationId, int? resendToken) {
                          loginWithPhone.verify = verificationId;
                          Navigator.pushNamedAndRemoveUntil(context, '/otp', (route) => false);
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {},
                      );
                  },
                  child: Text("Verify")),
            ),
          )
        ],
      ),
    );
  }
}
