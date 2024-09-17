  /*

! USER PROFILE

? This is what every user should have for their profile
 *  uid
 *  name
 *  email
 *  bio
 *  profile photo

  */

import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid, name, email, userName, bio, password;

  UserProfile({required this.uid,
    required this.name,
    required this.email,
    required this.userName,
    required this.password,
    required this.bio});

  //* firebase -> app
  //convert firestore document to a user profile (so that we can use it in out app)

  factory UserProfile.fromDocument(DocumentSnapshot doc){
    return UserProfile(uid: doc['uid'],
        name: doc['name'],
        email: doc['email'],
        userName: doc['userName'],
        password: doc['password'] ,
        bio: doc['bio']);
  }


 //*  app -> firebase
 //convert a user profile to a map(so we can store in firebase)
 Map<String, dynamic> toMap(){
    return {
      'uid' : uid,
      'name' : name,
      'email' : email,
      'userName' : userName,
      'bio': bio,
      'password' : password
    };
 }


}
