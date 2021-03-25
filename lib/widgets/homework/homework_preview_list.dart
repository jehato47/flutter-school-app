import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/homework.dart';
import '../../providers/auth.dart';
import 'homework_preview_item.dart';

class HomeworkPreviewList extends StatefulWidget {
  @override
  _HomeworkPreviewListState createState() => _HomeworkPreviewListState();
}

class _HomeworkPreviewListState extends State<HomeworkPreviewList> {
  @override
  Widget build(BuildContext context) {
    final token = Provider.of<Auth>(context).token;

    return FutureBuilder(
      future: Provider.of<HomeWork>(context, listen: false).getHwByClass(token),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());
        final data = snapshot.data as List<dynamic>;
        // print(data[0]);

        return Padding(
          padding: EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return HomeworkPreviewItem(
                data[index],
              );
            },
          ),
        );
      },
    );
  }
}
