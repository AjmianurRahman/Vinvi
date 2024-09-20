import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  List<Post> _followingPosts = [];

  // get posts
  List<Post> get allposts => _allPosts;

  List<Post> get followingPosts => _followingPosts;

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

    // load following posts
    loadFollowingPosts();

    // initialize local like data
    initializeLikeMap();

    notifyListeners();
  }

  //? Load all follwing posts -> posts from users that the current user follows
  Future<void> loadFollowingPosts() async {
    //get current user id
    String current = auth.getUid();

    // get list of uids that current user follows
    final followingUserIds = await db.getFollowingUidsFromFirestore(current);
    print('******** $followingUserIds');

    // filter all posts
    _followingPosts =
        _allPosts.where((post) => followingUserIds.contains(post.uid)).toList();
    notifyListeners();
  }

  //? filter and return posts given uid
  List<Post> filterUserPosts(String uid) {
    return _allPosts.where((post) => post.uid == uid).toList();
  }

  //? Delete the post
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

  /*!    FOLLOW & UNFOLLOW   */

  //? local map
  final Map<String, List<String>> _followers = {};
  final Map<String, List<String>> _following = {};
  final Map<String, int> _followerCount = {};
  final Map<String, int> _followingCount = {};

  //? get count for followers & following locally: given a uid
  int getFollowerCount(String uid) => _followerCount[uid] ?? 0;

  int getFollowingCount(String uid) => _followingCount[uid] ?? 0;

  //? load followers
  Future<void> loadUserFollowers(String uid) async {
    // get the list of follower uids for firebase
    final listOfFollowerUids = await db.getFollowerUidsFromFirestore(uid);

    debugPrint('++++++++++ $listOfFollowerUids');

    // update local data
    _followers[uid] = listOfFollowerUids;
    _followerCount[uid] = listOfFollowerUids.length;

    // update UI
    notifyListeners();
  }

  //? load following
  Future<void> loadUserFollowing(String uid) async {
    // get the list of follower uids for firebase
    final listOfFollowingUids = await db.getFollowingUidsFromFirestore(uid);

    // update local data
    _following[uid] = listOfFollowingUids;
    _followingCount[uid] = listOfFollowingUids.length;

    // update UI
    notifyListeners();
  }

  //? follow user
  Future<void> followUser(String targetuid) async {
    //0 Current logged in user wants to follow target user
    // get current user
    final curretUser = auth.getUid();

    // initialize with empty lists if null
    _followers.putIfAbsent(curretUser, () => []);
    _following.putIfAbsent(targetuid, () => []);

    /*0 Optimistic UI changes: Update the local data & revert back if database request fails */

    // follow if current user is not one of the target users followers
    if (!_followers[targetuid]!.contains(curretUser)) {
      // add current user to target user's follower list
      _followers[targetuid]?.add(curretUser);

      // update follower count
      _followerCount[targetuid] = (_followerCount[targetuid] ?? 0) + 1;

      // then add target user to current users following
      _following[curretUser]?.add(targetuid);
      //update the following count
      _followingCount[curretUser] = (_followingCount[curretUser] ?? 0) + 1;
    }

    // update UI
    notifyListeners();

    /*0  UI has been optimistically updated above with local data
      0  Now ets try to make this request to our database          */

    try {
      // follow user in firebase
      await db.followUserInFirestore(targetuid);

      // reload current user's followers
      await loadUserFollowers(curretUser);

      // reload current user's following
      await loadUserFollowing(curretUser);
    } catch (e) {
      // remove current user from target user's followers
      _followers[targetuid]?.remove(curretUser);

      // update follower count
      _followerCount[targetuid] = (_followerCount[targetuid] ?? 0) - 1;

      // remove from current user's following
      _following[curretUser]?.add(targetuid);

      //update following count
      _followingCount[curretUser] = (_followingCount[curretUser] ?? 0) - 1;

      // update ui
      notifyListeners();
    }
  }

  //? Unfollow user
  Future<void> unFollowUser(String targetuid) async {
    //0 Current logged in user wants to follow target user
    // get current user
    final curretUser = auth.getUid();

    // initialize with empty lists if null
    _followers.putIfAbsent(targetuid, () => []);
    _following.putIfAbsent(curretUser, () => []);

    /*0 Optimistic UI changes: Update the local data & revert back if database request fails */

    // follow if current user is not one of the target users followers
    if (_followers[targetuid]!.contains(curretUser)) {
      // add current user to target user's follower list
      _followers[targetuid]?.remove(curretUser);

      // update follower count
      _followerCount[targetuid] = (_followerCount[targetuid] ?? 1) - 1;

      // then add target user to current users following
      _following[curretUser]?.remove(targetuid);
      //update the following count
      _followingCount[curretUser] = (_followingCount[curretUser] ?? 1) - 1;
    }

    // update UI
    notifyListeners();

    /*0  UI has been optimistically updated above with local data
      0  Now ets try to make this request to our database          */

    try {
      // follow user in firebase
      await db.unfollowUserFromFirestore(targetuid);

      // reload current user's followers
      await loadUserFollowers(curretUser);

      // reload current user's following
      await loadUserFollowing(curretUser);
    } catch (e) {
      // remove current user from target user's followers
      _followers[targetuid]?.add(curretUser);

      // update follower count
      _followerCount[targetuid] = (_followerCount[targetuid] ?? 0) + 1;

      // remove from current user's following
      _following[curretUser]?.add(targetuid);

      //update following count
      _followingCount[curretUser] = (_followingCount[curretUser] ?? 0) + 1;

      // update ui
      notifyListeners();
    }
  }

  //? is current user following target user?
  bool isFollowing(String uid) {
    final current = auth.getUid();
    return _followers[uid]?.contains(current) ?? false;
  }

  /*
  ! MAP OF PROFILES

  for given uid:
  - list of follower profiles
  - list of following profiles
   */

  final Map<String, List<UserProfile>> _followersProfile = {};
  final Map<String, List<UserProfile>> _followingssProfile = {};

  List<UserProfile> getListOfFollowersProfile(String uid) =>
      _followersProfile[uid] ?? [];

  List<UserProfile> getListOfFolloweingsProfile(String uid) =>
      _followingssProfile[uid] ?? [];

  //? Load all followers profile
  Future<void> loadFollowersProfile(String uid) async {
    try {
      // get list of follower uids from firebase
      final followerIds = await db.getFollowerUidsFromFirestore(uid);
      // create list of user profile
      List<UserProfile> followerProfiles = [];

      // go through each follower id
      for (String follwerId in followerIds) {
        UserProfile? followerProfile = await db.getUserFromFirebase(follwerId);

        if (followerProfile != null) {
          followerProfiles.add(followerProfile);
        }
      }

      // update local data
      _followersProfile[uid] = followerProfiles;

      // update ui
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  //? Load all following profile
  Future<void> loadFollowingsProfile(String uid) async {
    try {
      // get list of follower uids from firebase
      final followerIds = await db.getFollowingUidsFromFirestore(uid);
      // create list of user profile
      List<UserProfile> followerProfiles = [];

      // go through each follower id
      for (String follwerId in followerIds) {
        UserProfile? followerProfile = await db.getUserFromFirebase(follwerId);

        if (followerProfile != null) {
          followerProfiles.add(followerProfile);
        }
      }

      // update local data
      _followingssProfile[uid] = followerProfiles;

      // update ui
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  /*!    Search     */
  List<UserProfile> _searchResults = [];

  List<UserProfile> get searchResults => _searchResults;

  Future<void> searchUser(String searchTerm) async {
    try {
      final result = await db.searchUserInFirebase(searchTerm);

      _searchResults = result;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
