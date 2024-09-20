import 'package:flutter/material.dart';
import 'package:vinvi/Models/post.dart';
import 'package:vinvi/Pages/PostPage.dart';
import 'package:vinvi/Pages/account_settings_page.dart';
import 'package:vinvi/Pages/blocked_user_page.dart';
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

void goToBlockedUserPage(BuildContext context) {
  //Navigate to the page
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => BlockedUserPage()));
}

void goToAccountSettingsPage(BuildContext context) {
  //Navigate to the page
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => AccountSettingsPage()));
}