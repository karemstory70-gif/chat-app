import 'package:chatapp_task/screens/users_screen.dart';
import 'package:flutter/material.dart';

class Splach extends StatefulWidget {
  const Splach({super.key});

  @override
  State<Splach> createState() => _SplachState();
}

class _SplachState extends State<Splach> {

  @override
  void initState() {
    Future.delayed(Duration(seconds: 2) , (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (c)=> UsersScreen()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/Spalch/2g9aivNDMxq2VjIoppWWAdWqn89 1.png' , width: 110,height: 110,),
      ),
    );
  }
}
