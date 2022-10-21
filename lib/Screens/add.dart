import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Add extends StatefulWidget {
  const Add({Key? key}) : super(key: key);

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
FirebaseAuth _auth = FirebaseAuth.instance;

addtasktofirebase()async{
  await _firestore.collection('user').doc(_auth.currentUser?.uid).collection('notes').add({
    'title':titleController.text,
    'description':descriptionController.text
  });
  print("data added");
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 50.0,),
          _commonTextField("Title",titleController),
          SizedBox(height: 20.0,),
          _commonTextField("Discription",descriptionController),
          SizedBox(height: 30.0,),
          ElevatedButton(
              onPressed: (){
                addtasktofirebase();
                Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
              },
              child: Text("Submit")),
        ],
      ),
    );
  }
}

Widget _commonTextField(String text, TextEditingController controller){
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      hintText: text,
    ),
  );
}