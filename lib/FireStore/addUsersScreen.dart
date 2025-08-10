import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import '../LoginPage.dart';
import 'package:flutter/material.dart';
import '../Utils/utils.dart';

class AddUsersScreen extends StatefulWidget {
  const AddUsersScreen({super.key});

  @override
  State<AddUsersScreen> createState() => _AddUsersScreenState();
}

class _AddUsersScreenState extends State<AddUsersScreen> {

  bool isLoading=false;
  final _auth=FirebaseAuth.instance;
  final _insertController=TextEditingController();
 final firestoreCollection=FirebaseFirestore.instance.collection("Users");
  ///Here collection--->container of documents is like a table and name like Post is name of Table.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("User",style: TextStyle(color: Colors.white),),
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
                ///here doc is like a nod/ID under a table and we can not take nested doc like .child().child()
                ///.set({}) is used to create data.
                ///To keep all IDs unique make a Id var.and assign it
                String id=DateTime.now().microsecondsSinceEpoch.toString();
                ///agar id var. ky alawa direct dy gy at diff. places tu id ma faraq at diff. places aa sakta ha.
                ///
                /// firestoreCollection.add({}) sy---->auto Id generate ho gi.
                ///
                firestoreCollection.doc(id).set(///set ki brackets ma {} lagana zaroori han.
                    {
                      "id": id,
                      "title":_insertController.text
                    }
                ).then((v){
                  Utils().toastMessage("User Created");
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

    );
  }
}
