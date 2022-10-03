import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../utils/custome_theme.dart';
import 'loader.dart';

class ProfileListButton extends StatelessWidget{
  final IconData icon;
  final String text;
  final void Function() onPress;
  final bool loading;
  const ProfileListButton({Key? key, required this.text, required this.icon,required this.onPress, this.loading = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20,),
      height: 40,
      width: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        color: Colors.grey[200],
      ),
      child: MaterialButton(
          onPressed: loading ? null : onPress,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Row(
                  children: [
                    Icon(icon,
                    color: CustomTheme.yellow,),
                    SizedBox(width: 20,),
                    loading ?
                    const Loader()
                        : Text(
                      text,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),

                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_sharp, color: Colors.grey, ),
            ],
          )
      ),
    );
  }

}