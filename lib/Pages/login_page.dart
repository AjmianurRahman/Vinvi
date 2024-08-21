import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vinvi/Components/my_button.dart';
import 'package:vinvi/Components/my_loading_circle.dart';
import 'package:vinvi/Components/my_textfield.dart';
import 'package:vinvi/Pages/register_page.dart';
import 'package:vinvi/Services/Auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var econ = TextEditingController();
  var pcon = TextEditingController();
  var auth = AuthService();

  void login() async {
    debugPrint("+++++++++++++++++++++Entered in login");
    //show loading circle when start.
    showLoadingCircle(context);
    try {

      await auth.loginWithEmailAndPass(
          econ.text.toString(), pcon.text.toString());
      if (mounted) hideLoadingCircle(context);
    } catch (e) {
      if (mounted) hideLoadingCircle(context);
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.primary,
                icon: const Icon(
                  Icons.error,
                  size: 52,
                ),
                iconColor: Colors.red,
                title: Text(
                  "$e",
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
      backgroundColor: theme.surface,
      body: SafeArea(
        child: Center(
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
                Text('Welcome back! we were waiting for you',
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
                    controller: econ,
                    hintText: "Enter Email",
                    obscureText: false),
                MyTextfield(
                    controller: pcon,
                    hintText: "Enter password",
                    obscureText: true),
                //forgot password
                Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      child: Text('Forgot password?',
                          style: TextStyle(
                              color: theme.primary,
                              fontWeight: FontWeight.w400)),
                      onTap: () {},
                    )),
                //signin button
                const SizedBox(
                  height: 24,
                ),
                MyButton(
                    text: "L O G I N",
                    onTap: () {
                      login();
                    }),
                //dont have an account? register now
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account?',
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w400)),
                    InkWell(
                      child: Text('  Register now',
                          style: TextStyle(color: theme.primary)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterPage()));
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
