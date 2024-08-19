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
  final String title;
  final IconData icon;
  final void Function()? onTap;

  const MyDrawerTile(
      {super.key, required this.title, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w300, color: theme.tertiary),
      ),
      leading: Icon(
        icon,
        color: theme.tertiary,
      ),
      onTap: onTap,
    );
  }
}
