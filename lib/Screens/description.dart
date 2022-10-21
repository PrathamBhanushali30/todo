import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Description extends StatefulWidget {
  final String title,description,id;
  const Description({Key? key, required this.title, required this.description,required this.id}) : super(key: key);

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    titleController.text = widget.title;
    descriptionController.text = widget.description;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Description"),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: TextFormField(
                controller: titleController,
              )
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: TextFormField(
                controller: descriptionController,
              )
            ),
            ElevatedButton(onPressed: ()async{
              await _firestore.collection('user').doc(_auth.currentUser?.uid).collection('notes').doc(widget.id).update(
                  {
                    'title': titleController.text,
                    'description': descriptionController.text
                  });
              Navigator.pop(context);
            }, child: Text("update"))
          ],
        ),
      ),
    );
  }
}
