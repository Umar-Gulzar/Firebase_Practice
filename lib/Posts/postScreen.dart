import 'package:firebase_auth/firebase_auth.dart';
import '../LoginPage.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {

  final _auth=FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple,
        title: Text("Post",style: TextStyle(color: Colors.white),),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: "Log Out",
              onPressed: (){
            _auth.signOut().then((v){  ///First signOut then move to login page.
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
            });
          }, icon:Icon(Icons.logout)),
        ],
      ),
    );
  }
}
