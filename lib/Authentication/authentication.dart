import "package:firebase_auth/firebase_auth.dart";

import "../models/user_auth.dart";





















class Authenticate{

  FirebaseAuth _auth= FirebaseAuth.instance;

  //conversion
  UserAccount? _userFromFirestore(User? user){
    return user!=null?UserAccount(uid:user.uid,email: user.email):null;
  }

  //stream
  Stream<UserAccount?> get authChanges{
    return _auth.authStateChanges().map(_userFromFirestore);
  }


  //login
  Future<UserAccount?> signIn(String email,String password) async{
    try {
      UserCredential _userCredentials=await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? _user=_userCredentials.user;

      return _userFromFirestore(_user);
    }  catch (e) {
      print(e.toString());
      return null;
    }
  }

  //signup
  Future<UserAccount?> signUp(String email,String password) async{
    try {
      UserCredential _userCredentials=await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? _user=_userCredentials.user;

      return _userFromFirestore(_user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //signout
  Future<void> signOut() async{
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }


}