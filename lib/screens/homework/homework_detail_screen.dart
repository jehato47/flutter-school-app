import 'dart:ui';
import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';
import '../../helpers/download/download_helper_provider.dart';

class HomeWorkDetailScreen extends StatefulWidget {
  static const url = "/hw-detail";

  @override
  _HomeWorkDetailScreenState createState() => _HomeWorkDetailScreenState();
}

class _HomeWorkDetailScreenState extends State<HomeWorkDetailScreen> {
  // static void downloadingCallback(id, status, progress) async {
  //   SendPort sendPort = IsolateNameServer.lookupPortByName("downloading");
  //   sendPort.send([id, status, progress]);
  // }

  // ReceivePort _receivePort = ReceivePort();

  // int progress = 0;
  // @override
  // void initState() {
  //   super.initState();
  //   IsolateNameServer.registerPortWithName(
  //     _receivePort.sendPort,
  //     "downloading",
  //   );
  //   _receivePort.listen((message) {
  //     // setState(() {
  //     //   progress = message[2];
  //     // });
  //   });
  //   FlutterDownloader.registerCallback(downloadingCallback);
  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hw = ModalRoute.of(context).settings.arguments as dynamic;
    return Scaffold(
      appBar: AppBar(
        title: Text(hw["baslik"]),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                hw["icerik"],
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
                hw["aciklama"],
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
                onTap: () async {
                  Provider.of<Download>(context).downloadFile(
                    "https://schoolapi.pythonanywhere.com" + hw["dosya"],
                  );
                },
                child: Text(
                  hw["dosya"] != null
                      ? "https://schoolapi.pythonanywhere.com" + hw["dosya"]
                      : "Dosya yok",
                ),
              ),
              SizedBox(height: 20),
              // Text(progress.toString()),
            ],
          ),
        ),
      ),
    );
  }
}
