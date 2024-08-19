import 'package:flutter/material.dart';


/*
  DRAWER TILE

  This is a siple tile for cach item in the menu drawer
  _____________________________________________________

  to use this widget, you need:
  - title
  - icon
  - function

 */

class MyDrawerTile extends StatelessWidget {
  const MyDrawerTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
       title: Text('Home'),
      leading: Icon(Icons.home_rounded),
      onTap: (){

      },
    );
  }
}
