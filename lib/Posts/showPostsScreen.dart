import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/services.dart';
import '../LoginPage.dart';
import 'package:flutter/material.dart';

import '../Utils/utils.dart';
import 'postScreen.dart';

class ShowPostsScreen extends StatefulWidget {
  const ShowPostsScreen({super.key});

  @override
  State<ShowPostsScreen> createState() => _ShowPostsScreenState();
}

class _ShowPostsScreenState extends State<ShowPostsScreen> {
  
  final _auth=FirebaseAuth.instance;
  final databaseRef=FirebaseDatabase.instanceFor(
      app: Firebase.app(),                                                  ///firebase Database ka url bhi dena zarori ha.
      databaseURL: "https://fir-practice-3ad5b-default-rtdb.firebaseio.com/").ref('Post');
  ///Here ref is like a table and name like Post is name of Table.

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async {
        await SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>PostScreen()));
        },child:const Icon(Icons.add),),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.deepPurple,
          title: Text("ShowPosts",style: TextStyle(color: Colors.white),),
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
        body: Column(
          children: [
            Expanded(child: FirebaseAnimatedList(
              query: databaseRef,  ///give ref. to query
              defaultChild:const Center(child:const Text("Loading...")), ///here this text will show on screen before list displaying
              itemBuilder: (context,snapshot,animation,index){
                return ListTile(
                  title: Text(snapshot.child('title').value.toString()),  ///table ky har child ky title ki value do
                  subtitle: Text(snapshot.child('id').value.toString()),
                );
              },
            ))
          ],
        ),

      ),
    );
  }
}
