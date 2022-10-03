import 'package:flutter/material.dart';
import 'package:shopspace/chat/user.dart';

class UserCard extends StatelessWidget {
  final Users user;
  const UserCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text("${user.username}"),
                    ),
                    Text("${user.uid}")
                  ],
                ),
              ),
    );
  }
}
