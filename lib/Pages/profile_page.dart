import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vinvi/Components/my_bio_box.dart';
import 'package:vinvi/Components/my_input_alert_box.dart';
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
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  // user info
  UserProfile? user;
  String currentUserUid = AuthService().getUid();

  // loading....
  bool isLoading = true;

  //Text input controler
  var controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // lets load userInfo
    loadUser();
  }

  Future<void> loadUser() async {
    user = await databaseProvider.userProfile(currentUserUid);
    setState(() {
      isLoading = false;
    });
  }

  void showEditBioBox() {
   showDialog(context: context, builder: (context)=>
   MyInputAlertBox(controller: controller, text: "text", hintText: "Write something about you...", onpressed: (){
saveBio();
   },));
    }

    Future<void> saveBio()async{
    setState(() {
isLoading = true;
    });
    await databaseProvider.updateBio(controller.text.toString());
    //reload the user
    await loadUser();
    //set state and finish loading
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
        iconTheme: IconThemeData(color: theme.primary, weight: 1),
        title: Text(
          isLoading ? '' : user!.name,
          style: TextStyle(color: theme.primary, fontWeight: FontWeight.w300),
        ),
        centerTitle: true,
        backgroundColor: theme.surface,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ListView(children: [
          // username handle
          Center(
              child: Text(isLoading ? '' : '@${user!.userName}',
                  style: TextStyle(
                      color: theme.primary,
                      fontWeight: FontWeight.w500,
                      fontSize: 16))),
          // profile picture
          SizedBox(
            height: 8,
          ),
          Center(
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: theme.secondary),
              child: Icon(
                Icons.person_rounded,
                color: theme.primary,
                size: 72,
              ),
            ),
          ),
          // profile state -> number of posts/ followers/ following

          // follow/ unfollow button

          // user bio
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Bio',
                style: TextStyle(color: theme.primary, fontSize: 14),
              ),
              InkWell(
                  onTap: () => showEditBioBox(),
                  child: Icon(
                    Icons.settings,
                    color: theme.primary,
                  )),
            ],
          ),
          SizedBox(height: 4),
          MyBioBox(text: isLoading ? '.....' : user!.bio),

          //list of posts from user
        ]),
      ),
    );
  }
}
