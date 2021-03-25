import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../widgets/home/pages_grid.dart';

class HomeScreen extends StatelessWidget {
  static const url = "home";
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context).userInform;
    return Scaffold(
      // TODO : AppBar olmayacak
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
        title: Text(user["isim"] + " " + user["soyisim"]),
      ),
      body: PagesGrid(),
    );
  }
}
