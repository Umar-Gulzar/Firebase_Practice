import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import '../LoginPage.dart';
import 'package:flutter/material.dart';
import '../Utils/utils.dart';
import 'addUsersScreen.dart';

class ShowUsersScreen extends StatefulWidget {
  const ShowUsersScreen({super.key});

  @override
  State<ShowUsersScreen> createState() => _ShowUsersScreenState();
}

class _ShowUsersScreenState extends State<ShowUsersScreen> {

  final _updateController=TextEditingController();
  final _searchController=TextEditingController();
  final _auth=FirebaseAuth.instance;
  final firestoreCollection=FirebaseFirestore.instance.collection('Users');
  ///Here collection is like a table and name like Post is name of Table.


  Future<void> showMyDialog(String title,String id)async
  {
    _updateController.text=title;  ///Imp
    return showDialog(context: context, builder:(context){
      return AlertDialog(
        title: Text("Update"),
        content: TextFormField(
          controller: _updateController,
          maxLines: 3,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "New Data"
          ),
        ),
        actions: [
          TextButton(onPressed: (){Navigator.pop(context);}, child: Text("Cancel")),
          TextButton(onPressed: (){
            Navigator.pop(context);
            firestoreCollection.doc(id).update({
              'title':_updateController.text,///agar update my hum koi new key:value bhi daly gy tu wo uss id waly map ma add ho gy gi.
            }).then((v){
              Utils().toastMessage("User Updated");
            }).onError((e,s){
              Utils().toastMessage(e.toString());
            });
          }, child:Text("Update")),
        ],
      );
    });
  }


  @override
  void dispose() {
    _searchController.dispose();
    _updateController.dispose();
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
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddUsersScreen()));
        },child:const Icon(Icons.add),),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.deepPurple,
          title: Text("ShowUsers",style: TextStyle(color: Colors.white),),
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
            ///Method 1-by get() it give all data at once.
            // Expanded(child: FutureBuilder(
            //   ///agar hum yaha future ko firestoreCollection.doc(id-->firebase console sy copy kar ky).get().
            //   ///tu poory collection ki bajay sirf wahi document ana tha jis ki id daty.Iss soorat ma ListView.builder
            //   ///bhi nhi lena pharta kun ky hamary pass ho ga hi sirf aik doc.
            //   ///data ko iss tarah access karty--->snapshot.data!['title']---->means snapshot.data! aik doc ha yanni aik map
            //   ///iss ma .data() nhi karna kun ky .data() sy doc Id par phara Map<Strinng,dynamic> milta ha.
            //
            //     future: firestoreCollection.get(),///here we get whole collection.
            //     builder: (context,snapshot) {
            //       return ListView.builder(///.docs--->means list of all documents in collection.
            //           itemCount: snapshot.data!.docs.length,  ///total no. of documents in a collection
            //           itemBuilder: (context, index) {
            //             final title = snapshot.data!.docs[index]['title'];
            //             if (_searchController.text.isEmpty) {
            //               return ListTile(
            //                 title: Text(snapshot.data!.docs[index].data()['title']),
            //                 subtitle: Text(snapshot.data!.docs[index].data()['id'],),
            //                 trailing: PopupMenuButton(itemBuilder: (context) {
            //                   return [
            //                     PopupMenuItem(
            //                         onTap: () {
            //                           showMyDialog(snapshot.data!.docs[index].data()['title'],snapshot.data!.docs[index].data()['id']);
            //                         },
            //                         child: Row(
            //                           mainAxisAlignment: MainAxisAlignment
            //                               .spaceBetween,
            //                           children: [
            //                             Icon(Icons.edit),
            //                             Text("Edit")
            //                           ],)),
            //                     PopupMenuItem(
            //                         onTap: () {
            //                           firestoreCollection.doc(snapshot.data!.docs[index].data()['id']).delete();
            //                           ///To delete
            //                           ///here use snapshot.data!.docs[index].data()['id']
            //                           ///or use below in case of auto ID.
            //                           ///snapshot.data!.docs[index].id
            //                           ///(//)...instead of only 'id' inside the doc of collection.
            //                         },
            //                         child: Row(
            //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                           children: [
            //                             Icon(Icons.delete),
            //                             Text("Delete")
            //                           ],))
            //                   ];
            //                 }),
            //               );
            //             }
            //             else if (title.toLowerCase().contains(_searchController.text.toLowerCase())) {
            //               return ListTile(
            //                 title: Text(snapshot.data!.docs[index].data()['title']),
            //                 subtitle: Text(snapshot.data!.docs[index].data()['id']),
            //                 trailing: PopupMenuButton(itemBuilder: (context) {
            //                   return [
            //                     PopupMenuItem(
            //                         onTap: () {
            //                           showMyDialog(snapshot.data!.docs[index].data()['title'],snapshot.data!.docs[index].data()['id']);
            //                         },
            //                         child: Row(
            //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                           children: [
            //                             Icon(Icons.edit),
            //                             Text("Edit")
            //                           ],)),
            //                     PopupMenuItem(
            //                       onTap: (){
            //                         firestoreCollection.doc(snapshot.data!.docs[index].data()['id']).delete();
            //                       },
            //                         child: Row(
            //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                       children: [
            //                         Icon(Icons.delete),
            //                         Text("Delete")
            //                       ],))
            //                   ];
            //                 }),
            //               );
            //             }
            //             else
            //               return const SizedBox.shrink();
            //           });
            //     })),
///Method 2-by snapshots() it  Keep Listening (Realtime Updates) for new data
            Expanded(
              child: StreamBuilder(
                  stream:firestoreCollection.snapshots(),   ///here we will provide .snapshot() mean stream of table
                  ///.snapshots() → Opens a realtime stream — app updates automatically if collection docs  changes
                  ///
                  ///agar yaha par firestoreCollection.doc(id--->copy from firebase console).snapshots()
                  ///tu iss soorat ma poory collection ki bajay sirf aik doc ay ga.
                  ///hum data iss tarah access kary gy--->snapshot.data!['title']
                  builder: (context,snapshot) {
                    if (snapshot.hasError) {
                      Utils().toastMessage(snapshot.error.toString());
                      return Text(snapshot.error.toString());
                    }
                    else if (snapshot.connectionState==ConnectionState.waiting) {
                      return const Center(child:const CircularProgressIndicator(),);
                    }
                    else if(!snapshot.hasData){
                      return const Text('No Data here!');
                    }
                    else {
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(snapshot.data!.docs[index]['title']),
                              subtitle: Text(snapshot.data!.docs[index]['id']),
                              trailing: PopupMenuButton(itemBuilder: (context) {
                                return [
                                  PopupMenuItem(
                                      onTap: () {
                                        showMyDialog(snapshot.data!.docs[index].data()['title'],snapshot.data!.docs[index].data()['id']);
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(Icons.edit),
                                          Text("Edit")
                                        ],)),
                                  PopupMenuItem(
                                      onTap: (){
                                        firestoreCollection.doc(snapshot.data!.docs[index].data()['id']).delete();
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(Icons.delete),
                                          Text("Delete")
                                        ],))
                                ];
                              }),
                            );
                          }
                      );
                    }
                  }
              ),
            )

          ],
        ),

      ),
    );
  }
}
