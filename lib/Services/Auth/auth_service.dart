import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:vinvi/Components/my_loading_circle.dart';

/*

!  AUTHENTICATION SERVICE

?  This handles everything to do with authentication in firebase
  ___________________________________________________________________

  * Login
  * Register
  * Logout
  * Deleter account

 */

class AuthService {
  final auth = FirebaseAuth.instance;

  //* get current user and UID
  User? getCurrentUser() => auth.currentUser;
  String getUid() => auth.currentUser!.uid;



  //* login -> email and pw
  Future<UserCredential> loginWithEmailAndPass(String email, pass) async {
    try {
      final userCredential =
          await auth.signInWithEmailAndPassword(email: email, password: pass);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint("////////////////   $e");
      throw Exception(e.code);
    }
  }



  //* register -> email & pw
  Future<UserCredential> registerEmailAndPass(String email, pass) async {
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: pass);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }



  //* logout
  Future<void> logoutUser() async {
    await auth.signOut();
  }
}
