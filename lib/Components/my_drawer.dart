import 'package:flutter/material.dart';
import 'package:flutter/material.dart.';
import 'package:vinvi/Components/my_drawer_tile.dart';
/*
DRAWER

this is a menu drawer which is usually access on the left side of the app bar
-----------------------

Contains 5 menu options
- Home
- Profile
- Search
- Settings
- Logout

 */

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});



  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child:  SafeArea(
        child: Column(
          children: [
            //App logo
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Icon(
                Icons.Home,
                size: 72,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
            //Divider
            Divider(
              thickness: 0.5,
              indent: 16,
              endIndent: 16,
              color:theme.tertiary ,
            ),
            //Home List tile
MyDrawerTile(),
          ],
        ),
      ),
    );
  }
}
