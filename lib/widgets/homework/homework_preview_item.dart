import 'package:flutter/material.dart';
import '../../providers/auth.dart';
import '../../providers/homework.dart';
import '../../screens/homework/homework_detail_screen.dart';
import 'package:provider/provider.dart';

class HomeworkPreviewItem extends StatelessWidget {
  final dynamic hw;
  HomeworkPreviewItem(this.hw);

  @override
  Widget build(BuildContext context) {
    final token = Provider.of<Auth>(context).token;
    return Card(
      elevation: 4,
      child: InkWell(
        onLongPress: () async {
          await Provider.of<HomeWork>(context).deleteHw(
            hw["id"],
            token,
          );
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
              "https://schoolapi.pythonanywhere.com" + hw["teacher_image"],
            ),
          ),
          title: Text(hw["baslik"]),
          subtitle: Text(hw["icerik"]),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                hw["baslangic_tarihi"],
                style: TextStyle(color: Colors.green),
              ),
              Text(
                hw["bitis_tarihi"],
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
