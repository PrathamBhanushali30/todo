import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todolist/Screens/MainPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todolist/Screens/Otp.dart';
import 'package:todolist/Screens/PhoneLogin.dart';
import 'Screens/Home.dart';
import 'Screens/Login.dart';
import 'Screens/Register.dart';
import 'Screens/add.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, usersnapshot){
          if(usersnapshot.hasData){
            return Home();
          }
          else {
            return mainPage();
          }
        },
      ),
      routes: {
        '/main':(context) => mainPage(),
        '/register': (context) => Register(),
        '/login': (context) => Login(),
        '/home': (context) => Home(),
        '/phone':(context) => loginWithPhone(),
        '/otp':(context) => otp(),
        '/add':(context) => Add(),
      },
    );
  }
}
