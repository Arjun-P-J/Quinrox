import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quinrox/pages/Homepage/homepage.dart';

import 'models/user_auth.dart';
import 'pages/Login/login.dart';


















class Wrapper extends StatelessWidget {

  var loginId=Login().id;

  @override
  Widget build(BuildContext context) {
    final _user=Provider.of<UserAccount?>(context)?.uid;

    if(_user==null){
      return Login();
    }
    else{
      return Homepage();
    }

  }
}
