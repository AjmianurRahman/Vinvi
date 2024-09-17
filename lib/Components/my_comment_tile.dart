import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vinvi/Models/comment.dart';
import 'package:vinvi/Services/Auth/auth_service.dart';
import 'package:vinvi/Services/Database/database_provider.dart';

/*

* COMMENT TILE
  this is the comment tile widget which belongs below a post. It's similar to the post
  tile widget, but make the comments look slight different to posts.

---------------------------------------------------

  * the comment 
  * a function (for when the user taps and wants to go to the user profile)

 */

class MyCommentTile extends StatelessWidget {
  final Comment comment;
  final void Function()? onUserTap;

  MyCommentTile({super.key, required this.comment, required this.onUserTap});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 4),
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
            onTap: onUserTap,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 16, top: 8, right: 4, bottom: 4),
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
                    comment.name,
                    style: TextStyle(color: theme.primary, fontSize: 14),
                  ),

                  //user name
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    '@${comment.username}',
                    style: TextStyle(
                        color: theme.primary,
                        fontWeight: FontWeight.w300,
                        fontSize: 14),
                  ),

                  //? buttons -> more options : delete
                  const Spacer(),
                  InkWell(
                      onTap: () {
                        showOptions(context);
                      },
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
            child: Text(comment.message),
          ),
        ],
      ),
    );
  }

  //! SHOW OPTIONS
  void showOptions(BuildContext context) {
    // check if the post is owned by the user or not
    String currentId = AuthService().getUid();
    final bool isOwnPost = comment.uid == currentId;

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
                //delete button
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
                    await Provider.of<DatabaseProvider>(context, listen: false)
                        .deleteComment(comment.id, comment.postId);
                    // handle the delete.
                  },
                )
              //* NOT OWNED BY THE OWNER
              else ...[
                // report button
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
                  },
                ),
                // block button
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
                  },
                ),
              ],
              // Cancel button
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
}
