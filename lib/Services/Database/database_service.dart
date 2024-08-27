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
import 'package:vinvi/Models/post.dart';
import 'package:vinvi/Models/user.dart';
import 'package:vinvi/Services/Auth/auth_service.dart';

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
      {required String name,
      required String email,
      required String password}) async {
    // get current uid
    String uid = auth.currentUser!.uid;
    // extract username from email
    String username = email.split('@')[0];
    // create a user profile
    UserProfile user = UserProfile(
        uid: uid,
        name: name,
        email: email,
        userName: username,
        bio: '',
        password: password);
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

  // Update user bio
  Future<void> updateUserBioInFirebase(String bio) async {
    // get current user Id
    String uid = AuthService().getUid();
    // attempt to update in firebase
    try {
      await db.collection('Users').doc(uid).update({'bio': bio});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /*

  POST MESSAGE

   */

  // Post a message
  Future<void> postMessageInFirebase(String message) async {
    try {
      // get current user uid
      String uid = auth.currentUser!.uid;

      // use this uid to get user's profile
      UserProfile? user = await getUserFromFirebase(uid);
      // create a new post
      CollectionReference collectionReference = db.collection('Posts');
      String id = collectionReference.doc().id;
      Post newPost = Post(
          id: id,
          uid: uid,
          name: user!.name,
          username: user!.userName,
          message: message,
          timestamp: Timestamp.now(),
          likeCount: 0,
          likedBy: []);

      // convert post object to map
      Map<String, dynamic> newPostMap = newPost.toMap();

      //add to firebase
      await collectionReference.doc(id).set(newPostMap);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

// Delete a message

// Get all posts from firebase
  Future<List<Post>> getAllPostsFromFirebase() async {
    try {
      QuerySnapshot snapshot = await db
          //go to collection -> Posts
          .collection("Posts")
          // chronological order
          .orderBy('timestamp', descending: true)

          .get();
      // return as a list of posts
      //
      return snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

// Get individual post
}
