import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/FirebaseStorage/imageUpload.dart';
import 'package:firebase_practice/LoginPage.dart';
import 'package:flutter/material.dart';

import 'FireStore/showUsersScreen.dart';
import 'Posts/postScreen.dart';
import 'Posts/showPostsScreen.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  final _currentUser=FirebaseAuth.instance.currentUser; ///To check if user is already logged we take currentUser.

  @override
  void initState() {

    Timer(Duration(seconds: 2),(){
      if(_currentUser==null)  ///If currentUser is null means it is not logged then move to login screen.
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
      else    ///if currentUser is not null means user is already logged then move to home screen.
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ImageUpload()));
    });

    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: const Center(
        child: const Text("FireBase",style: TextStyle(color: Colors.black,fontSize: 30),),
      ),
    );
  }
}
