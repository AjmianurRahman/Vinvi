import 'package:flutter/material.dart';

class MyFollowButton extends StatelessWidget {
  final void Function()? onPressed;
  final bool isFollowing;

  const MyFollowButton(
      {super.key, required this.onPressed, required this.isFollowing});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: MaterialButton(
          onPressed: onPressed,
          elevation: 10,
          color: isFollowing ? theme.secondary : Colors.blue,
          padding: const EdgeInsets.all(16),
          child: Text(isFollowing ? 'Unfollow' : 'Follow',
              style: isFollowing
                  ? TextStyle(
                fontSize: 18,
                      fontWeight: FontWeight.w500, color: Colors.grey.shade700)
                  : TextStyle(
                fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.tertiary)),
        ),
      ),
    );
  }
}
