import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vinvi/Models/comment.dart';
import 'package:vinvi/Models/post.dart';
import 'package:vinvi/Models/user.dart';
import 'package:vinvi/Services/Auth/auth_service.dart';
import 'package:vinvi/Services/Database/database_service.dart';

/*

!  DATABASE PROVIDER

  *This provider is used to separate the firestore data handling and the UI of out app.
  *_______________________________________________________________________________________

  *- The database service class handles data to and from firebase
  *- The database provider class processes the data to display in out app

  *This is to make our code much more modular, cleaner, and easier to read and test.
  *Particularly as the number of pages grow, we need this provider to properly manage the
  *different states of app.

  *- Also, if one day, we decide to change out backend (from firebase to something else
  *then it's much easier to manage and switch out different database.

  */

class DatabaseProvider extends ChangeNotifier {
  /*!   SERVICES    */

  // get db and auth services
  final auth = AuthService();
  final db = DatabaseService();

  /*!    USER PROFILE   */

  //? get user profile ginen uid
  Future<UserProfile?> userProfile(String uid) => db.getUserFromFirebase(uid);

  //? update the user bio
  Future<void> updateBio(String bio) => db.updateUserBioInFirebase(bio);

  /*!     POST     */

  // local list of posts
  List<Post> _allPosts = [];

  // get posts
  List<Post> get allposts => _allPosts;

  //?post message
  Future<void> postMessage(String message) async {
    await db.postMessageInFirebase(message);

    // reload the data from firebase
    await loadAllPosts();
  }

  //? fetch all posts
  Future<void> loadAllPosts() async {
    final allPosts = await db.getAllPostsFromFirebase();

    // get all blocked user ids
    final blockedUserIds = await db.getListOfBlockedUsers();

    //update to local data
    _allPosts =
        allPosts.where((post) => !blockedUserIds.contains(post.uid)).toList();

    // initialize local like data
    initializeLikeMap();

    notifyListeners();
  }

  //? filter and return posts given uid
  List<Post> filterUserPosts(String uid) {
    return _allPosts.where((post) => post.uid == uid).toList();
  }

  // Delete the post
  Future<void> deletePost(String postId) async {
    //delete the post
    await db.deleteThePost(postId);
    // reload data from firebase.
    await loadAllPosts();
  }

  /*!     LIKE      */

  Map<String, int> _likeCounts = {
    /*for each post id: like count*/
  };

  // local list to track posts liked by current user
  List<String> _likedPosts = [];

  // does current user like this post?
  bool isPostLikedbyCurrentUser(String postId) => _likedPosts.contains(postId);

  // get like count of a post
  int getLikeCount(String postId) => _likeCounts[postId] ?? 0;

  //? initialize like map locally
  void initializeLikeMap() {
    final currentUid = AuthService().getUid();

    //* clear liked posts (for when new user signs in, clear local data)
    _likedPosts.clear();

    // for each post get like data
    for (var post in _allPosts) {
      // update like count map
      _likeCounts[post.id] = post.likeCount;
      debugPrint(
          '////////////  /////////  : ${_likeCounts[post.id].toString()}   ${post.likeCount}');

      // if the current user alrady likes this posts
      if (post.likedBy.contains(currentUid)) {
        _likedPosts.add(post.id);
      }
    }
  }

  //? toggle like
  Future<void> toggleLike(String postId) async {
    /*
    * This first part will update the local values first so that the UI feels
    * immediate and responsive. We will update the UI optimistically, and revert
    * back if anything goes wrong while writing to the database;

    * Optimistically updating the local values like this is important because:
    * reading and writing from the database takes some time (1-2 seconds, depending
    * on the internet connecting). So we don't want to give the user a slow lagged experience.
    */

    // store original values in case it fails.
    final likedPostOriginal = _likedPosts;
    final likedCountOriginal = _likeCounts;

    // perform like / unlike
    if (_likedPosts.contains(postId)) {
      _likedPosts.remove(postId);
      _likeCounts[postId] = (_likeCounts[postId] ?? 0) - 1;
    } else {
      _likedPosts.add(postId);
      _likeCounts[postId] = (_likeCounts[postId] ?? 0) + 1;
    }

    //update UI locally
    notifyListeners();

    /*   NOW LET'S TRY TO UPDATE IT IN OUR DATABASE  */
    // attempt like in database
    try {
      await db.toggleLikeInFirebase(postId);
    } catch (e) {
      _likedPosts = likedPostOriginal;
      _likeCounts = likedCountOriginal;

      notifyListeners();
    }
  }

  /*!    COMMENT
   * store the comment data in local storage in this formate
   postId1: [comment, comment2, ..]
   postId2: [comment, comment2, ..]
   postId3: [comment, comment2, ..]
  */

  // local list of comments
  final Map<String, List<Comment>> _comments = {};

  // get comments locally
  List<Comment> getComments(String postId) => _comments[postId] ?? [];

  //? fetch comments from database for a post
  Future<void> loadComments(String postId) async {
    try {
      // get all comments of this post
      final allcomments = await db.getCommentsFromFirebse(postId);

      // update the local data
      _comments[postId] = allcomments;

      // update the UI
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //? add a comment
  Future<void> addComment(String postId, message) async {
    try {
      await db.addCommentInFirebase(postId, message);

      await loadComments(postId);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //? delete a comment
  Future<void> deleteComment(String commentId, String postId) async {
    try {
      await db.deleteComment(commentId);

      await loadComments(postId);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /*! ACCOUNT STUFF   */

  //? local list of blocked users
  List<UserProfile> _blockedUsers = [];

  //? get list of blocked users
  List<UserProfile> get blockedUSers => _blockedUsers;

  //? Fetch blocked users
  Future<void> loadBlockedUsers() async {
    final blockedUserIds = await db.getListOfBlockedUsers();

    final blockedUsersData = await Future.wait(
        blockedUserIds.map((id) => db.getUserFromFirebase(id)));

    _blockedUsers = blockedUsersData.whereType<UserProfile>().toList();

    notifyListeners();
  }

  //? block user
  Future<void> blockUser(String userId) async {
    await db.blockUserInFirebase(userId);

    await loadBlockedUsers();

    await loadAllPosts();

    notifyListeners();
  }

  //? unblock user
  Future<void> unBlockUser(String userId) async {
    await db.unblockUserInFirebase(userId);

    await loadBlockedUsers();

    await loadAllPosts();

    notifyListeners();
  }

  //? report user & post
  Future<void> reportUser(String postId, userId) async {
    await db.reportUserInFirebase(postId, userId);
  }
}
