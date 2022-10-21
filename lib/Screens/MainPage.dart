import 'package:flutter/material.dart';
import 'package:todolist/utils/Strings.dart';
class mainPage extends StatefulWidget {
  const mainPage({Key? key}) : super(key: key);

  @override
  State<mainPage> createState() => _mainPageState();
}

class _mainPageState extends State<mainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height*.40,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/todo.webp'),
                fit: BoxFit.fill
              )
            ),
          ),
          Padding(
              padding: EdgeInsets.only(top: 260.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*.50 + 90.0,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.9),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(50.0),topRight: Radius.circular(50.0)),
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
                  SizedBox(height: 50.0,),
                  Center(
                    child: Text(
                     Strings.todo,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30.0,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  SizedBox(height: 80.0,),
                  _button(text: Strings.SignIn,onPress: (){
                    Navigator.pushNamed(context, '/login');
                  }),
                  SizedBox(height: 20.0,),
                  _button(text: Strings.SignUp,onPress: (){
                    Navigator.pushNamed(context, '/register');
                  }),
                ],
              ),
            ),  
          )
        ],
      ),
    );
  }
}

Widget _button({required String text,required VoidCallback onPress}){
  return  Container(
    height: 50.0,
    width: 150.0,
    child: MaterialButton(
        color: Colors.greenAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        onPressed: onPress,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20.0,
              color: Colors.white
          ),
        )),
  );
}