import 'package:flutter/material.dart';
import 'package:vinvi/Models/post.dart';
import 'package:vinvi/Pages/PostPage.dart';
import 'package:vinvi/Pages/profile_page.dart';

void goUserPage(BuildContext context, String uid) {
  //Navigate to the page
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => ProfilePage(uid: uid)));
}

void goPostPage(BuildContext context, Post post) {
  //Navigate to the page
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => Postpage(post: post,)));
}