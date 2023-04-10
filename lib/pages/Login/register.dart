import 'package:flutter/material.dart';
import 'package:quinrox/services/api/api_handler.dart';

import '../../Authentication/authentication.dart';
import '../../constants/decorations.dart';
import '../../constants/loading.dart';


















class Register extends StatefulWidget {
  Function toggleView;
  Register({required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final Authenticate _auth=Authenticate();
  final AuthModule _authModule=AuthModule();

  bool loading=false;

  final _key=GlobalKey<FormState>();

  String firstName="";
  String lastName="";
  String industryName="";
  String email="";
  String password="";
  String error="";

  @override
  Widget build(BuildContext context) {
    return loading?Loading():Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff282828),
        title: Text("Register"),
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
                  SizedBox(height: 20,),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: ClipOval(
                        child: Image.asset("assets/LogoSpectrum.png")
                    ),
                    radius:100,
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    onChanged: (val){
                      setState(() {
                        firstName=val;
                      });
                    },
                    validator: (val)=>val!.isEmpty?"Enter the firstName":null,
                    decoration: decorationTextBox.copyWith(hintText: "First Name"),
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    onChanged: (val){
                      setState(() {
                        lastName=val;
                      });
                    },
                    validator: (val)=>val!.isEmpty?"Enter the email":null,
                    decoration: decorationTextBox.copyWith(hintText: "Last Name"),
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    onChanged: (val){
                      setState(() {
                        industryName=val;
                      });
                    },
                    validator: (val)=>val!.isEmpty?"Enter the email":null,
                    decoration: decorationTextBox.copyWith(hintText: "Industry Name"),
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
                    decoration: decorationTextBox.copyWith(hintText: "password"),
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

                      dynamic response=await _auth.signUp(email, password);
                      dynamic responseAuth=await  _authModule.authReg(firstName, lastName, email, industryName);

                      if(response==null || responseAuth == null){
                        setState(() {
                          error="Please enter a avlid email or password";
                        });
                      }
                      print("responses are $response and $responseAuth");

                    },
                  ),
                  SizedBox(height: 20,),
                  Text("$error",style: TextStyle(
                    color: Colors.redAccent,
                  ),),

                  SizedBox(height: 5,),
                  Text("By team Nuclues",style: TextStyle(fontSize: 10),)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
