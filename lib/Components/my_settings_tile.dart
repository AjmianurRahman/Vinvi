import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vinvi/Themes/theme_provider.dart';
class MySettingsTile extends StatelessWidget {

  final String title;
  final Widget action;
  const MySettingsTile({super.key, required this.title, required this.action});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return   Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.primary
      ),
      margin: EdgeInsets.only(left: 8, right: 8, top: 8),
      padding: EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
        Text(title, style: TextStyle(fontSize: 20,fontWeight: FontWeight.w300, color: theme.tertiary),),
        action
      ],)
    );
  }
}
