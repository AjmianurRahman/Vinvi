import 'package:flutter/material.dart';
import 'package:vinvi/Models/user.dart';

class MyUserTile extends StatelessWidget {
  final UserProfile user;

  const MyUserTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(8)),
      child: ListTile(

        leading:  Icon(Icons.person_rounded,size: 32, color: Theme.of(context).colorScheme.tertiary,),
        title: Text(user.name,
            style: TextStyle(color: Theme.of(context).colorScheme.tertiary)),

        subtitle: Text('@${user.userName}',
            style: TextStyle(
                color: Theme.of(context).colorScheme.surface,
                fontSize: 14,
                fontWeight: FontWeight.w300)),
      ),
    );
  }
}
