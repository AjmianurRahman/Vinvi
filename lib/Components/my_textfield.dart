import 'package:flutter/material.dart';

/*
  TEXT FIELD

  a box user to type
  ____________________________
  to use this widget you need:
  - text controller
  - hint text
  - obscure text(e.g. true or false)
 */

class MyTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const MyTextfield(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        obscureText: obscureText,
        controller: controller,
        style: TextStyle(fontWeight: FontWeight.w300),
        decoration: InputDecoration(
          fillColor: theme.secondary,
          filled: true,
          hintText: hintText,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: theme.secondary, width: 1.5)
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: theme.primary, width: 1.5)),
        ),
      ),
    );
  }
}
