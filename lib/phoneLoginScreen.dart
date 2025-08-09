import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/Utils/utils.dart';
import 'package:firebase_practice/codeVerificationScreen.dart';
import 'package:flutter/material.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {

  bool isLoading=false;
  final _phoneController=TextEditingController();
  final _auth=FirebaseAuth.instance;

  @override
  void dispose() {
    _phoneController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Login"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(50),
        child: Column(
          children: [
            TextFormField(
              maxLength: 11,
              keyboardType: TextInputType.number,
              controller: _phoneController,
              decoration: InputDecoration(
                hintText: "+92 1111111111",
              ),
            ),
            const SizedBox(height: 50,),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: (){
                _auth.verifyPhoneNumber(                     ///first, verify the phone no.
                    phoneNumber: _phoneController.text,      ///here, we provide inputed phone no.
                    verificationCompleted: (v){},
                    verificationFailed: (e){
                      Utils().toastMessage(e.toString());
                    },
                    codeSent:(String verficationID,int? token){///jab hi phone no par code sent ho tab hi verification screen par chaly jao.
                      ///iss verficationID ko user jo token/code input kary ga uss ky sath verify karna ha.
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>CodeVerificationScreen(verifyCode: verficationID,)));
                    },
                    codeAutoRetrievalTimeout: (e){
                      Utils().toastMessage(e.toString());      ///after timeout/code expire then exception will come.
                    }
                );
                },
                child:isLoading?const CircularProgressIndicator(color: Colors.white,strokeWidth: 3,):const Text("Login"),
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
