import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vinvi/Models/user.dart';
import 'package:vinvi/Services/Auth/auth_service.dart';
import 'package:vinvi/Services/Database/database_provider.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  // provider
  late final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);

  // user info
  UserProfile? user;
  String currentUserUid = AuthService().getUid();

  // loading....
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // lets load userInfo
    loadUser();
  }

  Future<void> loadUser() async{
    user = await databaseProvider.userProfile(currentUserUid);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: theme.surface,
      appBar: AppBar(
        iconTheme: IconThemeData(color: theme.tertiary,weight: 1),
        title: Text(isLoading? '' : user!.name ,style: TextStyle(color: theme.tertiary, fontWeight: FontWeight.w300),
        ),
        centerTitle: true,
        backgroundColor: theme.primary,
      ),
      body: ListView(
        // username handle

        // profile picture

        // profile state -> number of posts/ followers/ following

        // follow/ unfollow button

        //list of posts from user
      ),
    );
  }
}
