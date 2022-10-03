import 'package:flutter/material.dart';

class ViewDate extends StatelessWidget {
  final String date;
  final int views;
  const ViewDate({Key? key, required this.date, required this.views}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.remove_red_eye_outlined, /*color: Colors.grey*/),
            Text("views: " + views.toString(), /*style: TextStyle(color: Colors.grey)*/),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.timelapse, /*color: Colors.grey,*/),
            Text("posted: " + date, /*style: TextStyle(color: Colors.grey)*/),
          ],
        ),

      ],
    );
  }
}
