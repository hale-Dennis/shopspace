import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopspace/chat/user.dart';
import 'package:shopspace/chat/user_card.dart';

import 'chat_details.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Users> _userList = [];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getUserList();
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _userList.length,
      itemBuilder: (context, index){
        return ListTile(
            title: UserCard(user: _userList[index]),
            onTap: (){
              var id = _userList[index].uid.toString();
              var name = _userList[index].username.toString();
              Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatDetail(friendUid: id, friendName: name ,)));
            },
        );
      },
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String getCurrentUserId(){
    final User? user = _auth.currentUser;
    final uid = user?.uid;
    print(uid);
    return uid.toString();
    //print(uemail);
  }

  Future getUserList() async{
    final  uid = getCurrentUserId();
    var data = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('properties')
            .doc('chats')
            .collection('contacts')
            .get();
    setState((){
      _userList = List.from(data.docs.map((doc)=> Users.fromSnapshot(doc)));
    });
  }
}
