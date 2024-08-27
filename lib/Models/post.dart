import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/*

  POST MODEL


   */
class Post {
  final String id, uid;
  final String name;
  final String username;
  final String message;
  final Timestamp timestamp;
  final int likeCount;
  final List<String> likedBy;

  Post({required this.id,
    required this.uid,
    required this.name,
    required this.username,
    required this.message,
    required this.timestamp,
    required this.likeCount,
    required this.likedBy});

  // Convert a firestore -> post object
  factory Post.fromDocument(DocumentSnapshot doc){
    return Post(id: doc.id,
        uid: doc['uid'],
        name: doc['name'],
        username: doc['username'],
        message: doc['message'],
        timestamp: doc['timestamp'],
        likeCount: doc['likeCount'],
        likedBy: List<String>.from(doc['likedBy'] ?? []));
  }

  // Convert a post object -> map
  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'uid': uid,
      'name': name,
      'username': username,
      'message': message,
      'timestamp': timestamp,
      'likeCount': likeCount,
      'likedBy': likedBy
    };
  }

}
