import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vinvi/Components/my_comment_tile.dart';
import 'package:vinvi/Components/my_post_tile.dart';
import 'package:vinvi/Helper/navigate_pages.dart';
import 'package:vinvi/Models/post.dart';
import 'package:vinvi/Services/Database/database_provider.dart';

/*

!  POST PAGE

  ? This page displays
  * individual post
  * comment on this post

 */

class Postpage extends StatefulWidget {
  final Post post;

  const Postpage({super.key, required this.post});

  @override
  State<Postpage> createState() => _PostpageState();
}

class _PostpageState extends State<Postpage> {
  //providers
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);
  late final listeningProvider = Provider.of<DatabaseProvider>(context);

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;

    final allComment = listeningProvider.getComments(widget.post.id);
    //SCAFFOLD
    return Scaffold(
      backgroundColor: theme.surface,
      appBar: AppBar(
        iconTheme: IconThemeData(color: theme.tertiary, weight: 1),
        title: Text(
          'P O S T',
          style: TextStyle(color: theme.tertiary, fontWeight: FontWeight.w300),
        ),
        centerTitle: true,
        backgroundColor: theme.primary,
      ),
      body: ListView(
        children: [
          MyPostTile(
              post: widget.post,
              onUserTap: () {
                goUserPage(context, widget.post.uid);
              },
              onPostTap: () {}),
          const SizedBox(
            height: 8,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 25),
            child: Text(
              "Comments",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          allComment.isEmpty
              ? Center(child: Text("No commets"))
              : ListView.builder(
                  itemCount: allComment.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    // get each comment
                    final comment = allComment[index];

                    // return as comment tile UI
                    return MyCommentTile(
                        comment: comment,
                        onUserTap: () {
                          goUserPage(context, comment.uid);
                        });
                  })
        ],
      ),
    );
  }
}
