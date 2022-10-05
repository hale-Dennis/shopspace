import 'package:flutter/material.dart';
import 'package:shopspace/chat/user.dart';

class UserCard extends StatelessWidget {
  final Users user;
  const UserCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text("${user.username}");


  }


}
