import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../utils/Strings.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  var showPass =  true;
  var showConPass = true;

  bool checkedValue = false;
  String? email;
  String? password;
  String? name;
  var phone;
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
                    Text(Strings.register,
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30.0,),
                   _commonTextField(
                     onChange: (value){
                       setState(() {
                         name = value;
                       });
                     },
                       hintText: Strings.name,
                       icon: Icons.person,
                       show: false,
                       isPassword: false,
                       onpress: (){}),
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
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0,top: 10.0),
                      child: Stack(
                        children: [
                          Container(height: 80.0,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                //color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0)
                            ),
                          ),
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
                             // phone = countryCode + mobileNumber;
                            },
                          ),
                        ],
                      ),
                    ),
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
                    _commonTextField(
                        hintText: Strings.confirm_password,
                        icon: Icons.remove_red_eye,
                        show: showConPass,
                        isPassword: true,
                        onpress: (){
                          if(showConPass){
                            setState(() {
                              showConPass = false;
                            });
                          }
                          else{
                            setState(() {
                              showConPass = true;
                            });
                          }
                        }, onChange: (value) {
                          setState(() {
                            confirmPassword = value;
                          });
                    }),
                    CheckboxListTile(
                        title: Text('Agree all terms and conditions*',style: TextStyle(fontSize: 20.0,color: Colors.grey),),
                        value: checkedValue,
                        onChanged: (bool? value){
                          setState(() {
                            checkedValue = value!;
                          });
                        }),
                    SizedBox(height: 20.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment:  CrossAxisAlignment.center,
                      children: [
                        MaterialButton(
                            onPressed: ()async{
                              if(confirmPassword != password){
                                Fluttertoast.showToast(msg: Strings.confirm_msg);
                              }
                              else if(name == "" || name == null || email == null || email == "" || password == null || password == "" || phone == "" || phone == null) {
                                Fluttertoast.showToast(msg: Strings.email_null_msg);
                              }
                              else if(checkedValue == false) {
                                Fluttertoast.showToast(msg: Strings.check_msg);
                              }
                              // else if(email == "") {
                              //   Fluttertoast.showToast(msg: Strings.email_null_msg);
                              // }
                              else{
                                try{
                                 await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email!, password: password!).then(
                                          (value){
                                        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                                      });
                                 _firestore.collection('user').doc(_auth.currentUser?.uid).set(
                                     {'email':email,'name':name,'phone':phone});
                                }
                                catch(e){
                                    Fluttertoast.showToast(msg: Strings.email_msg);
                                }
                              }
                            },
                          textColor: Colors.black,
                          height: 40.0,
                          color: Colors.greenAccent,
                          child: Text(Strings.register,style: TextStyle(fontSize: 18.0),),
                        )
                      ],
                    ),
                    SizedBox(height: 20.0,),
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