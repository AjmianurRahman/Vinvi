import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


  /*

  INPUT ALERT BOX

  This is an alert box that has a textfiels where the user can type in.
  We will use this for things like editing bio, posting a new message, etc.
  _________________________________________________________________________

  To use this widget , you need:
  - text controler
  - hint text
  - a function
  - a text for the button
 */

class MyInputAlertBox extends StatelessWidget {
  final TextEditingController controller;
  final String  text, hintText;
  final void Function()? onpressed;

  const MyInputAlertBox({super.key, required this.controller, required this.text, required this.hintText, this.onpressed});


  //BUILD THE UI
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return AlertDialog(
      elevation: 10,
      title: Row(children: [
        Icon(Icons.settings, color: theme.primary),
        SizedBox(width: 8,),
        Text('Edit bio...', textAlign: TextAlign.left)
      ],),
      titleTextStyle: TextStyle(color: theme.primary, fontSize: 16),
      shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor:theme.surface ,
      content: TextField(
        maxLines: 3,
controller: controller,
        style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15),
        maxLength: 140,
        decoration: InputDecoration(
          hintText: hintText,
          counterStyle: TextStyle(color: theme.primary, fontSize: 12),
          hintMaxLines: 1,
          filled: true,
          fillColor: theme.secondary,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: theme.secondary, width: 1.5)
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: theme.primary, width: 1.5)
          ),

        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(context);
          controller.clear();
        }, child: Text('Cancel')),

        TextButton(onPressed: (){
          Navigator.pop(context);
          //exicute function
          onpressed!();
          controller.clear();
        }, child: Text(text)),
      ],
    );
  }
}
