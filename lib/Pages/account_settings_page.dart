import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vinvi/Services/Auth/auth_service.dart';
import 'package:vinvi/Services/Database/database_provider.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
// provider
late final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);


  //? Show delete account confirm dialog
  void showDeleteConfirmDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Delete Account"),
          content: const Text("Are you sure you want to delete this account?"),
          actions: [
            // cancel button
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel")),
            // report button
            TextButton(
                onPressed: () async {
                  await AuthService().deleteAccount();

                  Navigator.pop(context);

                  // Navigate to login page
                  Navigator.pushNamedAndRemoveUntil(context, '/', (route)=>false);

                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Account has been deleted!")));
                },
                child: const Text("Delete")),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: theme.surface,
      appBar: AppBar(
        iconTheme: IconThemeData(color: theme.tertiary, weight: 1),
        title: Text(
          'A C C O U N T  S E T T I N G S',
          style: TextStyle(color: theme.tertiary, fontWeight: FontWeight.w300),
        ),
        centerTitle: true,
        backgroundColor: theme.primary,
      ),

      body: Column(
        children: [
          InkWell(
            onTap: ()=> showDeleteConfirmDialog(),
            child: Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(8)),
              child: Center(child: Text('Delete account', style: TextStyle(fontSize:18,fontWeight: FontWeight.bold, color: theme.tertiary),),),
            ),
          )
        ],
      ),
    );
  }
}
