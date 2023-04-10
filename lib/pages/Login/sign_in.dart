import 'package:flutter/material.dart';

import '../../Authentication/authentication.dart';
import '../../constants/decorations.dart';
import '../../constants/loading.dart';


















class SignIn extends StatefulWidget {
  Function toggleView;
  SignIn({required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  Authenticate _auth=Authenticate();

  final _key=GlobalKey<FormState>();

  bool loading=false;

  String email="";
  String password="";
  String error="";

  @override
  Widget build(BuildContext context) {
    return  loading?Loading():Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff282828),
        title: Text("Sign In"),
        actions: [
          IconButton(icon:
          Icon(Icons.person),
            onPressed: (){
              widget.toggleView();
            },
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: ClipOval(
                        child: Image.asset("assets/LogoSpectrum.png")
                    ),
                      radius: 100,
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    onChanged: (val){
                      setState(() {
                        email=val;
                      });
                    },
                    validator: (val)=>val!.isEmpty?"Enter the email":null,
                    decoration: decorationTextBox.copyWith(hintText: "Email"),
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    obscureText: true,
                    onChanged: (val){
                      setState(() {
                        password=val;
                      });
                    },
                    validator: (val)=>val!.length<6?"Please enter a password 6+ characters long":null,
                    decoration: decorationTextBox.copyWith(hintText: "Password",),
                  ),
                  SizedBox(height: 20,),
                  OutlinedButton(
                    child: Text("Submit"),
                    onPressed: () async{

                      if(_key.currentState!.validate()){
                        setState(() {
                          loading=true;
                        });
                      }

                      dynamic response=await _auth.signIn(email, password);

                      if(response==null){
                        setState(() {
                          error="Please enter a avlid email or password";
                        });
                      }

                    },
                  ),
                  SizedBox(height: 20,),
                  Text("$error",style: TextStyle(
                    color: Colors.redAccent,
                  ),),
                  SizedBox(height: 20,),
                  Text("By Team Nucleus",style: TextStyle(
                    fontSize: 10
                  ),)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
