import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vinvi/Components/my_user_tile.dart';
import 'package:vinvi/Services/Database/database_provider.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();

    //* Provider
    late final dbProvider =
        Provider.of<DatabaseProvider>(context, listen: false);
    late final lProvidre = Provider.of<DatabaseProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(

       // backgroundColor: Theme.of(context).colorScheme.primary,
        title: TextField(
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
          controller: searchController,
          decoration: InputDecoration(
              hintText: 'Search user', border: InputBorder.none),
          onChanged: (value) {
            if (!value.isEmpty) {
              dbProvider.searchUser(searchController.text.toString());
            }else{
              dbProvider.searchUser('');
            }
          },
        ),
      ),

      body: lProvidre.searchResults.isNotEmpty?
      Center(child: Text('No user found...'))
          :
          ListView.builder(
              itemCount: lProvidre.searchResults.length,
              itemBuilder: (context, index){
                final user = lProvidre.searchResults[index];
                return MyUserTile(user: user);
          })
      ,
    );
  }
}
