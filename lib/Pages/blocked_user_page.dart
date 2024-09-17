import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Services/Database/database_provider.dart';

class BlockedUserPage extends StatefulWidget {
  const BlockedUserPage({super.key});

  @override
  State<BlockedUserPage> createState() => _BlockedUserPageState();
}

class _BlockedUserPageState extends State<BlockedUserPage> {
  // providers
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);

  //? Init state
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // load blocked users
    loadBlockedUsrs();
  }

  //? Load all blocked usrs
  void loadBlockedUsrs() async{
    await databaseProvider.loadBlockedUsers();
  }

  //? Show unblock box
  void _showBlockUserBox(String uid) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Unblock User"),
          content: const Text("Are you sure you want to unblock this user?"),
          actions: [
            // cancel button
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel")),
            // report button
            TextButton(
                onPressed: () async {

                  await databaseProvider.unBlockUser(uid);

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("User has been unblocked!")));
                },
                child: const Text("Unblock")),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;

    final blockedUsrs = listeningProvider.blockedUSers;

    return Scaffold(
      backgroundColor: theme.surface,
      appBar: AppBar(
        iconTheme: IconThemeData(color: theme.tertiary, weight: 1),
        title: Text(
          'B L O C K E D  U S E R S',
          style: TextStyle(color: theme.tertiary, fontWeight: FontWeight.w300),
        ),
        centerTitle: true,
        backgroundColor: theme.primary,
      ),

      body: blockedUsrs.isEmpty?
         const Center(child: Text("No blocked user..."))
          :
          ListView.builder(
            itemCount: blockedUsrs.length,
              itemBuilder: (context,index){

              final user = blockedUsrs[index];

              return ListTile(title: Text(user.name),
              subtitle: Text("@${user.userName}"),
              leading: Icon(Icons.supervised_user_circle, size: 32, color: theme.primary,),
              trailing: IconButton(
                onPressed: ()=> _showBlockUserBox(user.uid),
                icon:  Icon(Icons.block_flipped, color: theme.primary),
              ),);

          })
      ,
    );
  }
}
