import 'package:flutter/material.dart';

/*

USER BIO BOX

 This is a simple box with text inside.
 We will use this for the user bio on their profile pages.
 _________________________________________________________
 */

class MyBioBox extends StatelessWidget {
  final String text;

  const MyBioBox({super.key, required this.text});

  //BUTTON UI

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return Container(
        padding: EdgeInsets.all(12),
        //margin: EdgeInsets.all(8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: theme.secondary),
        child: Text( text.isNotEmpty ? text : 'Empty bio...',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
        ));
  }
}
