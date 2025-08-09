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

  final _searchController=TextEditingController();
  final _auth=FirebaseAuth.instance;
  final databaseRef=FirebaseDatabase.instanceFor(
      app: Firebase.app(),                                                  ///firebase Database ka url bhi dena zarori ha.
      databaseURL: "https://fir-practice-3ad5b-default-rtdb.firebaseio.com/").ref('Post');
  ///Here ref is like a table and name like Post is name of Table.

  @override
  void dispose() {
    _searchController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
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
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                onChanged: (v){
                  setState(() {
                    ///onChanged ma setState lena zaroori ha taqy ya har change par ui rebuild ho.List filter ma ya zaroori ha.
                  });
                },
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(child: FirebaseAnimatedList(
              query: databaseRef,  ///give ref. to query
              defaultChild:const Center(child:const Text("Loading...")), ///here this text will show on screen before list displaying
              itemBuilder: (context,snapshot,animation,index) {
                final title = snapshot.child('title').value.toString();
                if (_searchController.text.isEmpty) {
                  return ListTile(
                    title: Text(snapshot.child('title').value.toString()),
                    ///table ky har child ky title ki value do
                    subtitle: Text(snapshot.child('id').value.toString()),
                  );
                }
                else if (title.toLowerCase().contains(_searchController.text.toLowerCase())) {
                  return ListTile(
                    title: Text(snapshot.child('title').value.toString()),
                    ///table ky har child ky title ki value do
                    subtitle: Text(snapshot.child('id').value.toString()),
                  );
                }
                else
                  return const SizedBox.shrink();
              },
            )),

            // Expanded(
            //   child: StreamBuilder(
            //       stream:databaseRef.onValue,   ///here we will provide ref.onValue mean stream of  table
            //       builder: (context,snapshot){
            //     return ListView.builder(
            //       itemCount: snapshot.data!.snapshot.children.length,  ///provide length like this or give length of list then
            //         ///make list above this which we have make below.
            //         itemBuilder: (context,index){
            //       if(snapshot.hasError) {
            //          Utils().toastMessage(snapshot.error.toString());
            //       }
            //       else if(!snapshot.hasData){
            //         return Center(child: CircularProgressIndicator(),);
            //       }
            //       else {
            //         Map<dynamic,dynamic> map=snapshot.data!.snapshot.value as dynamic;///here we store all data under Post table as
            //         ///IDs are key and map like data under keys are values of above map.
            //         List<dynamic> list=map.values.toList(); ///In case of riverpod stream builder we will return this.
            //         return ListTile(
            //           title:Text(list[index]['title']),
            //           subtitle:Text(list[index]['id']),
            //         );
            //       }
            //     });
            //   }),
            // )

          ],
        ),

      ),
    );
  }
}
