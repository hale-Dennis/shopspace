import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'common.dart';


enum ApplicationLoginState{
  loggedOut,
  loggedIn
}

class ApplicationState extends ChangeNotifier{
  User? user;
  ApplicationLoginState loginState = ApplicationLoginState.loggedOut;


  ApplicationState(){
    init();
  }

  Future<void> init()async{
    FirebaseAuth.instance.userChanges().listen((userFir) {
      if(userFir != null){
        loginState = ApplicationLoginState.loggedIn;
        user = userFir;
      }else{
        loginState = ApplicationLoginState.loggedOut;
      }
      notifyListeners();
    });
  }

  //get id of current user
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String getCurrentUserId(){
    final User? user = _auth.currentUser;
    final uid = user?.uid;
    print(uid);
    return uid.toString();
    //print(uemail);
  }

  //get email of current user
  String getCurrentUserEmail(){
    final User? user = _auth.currentUser;
    final uemail = user?.email;
    print(uemail);
    return uemail.toString();
    //print(uemail);
  }


  Future<void> signIn(String email, String password,
      void Function(FirebaseAuthException e) errorCallBack) async{
      try{
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      } on FirebaseAuthException catch (e) {
        errorCallBack(e);
      }
  }


  Future<void> signUp(String email, String password,
      void Function(FirebaseAuthException e) errorCallBack) async{
    try{
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      //await CommonUtil.backendCall(userCredential.user!, CommonUtil.stripeUserCreate);
      //add user to firestore database
      var uid = getCurrentUserId();
      var uemail = getCurrentUserEmail();
      final docUser = FirebaseFirestore.instance.collection('users').doc(uid).collection('properties').doc('private information');
      final json = {
        'user_email': uemail,
        'user_id' : uid,
      };
      await docUser.set(json);
    } on FirebaseAuthException catch (e) {
      errorCallBack(e);
    }
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
