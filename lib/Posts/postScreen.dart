import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import '../LoginPage.dart';
import 'package:flutter/material.dart';

import '../Utils/utils.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {

  bool isLoading=false;
  final _auth=FirebaseAuth.instance;
  final _insertController=TextEditingController();

  final databaseRef=FirebaseDatabase.instanceFor(
      app: Firebase.app(),                                  ///firebase Database ka url bhi dena zarori ha.
      databaseURL: "https://fir-practice-3ad5b-default-rtdb.firebaseio.com/").ref('Post');  ///Here ref is like a table and name like Post is name of Table.

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async {
        await SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
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

        body: Padding(
          padding:const EdgeInsets.all(50),
          child: Column(
            children: [
              TextFormField(
                controller: _insertController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "What is in your Mind?",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 50,),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: (){
                  setState(() {
                    isLoading:true;
                  });
                  ///here child is like a nod/ID under a table and we can also take nested childs like .child().child()
                  ///.set({}) is used to create data.
                  ///To keep all IDs unique make a Id var.and assign it
                 String id=DateTime.now().microsecondsSinceEpoch.toString();
                 Map<String,dynamic> m={
                   "id":1,
                   "name":"umar",
                   "rollNo":2,
                   "class":"SE"
                 };
                  databaseRef.child(id).set(///set ki brackets ma {} lagana zaroori han.
                      {
                        "id": id,
                        "title":_insertController.text
                      }
                  ).then((v){
                    Utils().toastMessage("Post Created");
                    setState(() {
                      isLoading=false;
                    });
                  }).onError((e,stack){
                    Utils().toastMessage(e.toString());
                    setState(() {
                      isLoading=false;
                    });
                  });

                },
                  child:isLoading?const CircularProgressIndicator(color: Colors.white,strokeWidth: 3,):const Text("Add"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

      ),
    );
  }
}
