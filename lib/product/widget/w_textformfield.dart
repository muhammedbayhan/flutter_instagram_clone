import 'package:flutter/material.dart';

class W_TextFormField extends StatelessWidget {
  W_TextFormField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText,
      this.keyboard=TextInputType.emailAddress,
      });
  TextEditingController controller;
  String hintText;
  bool obscureText;
  TextInputType keyboard;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType:keyboard,
      controller: controller,
      decoration:
          InputDecoration(border: OutlineInputBorder(), hintText: hintText),
      obscureText: obscureText,
    );
  }
}
