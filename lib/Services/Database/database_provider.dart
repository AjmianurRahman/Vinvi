import 'package:flutter/material.dart';
import 'package:vinvi/Models/user.dart';
import 'package:vinvi/Services/Auth/auth_service.dart';
import 'package:vinvi/Services/Database/database_service.dart';

  /*

  DATABASE PROVIDER

  This provider is used to separate the firestore data handling and the UI of out app.
  _______________________________________________________________________________________

  - The database service class handles data to and from firebase
  - The database provider class processes the data to display in out app

  This is to make our code much more modular, cleaner, and easier to read and test.
  Particularly as the number of pages grow, we need this provider to properly manage the
  different states of app.

  - Also, if one day, we decide to change out backend (from firebase to something else
  then it's much easier to manage and switch out different database.

  */

  class DatabaseProvider extends ChangeNotifier{
    /*
    SERVICES
     */

    // get db and auth services
    final auth = AuthService();
    final db = DatabaseService();


    /*
     USER PROFILE
     */

    // get user profile ginen uid
   Future<UserProfile?> userProfile(String uid) => db.getUserFromFirebase(uid);

   // update the user bio
    Future<void> updateBio(String bio) => db.updateUserBioInFirebase(bio);

  }
