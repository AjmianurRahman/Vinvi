import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vinvi/Pages/home_page.dart';
import 'package:vinvi/Pages/login_page.dart';
import 'package:vinvi/Pages/settings_page.dart';
import 'package:vinvi/Themes/dart_mode.dart';
import 'package:vinvi/Themes/light_mode.dart';
import 'package:vinvi/Themes/theme_provider.dart';

import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //adding provider to notify the app theme
  runApp(
    ChangeNotifierProvider(create: (context)=> ThemeProvider(),
    child: const MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: LoginPage(),
    );
  }
}

