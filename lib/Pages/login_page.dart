import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vinvi/Components/my_button.dart';
import 'package:vinvi/Components/my_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var econ = TextEditingController();
  var pcon = TextEditingController();

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
                SizedBox(height: 24),

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
                SizedBox(
                  height: 24,
                ),
                MyButton(text: "L O G I N", onTap: () {}),
                //dont have an account? register now
                SizedBox(height: 16,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t Have an account?',
                        style: TextStyle(
                          color: Colors.grey,
                            fontWeight: FontWeight.w400)),
                    InkWell(
                      child: Text('  Register now',
                          style: TextStyle(
                              color: theme.primary,
                              fontWeight: FontWeight.w500)),
                      onTap: (){

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
