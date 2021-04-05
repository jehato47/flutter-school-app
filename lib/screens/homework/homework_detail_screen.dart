import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../helpers/download/download_helper_provider.dart';
import '../../providers/homework.dart';

class HomeWorkDetailScreen extends StatefulWidget {
  static const url = "/hw-detail";

  @override
  _HomeWorkDetailScreenState createState() => _HomeWorkDetailScreenState();
}

class _HomeWorkDetailScreenState extends State<HomeWorkDetailScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hw = ModalRoute.of(context).settings.arguments as dynamic;
    return Scaffold(
      appBar: AppBar(
        title: Text('${hw["title"]} ${hw["classFirst"]} - ${hw["classLast"]}'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ödev",
                style: TextStyle(fontSize: 25),
              ),
              Divider(
                thickness: 2,
              ),
              Text(
                hw["homework"],
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: 40),
              Text(
                "Açıklama",
                style: TextStyle(fontSize: 25),
              ),
              Divider(
                thickness: 2,
              ),
              Text(
                hw["explanation"],
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: 40),
              Text(
                "Dosya",
                style: TextStyle(fontSize: 25),
              ),
              Divider(
                thickness: 2,
              ),
              InkWell(
                onTap: hw["fileName"] == null
                    ? null
                    : () async {
                        final url = await Provider.of<HomeWork>(context)
                            .getDownloadUrl(hw);
                        Provider.of<Download>(context).downloadFile(
                          url,
                          hw["fileName"],
                        );
                      },
                child: Text(
                  hw["fileName"] != null
                      ? hw["fileName"]
                      : "İliştirilmiş dosya yok",
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
