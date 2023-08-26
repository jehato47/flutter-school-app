import 'package:flutter/material.dart';
import '../../screens/homework/filter_screen.dart';
import '../../providers/homework.dart';
import '../../screens/homework/homework_detail_screen.dart';
import 'package:provider/provider.dart';

class HomeworkItem extends StatelessWidget {
  final dynamic hw;
  HomeworkItem(this.hw);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onLongPress: () async {
            await Provider.of<HomeWork>(context, listen: false)
                .deleteHomework(hw);
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
            title: Text(
              hw["teacher"],
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${hw["homework"]}",
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      HomeworkFilterScreen.url,
                      arguments: hw["lecture"],
                    );
                  },
                  child: Text(
                    "#${hw["lecture"]}",
                    style: TextStyle(
                      color:
                          hw["lecture"] == "türkçe" ? Colors.red : Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
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
