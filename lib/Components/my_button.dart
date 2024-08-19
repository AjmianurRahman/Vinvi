import 'package:flutter/material.dart';


  /*
  Button

  to use this widget, you need;
  - text
  - a function
   */
class MyButton extends StatelessWidget {
  final text;
  final void Function()? onTap;
  const MyButton({super.key,required this.text,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(child: Text(text, style: TextStyle(color: Theme.of(context).colorScheme.tertiary,fontWeight: FontWeight.w300, fontSize: 18))),
      ),
    );
  }
}
