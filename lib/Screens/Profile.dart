import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var email;
  var phone;

  @override
  void initState() {
    // TODO: implement initState
//    getUserProfileData();
    super.initState();
  }

  // void getUserProfileData() async {
  //   DocumentSnapshot snapshot = await _firestore
  //       .collection('user')
  //       .doc(_auth.currentUser!.uid)
  //       .get(GetOptions());
  //   print(snapshot.data());
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
      future: _firestore
          .collection('user')
          .doc(_auth.currentUser!.uid)
          .get(GetOptions()),
        builder: (BuildContext context, snapshot) {
        if(snapshot.hasData){
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Center(
              child: Container(
                height: MediaQuery.of(context).size.height*0.50,
                width: MediaQuery.of(context).size.width-40.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(snapshot.data!['name'],style: TextStyle(fontSize: 40.0,fontWeight: FontWeight.bold),),
                    SizedBox(height: 20.0,),
                    Text(snapshot.data!['email'],style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                    SizedBox(height: 20.0,),
                    Text(snapshot.data!['phone'],style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                    SizedBox(height: 20.0,),
                    FloatingActionButton(
                      backgroundColor: Colors.blue,
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back,color: Colors.white,size: 50.0,),
                    )
                  ],
                ),
              ),
            ),
          );
        }else{
          return Center(child:Text('No data found'));
        }
        }),
    );
  }
}
