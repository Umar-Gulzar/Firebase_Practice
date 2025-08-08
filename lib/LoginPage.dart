import 'package:firebase_practice/Posts/postScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'SignupPage.dart';
import 'Utils/utils.dart';

class Login extends StatefulWidget
{
  State<Login> createState()=>LoginState();
}
class LoginState extends State<Login>
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
    return WillPopScope(
      onWillPop: ()async {
        await SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.deepPurple,
          title: Text("Login",style: TextStyle(color: Colors.white),),
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
                      _auth.signInWithEmailAndPassword(
                        email:emailController.text,
                        password:passwordController.text,
                      ).then((v){
                        Utils().toastMessage(v.user!.email.toString());
                        setState(() {
                          isLoading=false;
                        });
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>PostScreen()));
                      }).onError((error,stack){
                        Utils().toastMessage(error.toString());
                        setState(() {
                          isLoading=false;
                        });
                      });
                    }
                },
                  child:isLoading?const CircularProgressIndicator(color: Colors.white,strokeWidth: 3,):const Text("Login"),
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
                  const Text("Don't have an Acoount?"),
                  TextButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Signup()));
                  },
                      child:const Text("Signup",
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
      ),
    );
  }
}