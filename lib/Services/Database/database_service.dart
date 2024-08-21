/*

 DATABSE SERVICE

 This class handles all the dat from and to firebase;
 _____________________________________________________

 - User profile
 - Post message
 - Likes
 - Comments
 - Account stuff (report / block/ delete account)
 - Follow / Unfollow
 - Search users

 */

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:vinvi/Models/user.dart';

class DatabaseService {
  // get instances
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  /*

   USER PROFILE

  When the user requesters we create an account for them, but lets also store
  their details in the database to display on their profile page.

  */

  //Save user info
  Future<void> saveUserInfoInFirebase(
      {required String name, required String email, required String password}) async {
    // get current uid
    String uid = auth.currentUser!.uid;
    // extract username from email
    String username = email.split('@')[0];
    // create a user profile
    UserProfile user = UserProfile(
        uid: uid, name: name, email: email, userName: username, bio: '', password: password);
    // convert user info into a map so that we can store in firebase
    final userMap = user.toMap();

    // save user info in firebase
    await db.collection("Users").doc(uid).set(userMap);
  }

  //Get User info

  Future<UserProfile?> getUserFromFirebase(String uid) async {
    try {
      // retrieve user doc from firebase
      DocumentSnapshot userDoc = await db.collection("Users").doc(uid).get();

      // convert doc to user profile
      return UserProfile.fromDocument(userDoc);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
