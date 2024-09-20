import 'package:flutter/material.dart';

class MyProfileStats extends StatelessWidget {
  final int postCount;
  final int followerCount;
  final int followingCount;
  final void Function()? onTap;
   const MyProfileStats({super.key, required this.postCount, required this.followerCount, required this.followingCount,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //0 post
            SizedBox(
              width: 100,
              child: Column(
                children: [
                  Text('$postCount', style: const TextStyle( fontSize: 20),),
                  Text('posts',style: TextStyle(color: Colors.grey.shade500, fontSize: 16
                  )),
                ],
              ),
            ),

            //0 followers
            SizedBox(
              width: 100,
              child: Column(
                children: [
                  Text('$followerCount',style: const TextStyle( fontSize: 20)),
                  Text('followers',style: TextStyle(color: Colors.grey.shade500, fontSize: 16))
                ],
              ),
            ),

            //0 following
            SizedBox(
              width: 100,
              child: Column(
                children: [
                  Text('$followingCount',style: const TextStyle( fontSize: 20)),
                  Text('following',style: TextStyle(color: Colors.grey.shade500, fontSize: 16))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
