import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../helpers/download/download_helper_provider.dart';
import '../../providers/homework.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class HomeWorkDetailScreen extends StatefulWidget {
  static const url = "/hw-detail";

  @override
  _HomeWorkDetailScreenState createState() => _HomeWorkDetailScreenState();
}

class _HomeWorkDetailScreenState extends State<HomeWorkDetailScreen> {
  void _launchURL(_url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

  @override
  Widget build(BuildContext context) {
    final hw = ModalRoute.of(context).settings.arguments as dynamic;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${hw["teacher"]} ${hw["classFirst"]} - ${hw["classLast"].toUpperCase()}'),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.assignment),
          //   onPressed: () {},
          // ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
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
                        final url =
                            await Provider.of<HomeWork>(context, listen: false)
                                .getDownloadUrl(hw["fileRef"]);
                        if (kIsWeb) {
                          _launchURL(url);
                        } else
                          _launchURL(url);

                        // Provider.of<Download>(context, listen: false)
                        //     .downloadFile(
                        //   url,
                        //   hw["fileName"],
                        // );
                      },
                child: Text(
                  hw["fileName"] != null
                      ? hw["fileName"]
                      : "İliştirilmiş dosya yok",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
