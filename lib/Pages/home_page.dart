import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vinvi/Components/my_drawer.dart';
import 'package:vinvi/Components/my_input_alert_box.dart';
import 'package:vinvi/Components/my_loading_circle.dart';
import 'package:vinvi/Components/my_post_tile.dart';
import 'package:vinvi/Helper/navigate_pages.dart';
import 'package:vinvi/Models/post.dart';
import 'package:vinvi/Services/Auth/auth_service.dart';
import 'package:vinvi/Services/Database/database_provider.dart';

 /*

! HOME PAGE

?  This is the main page of this app: it displays a list of all posts

 */

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var controller = TextEditingController();

  //* provider
  late final listiningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseprovider = Provider.of<DatabaseProvider>(context, listen: false);



  @override
  void initState() {
    super.initState();

    loadAllPosts();
  }

  //? BUILD UI
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;

    //SCAFFOLD
    return DefaultTabController(
      length: 2,

      //0 Scaffold
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        drawer: MyDrawer(),
      
        //0  APPBAR
        appBar: AppBar(

          iconTheme: IconThemeData(color: theme.tertiary, weight: 1),
          title: Text(
            'H O M E',
            style: TextStyle(color: theme.tertiary, fontWeight: FontWeight.w300),
          ),
          centerTitle: true,
          backgroundColor: theme.primary,
          bottom:  TabBar(
              dividerColor: Colors.transparent,
              labelPadding: EdgeInsets.all(8),
              labelColor: Theme.of(context).colorScheme.tertiary,
              labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
              tabs: [
                Text('For you'), Text('Following')
              ]),
        ),
      
        //0  FLOATING ACTION BUTTON
        floatingActionButton: FloatingActionButton(
          shape: CircleBorder(),
          onPressed: () {
            openPostMessageBox();
          },
          child: Icon(Icons.add),
        ),
      
        //0  Body
        body: TabBarView(
          children: [
            buildPostList(listiningProvider.allposts),
            buildPostList(listiningProvider.followingPosts)
          ],
        ),
      ),
    );
  }

  Widget buildPostList(List<Post> posts) {
    return posts.isEmpty
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              // get each individual post
              final post = posts[index];
              // return Post Tile UI
              return MyPostTile(
                  onPostTap: () {
                    goPostPage(context, post);
                  },
                  post: post,
                  onUserTap: () {
                    goUserPage(context, post.uid);
                  });
            });
  }

  void openPostMessageBox() {
    showDialog(
        context: context,
        builder: (context) => MyInputAlertBox(
              controller: controller,
              text: "Post",
              hintText: "Message...",
              onpressed: () async {
                if (controller.text.toString() != null) {
                  await postMessage(controller.text.toString());
                }
              },
            ));
  }

  Future<void> postMessage(String message) async {
    await databaseprovider.postMessage(message);
  }

  Future<void> loadAllPosts() async {
    await databaseprovider.loadAllPosts();
  }
}
