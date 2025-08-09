import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/Utils/utils.dart';
import 'package:flutter/material.dart';

import 'Posts/postScreen.dart';

class CodeVerificationScreen extends StatefulWidget {
  String verifyCode;
  CodeVerificationScreen({super.key,required this.verifyCode});
  @override
  State<CodeVerificationScreen> createState() => _CodeVerificationScreenState();
}

class _CodeVerificationScreenState extends State<CodeVerificationScreen> {

  bool isLoading=false;
  final _verifyController=TextEditingController();
  final _auth=FirebaseAuth.instance;

  @override
  void dispose() {
    _verifyController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Verify"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(50),
        child: Column(
          children: [
            TextFormField(
              maxLength: 11,
              keyboardType: TextInputType.number,
              controller: _verifyController,
              decoration: InputDecoration(
                hintText: "6_digits_code",
              ),
            ),
            const SizedBox(height: 50,),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>PostScreen()));
              },
                child:isLoading?const CircularProgressIndicator(color: Colors.white,strokeWidth: 3,):const Text("Verify"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
