import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';

class Storage {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String getCurrentUserId(){
    final User? user = _auth.currentUser;
    final uid = user?.uid;
    print(uid);
    return uid.toString();
    //print(uemail);
  }
  final firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  Future<void> uplaodFile(String filePath, String fileName)async{
    File file = File(filePath);
    String uid = getCurrentUserId();

    try{
      await storage.ref('user_images/$uid/$fileName').putFile(file);
    }on FirebaseException catch (e){
      print(e);
    }
  }

  Future<String> downloadURL(String imageName) async{
    String uid = getCurrentUserId();
    String downloadURL = await storage.ref('user_images/$uid/$imageName').getDownloadURL();

    return downloadURL;
  }
}