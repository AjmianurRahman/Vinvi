import 'package:flutter/material.dart';
import 'package:flutter/material.dart.';
import 'package:provider/provider.dart';
import 'package:vinvi/Components/my_input_alert_box.dart';
import 'package:vinvi/Models/post.dart';
import 'package:vinvi/Services/Auth/auth_service.dart';
import 'package:vinvi/Services/Database/database_provider.dart';

/*

POST TILE

All posts will be displayed using this post tile widget
---------------------------------------------------------

To use this widget, you need:
- the post
- a function onPostTap (go to the individual post to see its comments)
- a function for onUserTap (go to user profile page)
 */

class MyPostTile extends StatefulWidget {
  final Post post;
  final void Function()? onUserTap;
  final void Function()? onPostTap;

  const MyPostTile(
      {super.key,
      required this.post,
      required this.onUserTap,
      required this.onPostTap});

  @override
  State<MyPostTile> createState() => _MyPostTileState();
}

class _MyPostTileState extends State<MyPostTile> {
  // provider
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  // listening provider
  late final listeningProvider = Provider.of<DatabaseProvider>(context);

  // text editing controller
  var controller = TextEditingController();

  //? init state
  @override
  void initState() {
    super.initState();

    _loadComment();
  }

  //? user tapped like (or unlike)
  void _toggleLikePost() async {
    try {
      await databaseProvider.toggleLike(widget.post.id);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //? user click on comment so open comment box
  void _openCommentBox() {
    showDialog(
        context: context,
        builder: (context) => MyInputAlertBox(
              controller: controller,
              text: 'Comment',
              hintText: "Write a comment...",
              onpressed: () async {
                // add post in Database
                await addComment();
              },
            ));
  }

  //? add comment to database
  Future<void> addComment() async {
    // does noting if there is nothing in the textfiels
    if (controller.text.trim().isEmpty) {
      Navigator.pop(context);
      return;
    }

    // attempt to post comment
    try {
      await databaseProvider.addComment(
          widget.post.id, controller.text.trim().toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //? load all comment when this state starts
  Future<void> _loadComment() async {
    await databaseProvider.loadComments(widget.post.id);
  }

  //! SHOW OPTIONS
  void showOptions() {
    // check if the post is owned by the user or not
    String currentId = AuthService().getUid();
    final bool isOwnPost = widget.post.uid == currentId;

    // show option
    showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.primary,
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              //* OWNED BY THE OWNER
              if (isOwnPost)
                //* delete button
                ListTile(
                  leading: Icon(
                    Icons.delete_rounded,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  title: Text(
                    'D E L E T E',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    await databaseProvider.deletePost(widget.post.id);
                    // handle the delete.
                  },
                )
              //* NOT OWNED BY THE OWNER
              else ...[
                //* report button
                ListTile(
                  leading: Icon(
                    Icons.report_problem,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  title: Text(
                    'R E P O R T',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  onTap: () {
                    Navigator.pop(context);

                    _reportPostConfirmationBox();
                  },
                ),
                //* block button
                ListTile(
                  leading: Icon(
                    Icons.block,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  title: Text(
                    'B L O C K',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  onTap: () {
                    Navigator.pop(context);

                    _blockPostConfirmationBox();
                  },
                ),
              ],
              //* Cancel button
              ListTile(
                leading: Icon(
                  Icons.cancel_rounded,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                title: Text(
                  'C A N C E L',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  //? SHOW REPORT CONFIRM BOX
  void _reportPostConfirmationBox() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Report Message"),
              content:
                  const Text("Are you sure you want to report this message?"),
              actions: [
                // cancel button
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel")),
                // report button
                TextButton(
                    onPressed: () async {
                      await databaseProvider.reportUser(
                          widget.post.id, widget.post.uid);

                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Message reported!")));
                    },
                    child: const Text("Report")),
              ],
            ));
  }

  //? SHOW BLOCK USER CONFIRM BOX
  void _blockPostConfirmationBox() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Block User"),
              content: const Text("Are you sure you want to block this user?"),
              actions: [
                // cancel button
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel")),
                // report button
                TextButton(
                    onPressed: () async {
                      await databaseProvider.blockUser(widget.post.uid);

                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("User has been blocked!")));
                    },
                    child: const Text("block")),
              ],
            ));
  }

  //! BUILD UI
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;

    //* does the current user like this post?
    bool likedByCurrentUser =
        listeningProvider.isPostLikedbyCurrentUser(widget.post.id);
    //* listen to like count from provider
    int likeCount = listeningProvider.getLikeCount(widget.post.id);

    //* listen to comment count
    int commentCount = listeningProvider.getComments(widget.post.id).length;

    //* Container
    return InkWell(
      onTap: widget.onPostTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
        // padding:const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          // color of post tile
          color: theme.secondary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //? Top section: profile pic / name / username
            InkWell(
              onTap: widget.onUserTap,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16, top: 8, right: 4, bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //profile pic
                    Icon(
                      Icons.person_rounded,
                      color: theme.primary,
                    ),

                    //name
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      widget.post.name,
                      style: TextStyle(color: theme.primary, fontSize: 14),
                    ),

                    //user name
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      '@${widget.post.username}',
                      style: TextStyle(
                          color: theme.primary,
                          fontWeight: FontWeight.w300,
                          fontSize: 14),
                    ),

                    //? buttons -> more options : delete
                    const Spacer(),
                    InkWell(
                        onTap: showOptions,
                        child: Icon(
                          Icons.more_vert_rounded,
                          color: theme.primary,
                        ))
                  ],
                ),
              ),
            ),
            //message
            const SizedBox(
              height: 4,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
              child: Text(widget.post.message),
            ),

            //? button -> like, comment
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
              child: Row(
                children: [
                  SizedBox(
                    width: 50,
                    child: Row(
                      children: [
                        GestureDetector(
                            onTap: _toggleLikePost,
                            child: likedByCurrentUser
                                ? const Icon(Icons.favorite_rounded,
                                    color: Colors.pink)
                                : Icon(
                                    Icons.favorite_outline_rounded,
                                    color: theme.primary,
                                  )),
                        const SizedBox(
                          width: 4,
                        ),
                        // Like count
                        Text(likeCount == 0 ? "" : likeCount.toString()),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: _openCommentBox,
                    child: Row(
                      children: [
                        Icon(Icons.comment_rounded, color: theme.primary),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(commentCount != 0 ? commentCount.toString() : ''),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
