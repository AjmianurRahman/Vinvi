import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vinvi/Components/my_button.dart';
import 'package:vinvi/Components/my_loading_circle.dart';
import 'package:vinvi/Components/my_textfield.dart';
import 'package:vinvi/Pages/home_page.dart';
import 'package:vinvi/Pages/login_page.dart';
import 'package:vinvi/Services/Auth/auth_service.dart';
import 'package:vinvi/Services/Database/database_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  /*

  The data we want here is
  - name
  - email
  - password
  - confirm password
  _______________________________

  once the user successfully creates the account redirect to home page.
   */

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //access database service
  var auth = AuthService();
  final db = DatabaseService();

  var econ = TextEditingController();
  var pcon = TextEditingController();
  var ncon = TextEditingController();
  var ccon = TextEditingController();

  void register() async {
    if (pcon.text.toString() == ccon.text.toString()) {
      showLoadingCircle(context);
      /*try {
        await auth.registerEmailAndPass(
            econ.text.toString(), pcon.text.toString());

        await db.saveUserInfoInFirebase(
            name: ncon.text.toString(),
            email: econ.text.toString(),
            password: ccon.text.toString()).then((value){
              print("///////////////////////  SUCCESS");
          if(mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
        });

        if (mounted) {
          hideLoadingCircle(context);
        }
      } catch (e) {
        if (mounted) hideLoadingCircle(context);
        print(e.toString());
      }*/
      var mauth = FirebaseAuth.instance;
       mauth.createUserWithEmailAndPassword(email: econ.text.toString(), password: pcon.text.toString())
      .then((value){
        hideLoadingCircle(context);
        db.saveUserInfoInFirebase(name: ncon.text.toString(), email: econ.text.toString(), password: ccon.text.toString());
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const HomePage()));

      })
          .onError((error, stack){
        hideLoadingCircle(context);
        showDialog(context: context, builder: (context)=>AlertDialog(
          icon: const Icon(Icons.error, size: 52,),
          iconColor: Colors.red,
          title: Text(error.toString(), style: TextStyle(fontSize: 16,color: Colors.red , fontWeight: FontWeight.w300),),
        ));
      });
    } else {
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                icon: const Icon(
                  Icons.error,
                  size: 52,
                ),
                iconColor: Colors.red,
                title: Text(
                  "Passwords don't match",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                      fontWeight: FontWeight.w300),
                ),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return Scaffold(
      //  resizeToAvoidBottomInset: false,
      backgroundColor: theme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Logo
                  // SizedBox(height: 52),
                  Icon(
                    Icons.lock_open_rounded,
                    size: 72,
                    color: theme.primary,
                  ),
                  const SizedBox(height: 24),

                  //Welcome back message
                  Text('Welcome! lets create an account for you',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: theme.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w300)),
                  const SizedBox(
                    height: 24,
                  ),

                  //password textfield
                  MyTextfield(
                      controller: ncon,
                      hintText: "Enter Name",
                      obscureText: false),
                  MyTextfield(
                      controller: econ,
                      hintText: "Enter Email",
                      obscureText: false),
                  MyTextfield(
                      controller: pcon,
                      hintText: "Enter password",
                      obscureText: true),
                  MyTextfield(
                      controller: ccon,
                      hintText: "Confirm password",
                      obscureText: true),
                  //forgot password
                  //signin button
                  const SizedBox(
                    height: 24,
                  ),
                  MyButton(
                      text: "S I G N   I N",
                      onTap: () {
                        register();
                      }),
                  //dont have an account? register now
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Have an account?',
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.w400)),
                      InkWell(
                        child: Text('  Login now',
                            style: TextStyle(color: theme.primary)),
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()));
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
