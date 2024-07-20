import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String hintText;
  final RegExp regEx ;
  final bool obscureText;
  final  void Function(String?) onSaved;
  final height;
  const CustomFormField(
      {super.key, required this.hintText, this.obscureText = false, required this.onSaved, this.height, required this.regEx});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextFormField(
        validator:(value){
          if(value!=null && regEx.hasMatch(value)){
            return null; 
          }else
          {
            return 'Input correct Email !';
          }
        },
        decoration: InputDecoration(
          hintText: hintText,
          border: const OutlineInputBorder(),
        ),
        obscureText: obscureText,
        onSaved: onSaved,
      ),
    );
  }
}
