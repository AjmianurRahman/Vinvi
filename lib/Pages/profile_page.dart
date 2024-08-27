import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vinvi/Components/my_bio_box.dart';
import 'package:vinvi/Components/my_input_alert_box.dart';
import 'package:vinvi/Components/my_post_tile.dart';
import 'package:vinvi/Helper/navigate_pages.dart';
import 'package:vinvi/Models/user.dart';
import 'package:vinvi/Services/Auth/auth_service.dart';
import 'package:vinvi/Services/Database/database_provider.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // provider
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  // listening provider
  late final listeningProvider = Provider.of<DatabaseProvider>(context);

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
    user = await databaseProvider.userProfile(widget.uid);
    setState(() {
      isLoading = false;
    });
  }

  void showEditBioBox() {
    showDialog(
        context: context,
        builder: (context) => MyInputAlertBox(
              controller: controller,
              text: "Save",
              hintText: "Write something about you...",
              onpressed: () {
                saveBio();
              },
            ));
  }

  Future<void> saveBio() async {
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
    // get all the users posts
    final allUserPosts = listeningProvider.filterUserPosts(widget.uid);

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
      body: ListView(children: [
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
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
        ),
        SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, bottom: 4),
          child: MyBioBox(text: isLoading ? '.....' : user!.bio),
        ),

        //list of posts from user
        Padding(
          padding: const EdgeInsets.only(top: 25, left: 25),
          child: Text(
            'Post',
            style: TextStyle(color: theme.primary, fontSize: 14),
          ),
        ),
        allUserPosts.isEmpty
            ?
            // user post is empty
            const Center(
                child: Text("No previous posts..."),
              )
            : ListView.builder(
                itemCount: allUserPosts.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  // get each individual posts
                  final post = allUserPosts[index];
                  return MyPostTile(
                      post: post,
                      onUserTap: () {},
                      onPostTap: () {
                        goPostPage(context, post);
                      });
                })
      ]),
    );
  }
}
