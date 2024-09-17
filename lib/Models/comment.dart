import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/*

  COMMENT MODEL

  This is what every comment should have.

*/

class Comment {
  final String id; //* id of this comment
  final String postId; //* id of this post that this comment belong to
  final String uid, //* user id of the commenter
      name, //* name of the commenter
      username, //* username of the commenter
      message; //* message of the mommenter
  final Timestamp timestamp; //* timestamp of comment

  Comment(
      {required this.id,
      required this.postId,
      required this.uid,
      required this.name,
      required this.username,
      required this.message,
      required this.timestamp});

  //? Convert firestore data to comment object (to user in our app)
  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
        id: doc['id'],
        postId: doc['postId'],
        uid: doc['uid'],
        name: doc['name'],
        username: doc['username'],
        message: doc['message'],
        timestamp: doc['timestamp']);
  }

  //? Convert a comment object into a map (to store in firebase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'postId': postId,
      'uid': uid,
      'name': name,
      'username': username,
      'message': message,
      'timestamp': timestamp
    };
  }
}
