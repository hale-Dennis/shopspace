import 'package:flutter/material.dart';
import 'package:shopspace/utils/custome_theme.dart';

class CustomTextInput extends StatefulWidget {
  final String label;
  final String placeholder;
  final IconData icon;
  final bool password;
  final TextEditingController textEditingController;


  const CustomTextInput({Key? key,required this.label,
  required this.placeholder,
  required this.textEditingController,

  required this.icon,
  this.password = false}) : super(key: key);

  @override
  State<CustomTextInput> createState() => _CustomTextInputState();
}

class _CustomTextInputState extends State<CustomTextInput> {
  RegExp pass_valid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
  double password_strength = 0;
  final _formKey = GlobalKey<FormState>();

  bool validatePassword(String pass){
    String _password = pass.trim();
    if(_password.isEmpty){
      setState(() {
        password_strength = 0;
      });
    }else if(_password.length < 6 ){
      setState(() {
        password_strength = 1 / 4;
      });
    }else if(_password.length < 8){
      setState(() {
        password_strength = 2 / 4;
      });
    }else{
      if(pass_valid.hasMatch(_password)){
        setState(() {
          password_strength = 4 / 4;
        });
        return true;
      }else{
        setState(() {
          password_strength = 3 / 4;
        });
        return false;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 8),
            child: Text(
              widget.label,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          SizedBox(
            height: 56,
            child: Form(
              key: _formKey,
              child: TextFormField(
                onChanged: widget.placeholder == "password" && widget.label == "SIGN UP" ? (value){
                  _formKey.currentState!.validate();
                } : null,
                validator: (value){
                  if(value!.isEmpty){
                    return "please enter password";
                  }else{
                    bool result = validatePassword(value);
                    if(result){
                      return null;
                    }else{
                      return "check password requirement";//" Password should contain Capital, small letter & Number & Special";
                    }
                  }
                },
                controller: widget.textEditingController,
                obscureText: widget.password,
                enableSuggestions: !widget.password,
                autocorrect: !widget.password,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsetsDirectional.only(start: 22, end: 20),
                    child: Icon(
                      widget.icon,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(35)),
                    borderSide: BorderSide(width: 1, color: Colors.black),
                  ),
                  filled: true,
                  hintStyle: TextStyle(color: CustomTheme.grey),
                  hintText: widget.placeholder,
                  fillColor: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
