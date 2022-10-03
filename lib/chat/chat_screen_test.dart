import 'package:flutter/material.dart';
import 'package:shopspace/chat/chat_details.dart';


class ChatScreenTest extends StatefulWidget {
  const ChatScreenTest({Key? key}) : super(key: key);

  @override
  State<ChatScreenTest> createState() => _ChatScreenTestState();
}

class _ChatScreenTestState extends State<ChatScreenTest> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: ElevatedButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const ChatDetail(friendName: "Hale" ,friendUid: "j6j6BwZxu6TC9XfdK7VnVTceyH92",)));
          },
          child: const Text("Press me") ,
        ),
      ),
    );
  }
}
