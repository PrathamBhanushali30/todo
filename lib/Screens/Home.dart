import 'dart:async';

import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todolist/Screens/Profile.dart';
import 'package:todolist/Screens/description.dart';
import '../utils/Strings.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Builder(
                  builder: (context) {
                    return InkWell(
                      onTap: (){
                        Scaffold.of(context).openDrawer();
                      },
                        child: Icon(Icons.menu,size: 30.0,),
                    );
                  }
                ),
                SizedBox(width: 120.0,),
                Text(Strings.todo,style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold),),

              ],
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              height: MediaQuery.of(context).size.height-100.0,
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder(
                stream: _firestore.collection('user').doc(_auth.currentUser?.uid).collection('notes').snapshots(),
                builder: (context, snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator());
                  }
                  else{
                    final docs = snapshot.data?.docs;
                    return SizedBox(
                      height: 400.0,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                          itemCount: docs?.length,
                          itemBuilder: (context, index){
                            return InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Description(title: docs[index]['title'],description: docs[index]['description'], id: docs[index].id,)));
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(bottom: 10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.green,
                                ),
                                height: 90.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width-90,
                                            margin: EdgeInsets.only(left: 20.0),
                                            child: Text(docs![index]['title'],overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 20.0,color: Colors.black,fontWeight: FontWeight.bold),))
                                      ],
                                    ),
                                    Container(
                                      child: IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: ()async{
                                          await _firestore.collection('user').doc(_auth.currentUser?.uid).collection('notes').doc(snapshot.data?.docs[index].id).delete();
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                    );
                  }
                },
              ),
            )
            // StreamBuilder(
            //     stream: _firestore.collection('user').doc(_auth.currentUser?.uid).collection('notes').snapshots(),
            //     builder: (index,snapshot){
            //       List<TodoCard> listoftodo=[];
            //       final data=snapshot.data?.docs;
            //       for(var element in data!){
            //         listoftodo.add(TodoCard(title: element.data()['title'], data: element.data()['description'], maincontext: context, id: element.id));
            //       }
            //       return Wrap(
            //         children: listoftodo,
            //       );
            //     })
          ],
        ),
      ),
      drawer: Drawer(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width*0.80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60.0,),
             _commonDrawer(icon: Icons.person, text: Strings.profile, ontap: ()async{

               await Navigator.push(context, MaterialPageRoute(builder: (context) => profile()));
             }),
              SizedBox(height: 20.0,),
              _commonDrawer(icon: Icons.logout, text: Strings.logout,ontap: ()async{
                await _auth.signOut();
                Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
              }),
              SizedBox(height: 20.0,),
              _commonDrawer(icon: Icons.delete, text: Strings.deleteAcc,ontap: ()async{
                _firestore.collection('user').doc(_auth.currentUser?.uid).collection('notes').get().then((value) {
                  for(var element in value.docs){
                    element.reference.delete();
                  }
                });
                Timer(Duration(milliseconds: 400), () { _firestore.collection('user').doc(_auth.currentUser?.uid).delete();});
                Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
                _auth.currentUser?.delete();
              }),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamedAndRemoveUntil(context, '/add', (route) => false);
          // _firestore.collection('user').doc(_auth.currentUser?.uid).collection('notes').add({'title': 'title','description':'description'});
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

Widget _commonDrawer({required IconData icon, required String text, required VoidCallback ontap}){
  return InkWell(
    onTap: ontap,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon,size: 30.0,),
        SizedBox(width: 20.0,),
        Text(text,style: TextStyle(fontSize: 20.0),),
      ],
    ),
  );
}

// class TodoCard extends StatefulWidget {
//   const TodoCard({
//     Key? key,
//     required this.title,
//     required this.data,
//     required this.maincontext,
//     required this.id,
//   }) : super(key: key);
//   final String title;
//   final String data;
//   final String id;
//   final BuildContext maincontext;
//
//   @override
//   State<TodoCard> createState() => _TodoCardState();
// }
//
// class _TodoCardState extends State<TodoCard> with TickerProviderStateMixin {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onLongPress: () {
//         showDialog(
//             context: context,
//             builder: ((context) => AlertDialog(
//               title: const Text("Are You Sure?"),
//               content: const Text("You want to delete your TODO"),
//               actions: [
//                 TextButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: const Text("Cancle")),
//                 TextButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                       _firestore
//                           .collection("user")
//                           .doc(_auth.currentUser?.uid)
//                           .collection('notes')
//                           .doc(widget.id)
//                           .delete();
//                     },
//                     child: const Text(
//                       "Delete",
//                       style: TextStyle(color: Colors.red),
//                     ))
//               ],
//             )));
//       },
//       child: OpenContainer(
//           closedColor: Colors.black,
//           openColor: Colors.black,
//           closedShape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(32),
//           ),
//           closedElevation: 1,
//           transitionType: ContainerTransitionType.fadeThrough,
//           transitionDuration: const Duration(seconds: 1),
//           closedBuilder: ((context, action) => Container(
//             height: MediaQuery.of(widget.maincontext).size.width * 0.4,
//             width: MediaQuery.of(widget.maincontext).size.width * 0.4,
//             decoration: BoxDecoration(
//               color: Colors.black,
//               borderRadius: BorderRadius.circular(25),
//             ),
//             child: Stack(children: [
//               Positioned(
//                   top: 15,
//                   left: 10,
//                   child: SizedBox(
//                       height: 22,
//                       width: MediaQuery.of(widget.maincontext).size.width *
//                           0.3,
//                       child: Text(
//                         widget.title,
//                         overflow: TextOverflow.ellipsis,
//                       ))),
//               Positioned(
//                   top: 40,
//                   left: 10,
//                   child: SizedBox(
//                     height:
//                     MediaQuery.of(widget.maincontext).size.width * 0.3,
//                     width: (MediaQuery.of(widget.maincontext).size.width *
//                         0.4) -
//                         13,
//                     child: Text(
//                       widget.data,
//                       style: const TextStyle(color: Colors.grey),
//                       softWrap: true,
//                       overflow: TextOverflow.fade,
//                     ),
//                   ))
//             ]),
//           )),
//           openBuilder: ((context, action) => Container())),
//     );
//   }
// }