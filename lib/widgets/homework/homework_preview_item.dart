import 'package:flutter/material.dart';
import '../../providers/homework.dart';
import '../../screens/homework/homework_detail_screen.dart';
import 'package:provider/provider.dart';

class HomeworkPreviewItem extends StatelessWidget {
  final dynamic hw;
  HomeworkPreviewItem(this.hw);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onLongPress: () async {
            await Provider.of<HomeWork>(context).deleteHomework(hw);
          },
          borderRadius: BorderRadius.circular(4),
          onTap: () {
            Navigator.of(context).pushNamed(
              HomeWorkDetailScreen.url,
              arguments: hw,
            );
          },
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                hw["teacherImage"],
              ),
            ),
            title: Text(hw["title"]),
            subtitle: Text(hw["homework"]),
            trailing: Text(
              hw["dueDate"].toDate().difference(DateTime.now()).inDays <= 0
                  ? "Bitti"
                  : hw["dueDate"]
                          .toDate()
                          .difference(DateTime.now())
                          .inDays
                          .toString() +
                      " gün",
            ),
          ),
        ),
        Divider(thickness: 1)
      ],
    );
  }
}
