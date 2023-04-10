import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:quinrox/pages/Login/register.dart';
import 'package:quinrox/pages/Login/sign_in.dart';























class Login extends StatefulWidget {
  final String id="Login";

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  bool showSignIn=true;

  void toggleView(){
    setState(() {
      showSignIn=!showSignIn;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialization();
  }

  void initialization() async{
    print("initialization");
    await Future.delayed(Duration(seconds: 2));
    FlutterNativeSplash.remove();
    print("flash screen completede");
  }

  @override
  Widget build(BuildContext context) {
    if(showSignIn){
      return SignIn(toggleView: toggleView);
    }
    else{
      return Register(toggleView: toggleView);
    }
  }
}