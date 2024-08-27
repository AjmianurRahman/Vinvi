import 'package:flutter/material.dart';
import 'package:vinvi/Models/post.dart';


/*

POST PAGE

This page displays
- individual post
- comment on this post
 */

class Postpage extends StatefulWidget {
  final Post post;
  const Postpage({super.key, required this.post});

  @override
  State<Postpage> createState() => _PostpageState();
}

class _PostpageState extends State<Postpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
