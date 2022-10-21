import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../utils/Strings.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  var showPass =  true;
  var showConPass = true;

  bool checkedValue = false;
   String? email;
   String? password;
   String? name;
   String? phone;
   String? confirmPassword;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height*.40,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/todo.webp'),
                    fit: BoxFit.fill
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 270.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.9),
                    borderRadius: BorderRadius.only(topRight: Radius.circular(50.0), topLeft: Radius.circular(50.0)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(.3),
                          blurRadius: 2,
                          spreadRadius: 1.5,
                          offset: Offset(0.0,-5.0)
                      )
                    ]
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20.0,),
                    Text(Strings.Login,
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30.0,),
                    _commonTextField(
                        hintText: Strings.email,
                        icon: Icons.email,
                        show: false,
                        isPassword: false,
                        onpress: (){}, onChange: (value) {
                      setState(() {
                        email = value;
                      });
                    }),
                    _commonTextField(
                        hintText: Strings.password,
                        icon: Icons.remove_red_eye,
                        show: showPass,
                        isPassword: true,
                        onpress: (){
                          if(showPass){
                            setState(() {
                              showPass = false;
                            });
                          }
                          else{
                            setState(() {
                              showPass = true;
                            });
                          }
                        }, onChange: (value) {
                      setState(() {
                        password = value;
                      });
                    }),
                    SizedBox(height: 20.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment:  CrossAxisAlignment.center,
                      children: [
                        MaterialButton(
                          onPressed: () async{
                            if(email == "" || email == null || password == "" || password == null){
                              await Fluttertoast.showToast(msg: Strings.email_null_msg);
                            }
                            else{
                              FirebaseAuth.instance.signInWithEmailAndPassword(email: email!, password: password!).then(
                                      (value){
                                    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                                  }).catchError((e) {
                                Fluttertoast.showToast(msg: Strings.email_does_not_exist);
                              });
                            }
                          },
                          textColor: Colors.black,
                          height: 40.0,
                          color: Colors.greenAccent,
                          child: Text(Strings.Login,style: TextStyle(fontSize: 18.0),),
                        )
                      ],
                    ),
                    SizedBox(height: 20.0,),
                    InkWell(
                      onTap: (){
                        Navigator.pushNamedAndRemoveUntil(context, '/phone', (route) => false);
                      },
                      child: Text(Strings.login_phone,style: TextStyle(fontSize: 20.0,color: Colors.grey),),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget _commonTextField ({required String hintText, required IconData icon, required bool show, required bool isPassword, required VoidCallback onpress, required Function(String) onChange}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
    child: TextFormField(
      onChanged: onChange,
      style: TextStyle(fontSize: 20.0,fontFamily: 'Montserrat'),
      obscureText: show,
      decoration: InputDecoration(
          hintStyle: TextStyle(
            fontSize: 20.0,
          ),
          hintText: hintText,
          suffixIcon:  isPassword
              ? IconButton(
              onPressed: onpress,
              icon: show
                  ? const Icon(Icons.visibility)
                  : const Icon(Icons.visibility_off))
              : Icon(icon),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(color: Colors.black)
          )
      ),
    ),
  );
}