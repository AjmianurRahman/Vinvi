import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vinvi/Components/my_settings_tile.dart';
import 'package:vinvi/Helper/navigate_pages.dart';
import 'package:vinvi/Services/Database/database_provider.dart';
import 'package:vinvi/Themes/theme_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

/*

 */

class _SettingsPageState extends State<SettingsPage> {



  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: theme.surface,
      appBar: AppBar(
        iconTheme: IconThemeData(color: theme.tertiary, weight: 1),
        title: Text(
          'S E T T I N G S',
          style: TextStyle(color: theme.tertiary, fontWeight: FontWeight.w300),
        ),
        centerTitle: true,
        backgroundColor: theme.primary,
      ),
      body: Column(
        children: [
          //Dark mode tile
          MySettingsTile(
              title: "Dark Mode",
              action: CupertinoSwitch(
                  activeColor: theme.surface,
                  onChanged: (bool value) {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .toggleTheme();
                  },
                  value: Provider.of<ThemeProvider>(context, listen: false)
                      .isDartMood)),
          //Block users tile
          InkWell(
            onTap: ()=> goToBlockedUserPage(context),
              child: MySettingsTile(
                  title: "Blocked Usrs",
                  action: Icon(
                    Icons.arrow_forward_rounded,
                    color: theme.tertiary,

                  ))),
          InkWell(
            onTap: ()=>  goToAccountSettingsPage(context),
            child: MySettingsTile(title: "Account Settings", action: Icon(Icons.settings_rounded, color: Theme.of(context).colorScheme.tertiary)),
          )

          //Account settings tile
        ],
      ),
    );
  }


}
