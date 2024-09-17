
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:vinvi/Models/comment.dart';
import 'package:vinvi/Models/post.dart';
import 'package:vinvi/Models/user.dart';
import 'package:vinvi/Services/Auth/auth_service.dart';


/*

 ! DATABSE SERVICE

 ? This class handles all the dat from and to firebase;
 _____________________________________________________

 * User profile
 * Post message
 * Likes
 * Comments
 * Account stuff (report / block/ delete account)
 * Follow / Unfollow
 * Search users

 */

class DatabaseService {
  // get instances
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  /*

  !  USER PROFILE

  When the user requesters we create an account for them, but lets also store
  their details in the database to display on their profile page.

  */

  //? Save user info
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

  //? Get User info
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

  //? Update user bio
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

  /*!      POST MESSAGE       */

  //? Post a message
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

  //? Delete a message

  Future<void> deleteThePost(String postId) async {
    try {
      await db.collection("Posts").doc(postId).delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //? Get all posts from firebase
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

  /*!     LIKES     */
  Future<void> toggleLikeInFirebase(String postId) async {
    try {
      // get current user Id
      String uid = AuthService().getUid();

      // go to doc of the post
      DocumentReference postDoc = db.collection("Posts").doc(postId);

      //execute like
      await db.runTransaction((transaction) async {
        //get post data
        DocumentSnapshot postSnapshot = await transaction.get(postDoc);

        // get like of users who liked this post
        List<String> likedBy = List<String>.from(postSnapshot['likedBy'] ?? []);
        // get like count
        int currentLikeCount = postSnapshot['likeCount'];

        // if user has not liked this post yet -> then like
        if (!likedBy.contains(uid)) {
          //add user to like list
          likedBy.add(uid);

          //increment like count
          currentLikeCount++;
        }
        // if user has already liked this post -> then unlike
        else {
          likedBy.remove(uid);
          currentLikeCount--;
        }

        transaction.update(
            postDoc, {'likeCount': currentLikeCount, 'likedBy': likedBy});
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /*!     COMMENT     */

  //? Add a comment to a post
  Future<void> addCommentInFirebase(String postId, message) async {
    try {
      // get current user
      String uid = AuthService().getUid();
      UserProfile? user = await getUserFromFirebase(uid);

      // convert comment to map
      String id = db.collection('Comments').doc().id;
      Comment comment = Comment(
          id: id,
          postId: postId,
          uid: uid,
          name: user!.name,
          username: user!.userName,
          message: message,
          timestamp: Timestamp.now());

      // convert comment to map
      Map<String, dynamic> newComment = comment.toMap();

      //to store in firebase
      await db.collection('Comments').doc(id).set(newComment);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //? Delete a comment from a post
  Future<void> deleteComment(String commentId) async {
    try {
      await db.collection("Comments").doc(commentId).delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //? Fetch comments from a post
  Future<List<Comment>> getCommentsFromFirebse(String postId) async {
    try {
      // get comments from firebase
      QuerySnapshot snapshot = await db
          .collection("Comments")
          .where("postId", isEqualTo: postId)
          .get();

      //return as a list
      return snapshot.docs.map((doc) => Comment.fromDocument(doc)).toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  /*!  ACCOUNT STUFF   */

  //? Repost Post
  Future<void> reportUserInFirebase(String postId, userId) async {
    final currentuser = auth.currentUser!.uid;

    // create a repost map
    final repost = {
      'reportedBy': currentuser,
      'messageId': postId,
      'messageOwnerId': userId,
      "timestamp": FieldValue.serverTimestamp()
    };

    // update in firestore
    await db.collection("Reposts").add(repost);
  }

  //? Block user
  Future<void> blockUserInFirebase(String userId) async {
    final currentuser = auth.currentUser!.uid;

    //add this user to blockList
    await db
        .collection("Users")
        .doc(currentuser)
        .collection("BlockedUsers")
        .doc(userId)
        .set({'userId': userId});
  }

  //? Unblock user
  Future<void> unblockUserInFirebase(String blockedId) async {
    final currentuser = auth.currentUser!.uid;

    //add this user to blockList
    await db
        .collection("Users")
        .doc(currentuser)
        .collection("BlockedUsers")
        .doc(blockedId)
        .delete();
  }

  //? Get list of blocked user ids

  Future<List<String>> getListOfBlockedUsers() async{
    final currentuser = auth.currentUser!.uid;
    try{
      final snapshot =await db.collection("Users").doc(currentuser)
          .collection('BlockedUsers').get();

      return snapshot.docs.map((doc) => doc.id).toList();
    }catch(e){
      return [];
    }
  }

}
