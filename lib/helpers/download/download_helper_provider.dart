import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class Download extends ChangeNotifier {
  Future<void> downloadFile(String url) async {
    final externalDir = await getExternalStorageDirectory();
    final x = await getExternalStorageDirectories();
    // final q = await get
    print(x[1].path);

    // x.forEach((element) {
    //   print(element);
    // });
    final status = await Permission.storage.request();
    if (!status.isGranted) return;

    print(externalDir.path);
    final id = await FlutterDownloader.enqueue(
      url: url,
      savedDir: "/storage/emulated/0/Download",
      fileName: url.split("/").last,
      showNotification: true,
      openFileFromNotification: true,
    );
  }
}
