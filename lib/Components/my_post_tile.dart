import 'package:flutter/material.dart';
import 'package:vinvi/Models/post.dart';


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

  const MyPostTile({super.key, required this.post, required this.onUserTap, required this.onPostTap});

  @override
  State<MyPostTile> createState() => _MyPostTileState();
}

class _MyPostTileState extends State<MyPostTile> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: widget.onPostTap,
      child: Container(
        margin:const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
        padding:const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          // color of post tile
          color: theme.secondary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Top section: profile pic / name / username
            InkWell(
              onTap:  widget.onUserTap,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //profile pic
                  Icon(
                    Icons.person_rounded,
                    color: theme.primary,
                  ),
                  //name
                 const SizedBox(width: 8,),
                  Text(widget.post.name,
                  style: TextStyle(color: theme.primary, fontSize: 14),),
                  //user name
                const  SizedBox(width: 8,),
                  Text('@${widget.post.username}',
                    style: TextStyle(color: theme.primary, fontWeight: FontWeight.w300, fontSize: 14),)
                ],
              ),
            ),
            //message
            const SizedBox(height: 4,),
            Text(widget.post.message),
          ],
        ),
      ),
    );
  }
}
