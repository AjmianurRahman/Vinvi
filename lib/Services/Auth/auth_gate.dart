import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vinvi/Pages/home_page.dart';
import 'package:vinvi/Pages/login_page.dart';

 /*
 AUTH GATE

 This is hcecked if the user is logged in or not
 _______________________________________________
 if user is logged in -> go to home
 if user not logged in -> go to login
  */

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {

          if(snapshot.hasData){
            debugPrint('++++++++++++++++++++ snapshot:  $snapshot');
            //Navigator.pop(context);
            return const HomePage();
          }else{
            return const LoginPage();
          }
        },
      ),
    );
  }
}
