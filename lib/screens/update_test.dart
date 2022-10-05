import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UpdateTest extends StatefulWidget {
  const UpdateTest({Key? key}) : super(key: key);

  @override
  State<UpdateTest> createState() => _UpdateTestState();
}

class _UpdateTestState extends State<UpdateTest> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String getCurrentUserId(){
    final User? user = _auth.currentUser;
    final uid = user?.uid;
    print(uid);
    return uid.toString();
    //print(uemail);
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          final docUser = FirebaseFirestore.instance.collection('users').doc(getCurrentUserId()).collection('properties').doc('private information');
          await docUser.update({
            'phone': "1244",
            'dob' : '12/23/2',
            'insta' : 'my instagram',
            'locaction' : 'Kumasi'
          });
          print("done");
        },
        child: Text("Press me"),
      ),
    );
  }
}
