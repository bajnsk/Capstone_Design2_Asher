import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class feedpage extends StatefulWidget {
  const feedpage({super.key});

  @override
  State<feedpage> createState() => _feedpageState();
}

class _feedpageState extends State<feedpage> {
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;

  void getCurrentUser(){
    try{
      final user = _authentication.currentUser;
      if(user != null) {
        loggedUser = user;
        print(loggedUser!.email);
      }
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('feed'),
      ),
      body: Center(
        child: Text('feed'),
      ),
    );
  }
}