import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'Utils/utils.dart';

class Signup extends StatefulWidget
{
  State<Signup> createState()=>SignupState();
}
class SignupState extends State<Signup>
{
  bool isLoading=false;
  final _formKey=GlobalKey<FormState>();
  final emailController=TextEditingController();
  final passwordController=TextEditingController();
  final _auth=FirebaseAuth.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Signup",style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: "Email",
                      prefixIcon:Icon(Icons.email),
                    ),
                    validator: (v)
                    {
                      if(v!.isEmpty)
                        return "Empty Field";
                      else if(!v!.contains('@'))
                        return "Invalid Email";
                      return null;
                    },
                  ),
                  const SizedBox(height: 30,),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Password",
                      prefixIcon:Icon(Icons.lock_open),
                    ),
                    validator: (v){
                      if(v!.isEmpty)
                        return "Empty Field";
                      if(v!.length<8)
                        return "Minimum 8 characters";
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50,),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: (){
                if(_formKey.currentState!.validate())
                {
                  setState(() {
                    isLoading=true;
                  });
                  _auth.createUserWithEmailAndPassword(
                      email:emailController.text,
                      password:passwordController.text,
                  ).then((v){
                    Utils().toastMessage("Saved");
                    setState(() {
                      isLoading=false;
                    });
                  }).onError((error,stack){
                    Utils().toastMessage(error.toString());
                    setState(() {
                      isLoading=false;
                    });
                  });
                }
              },
                child:isLoading?const CircularProgressIndicator(color: Colors.white,strokeWidth: 3,):const Text("Signup"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an Acoount?"),
                TextButton(onPressed: (){
                  Navigator.pop(context);
                },
                    child:const Text("Login",
                      style:const TextStyle(
                          color: Colors.deepPurple,
                      ),
                    )
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}