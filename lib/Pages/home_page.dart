import 'package:flutter/material.dart';
import 'package:vinvi/Components/my_drawer.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor:Theme.of(context).colorScheme.surface ,
      drawer: MyDrawer(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: theme.tertiary,weight: 1),
        title: Text(
          'H O M E',
          style: TextStyle(color: theme.tertiary, fontWeight: FontWeight.w300),
        ),
        centerTitle: true,
        backgroundColor: theme.primary,
      ),
    );
  }
}
