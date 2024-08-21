import 'package:flutter/material.dart';
import 'package:flutter/material.dart.';
import 'package:vinvi/Components/my_drawer_tile.dart';
import 'package:vinvi/Pages/profile_page.dart';
import 'package:vinvi/Pages/settings_page.dart';
import 'package:vinvi/Services/Auth/auth_service.dart';
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
   MyDrawer({super.key});


  @override
  Widget build(BuildContext context) {

    final auth = AuthService().getUid();
    var theme = Theme.of(context).colorScheme;
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              //App logo
              Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: Icon(
                  Icons.person,
                  size: 72,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              //Divider
              Divider(
                thickness: 0.5,
                indent: 16,
                endIndent: 16,
                color: theme.tertiary,
              ),
              MyDrawerTile(title: 'H O M E', icon: Icons.home_rounded, onTap: () {}),

              MyDrawerTile(title: 'P R O F I L E', icon: Icons.person_rounded, onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const ProfilePage()));
              }),

              MyDrawerTile(title: 'S E T T I N G S', icon: Icons.settings, onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const SettingsPage()));
              }),
              Spacer(),
              MyDrawerTile(title: 'L O G O U T', icon: Icons.logout_rounded, onTap: () {
                Navigator.pop(context);
                AuthService().logoutUser();
                 }),
              //Home List tile


            ],
          ),
        ),
      ),
    );
  }
}
