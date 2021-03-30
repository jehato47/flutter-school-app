import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/notification.dart';
import '../../providers/auth.dart';

class NotificationScreen extends StatefulWidget {
  static const url = "/notification";
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final token = Provider.of<Auth>(context).token;
    return Scaffold(
      appBar: AppBar(
        title: Text("Bildirimler"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
            future: Provider.of<NotificationP>(context).getNotifications(token),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(
                  child: CircularProgressIndicator(),
                );
              print(snapshot.data);
              final data = List.from(snapshot.data.reversed);
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) => Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.notification_important),
                      // selected: true,
                      title: Text(
                        data[index]["içerik"],
                        // style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
                      ),
                      subtitle: Text(data[index]["oluşturan"]),
                      trailing: Icon(
                        Icons.file_present,
                        // color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Divider(
                      thickness: 1.2,
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
