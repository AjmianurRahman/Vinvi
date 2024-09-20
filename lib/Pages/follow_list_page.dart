import 'package:flutter/material.dart';
import 'package:flutter/material.dart.';
import 'package:provider/provider.dart';
import 'package:vinvi/Components/my_user_tile.dart';
import 'package:vinvi/Models/user.dart';
import 'package:vinvi/Services/Database/database_provider.dart';

class FollowListPage extends StatefulWidget {
  final String uid;
   FollowListPage({super.key, required this.uid});

  @override
  State<FollowListPage> createState() => _FollowListPageState();
}

class _FollowListPageState extends State<FollowListPage> {
  //* provider
  late final databaseProvidet = Provider.of<DatabaseProvider>(context, listen: false);
  late final listeningProvidet = Provider.of<DatabaseProvider>(context);


  //? Init state
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //* load follower list
    loadFollowerList();

    //* load following list
    loadFollowingList();
  }

  //? load follower list
  Future<void> loadFollowerList() async{
    await databaseProvidet.loadFollowersProfile(widget.uid);
  }
  //? load following list
  Future<void> loadFollowingList() async{
    await databaseProvidet.loadFollowingsProfile(widget.uid);
  }


  @override
  Widget build(BuildContext context) {
    //* listen to the followers and the following
    final followers = listeningProvidet.getListOfFollowersProfile(widget.uid);
    final following = listeningProvidet.getListOfFolloweingsProfile(widget.uid);



    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            foregroundColor: Theme.of(context).colorScheme.primary,
            bottom:  TabBar(
              dividerColor: Colors.transparent,
               
                labelPadding: EdgeInsets.all(8),
                labelColor: Theme.of(context).colorScheme.primary,
                labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                tabs: [
                  Text('Followers'), Text('Following')
                ]),
          ),
          body: TabBarView(children: [

            _buildUserList(followers, 'No followers'),
            _buildUserList(following, 'No following'),
          ]),
        ));
  }

  //? build user list, given a list of profiles
  Widget _buildUserList(List<UserProfile> usetList, String emptyMessage) {
    return usetList.isEmpty
        ? Center(child: Text(emptyMessage))
        : ListView.builder(
            itemCount: usetList.length, itemBuilder: (context, index) {
              final user = usetList[index];
              
              return MyUserTile(user: user);
    });
  }
}
