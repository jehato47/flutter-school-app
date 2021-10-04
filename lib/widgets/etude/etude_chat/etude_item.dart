import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EtudeItem extends StatefulWidget {
  final dynamic etude;
  final dynamic etudeRequest;
  EtudeItem(this.etude, this.etudeRequest);
  @override
  _EtudeItemState createState() => _EtudeItemState();
}

class _EtudeItemState extends State<EtudeItem> {
  bool clicked = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  dynamic etude;
  dynamic etudeRequest;

  Future<void> notRegisteredCase() async {
    List registered = etude["registered"];
    List requests = etude["requests"];

    registered.add(etudeRequest["uid"]);
    requests.add(etudeRequest.id);
    String note =
        "${DateFormat("d MMMM EEEE").format(etude["date"].toDate()) + "\nsaat " + DateFormat("HH:mm").format(etude["date"].toDate())} için etüdünüz oluşturuldu";

    await FirebaseFirestore.instance.collection("etudeChat").add({
      "created": true,
      "date": DateTime.now(),
      "displayName": auth.currentUser.displayName,
      "eRequestid": etudeRequest.id,
      "note": note,
      "uid": auth.currentUser.uid,
    });
    // TODO : Bak
    bool onSaved = registered.length != 0;
    await FirebaseFirestore.instance.collection("etude").doc(etude.id).update({
      "registered": registered,
      "requests": requests,
      "onSaved": onSaved,
      "note": "etude",
    });

    await FirebaseFirestore.instance
        .collection("etudeRequest")
        .doc(etudeRequest.id)
        .update({"state": "done", "ref": etude.reference});

    final e = await FirebaseFirestore.instance
        .collection("timetable")
        .doc(etude.id)
        .get();
    QueryDocumentSnapshot doc;
    // doc.reference.path
    if (!e.exists)
      await FirebaseFirestore.instance
          .collection("timetable")
          .doc(etude.id)
          .set({
        "subject": "${etude["lecture"]} Etüt",
        "date": etude["date"],
        "isRecursive": false,
        "uids": [etude["uid"], ...registered],
        "note": etude.reference.path,
      });
    else
      await FirebaseFirestore.instance
          .collection("timetable")
          .doc(etude.id)
          .update({
        "uids": [etude["uid"], ...registered]
      });

    Navigator.of(context).pop(true);
  }

  Future<void> stillRegisteredCase() async {
    List registered = etude["registered"];
    List requests = etude["requests"];

    registered.removeWhere((element) => element == etudeRequest["uid"]);
    requests.removeWhere((element) => element == etudeRequest.id);

    bool onSaved = registered.length != 0;
    await FirebaseFirestore.instance.collection("etude").doc(etude.id).update({
      "registered": registered,
      "requests": requests,
      "onSaved": onSaved,
    });

    await FirebaseFirestore.instance
        .collection("etudeRequest")
        .doc(etudeRequest.id)
        .update({"state": "waiting", "ref": null});

    // Oluşturuldu mesajını siler
    final x = await FirebaseFirestore.instance
        .collection("etudeChat")
        .where("created", isEqualTo: true)
        .where("eRequestid", isEqualTo: etudeRequest.id)
        .get();

    x.docs.forEach((messg) async {
      await FirebaseFirestore.instance
          .collection("etudeChat")
          .doc(messg.id)
          .delete();
    });
    // await FirebaseFirestore.instance
    //     .collection("etudeChat")
    //     .doc(x.docs[0].id)
    //     .delete();
    if (registered.length == 0) {
      await FirebaseFirestore.instance
          .collection("timetable")
          .doc(etude.id)
          .delete();
      print(123123);
    } else
      await FirebaseFirestore.instance
          .collection("timetable")
          .doc(etude.id)
          .update({
        "uids": [etude["uid"], ...registered]
      });

    Navigator.of(context).pop(false);
  }

  Future<void> pressed() async {
    clicked = true;
    List registered = etude["registered"];
    List requests = etude["requests"];

    if (!registered.contains(etudeRequest["uid"]) ||
        !requests.contains(etudeRequest.id))
      await notRegisteredCase();
    else
      await stillRegisteredCase();

    // DocumentSnapshot snapshot = await FirebaseFirestore.instance
    //     .collection("etudeRequest")
    //     .doc(etudeRequest.id)
    //     .get();

    // etudeRequest = snapshot;

    // print(snapshot["state"]);
  }

  @override
  Widget build(BuildContext context) {
    etude = widget.etude;
    etudeRequest = widget.etudeRequest;

    bool isSaved = etude["requests"].contains(etudeRequest.id);

    return Container(
        width: 150,
        margin: EdgeInsets.only(right: 5),
        color: Colors.black12,
        // padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: ListTile(
          onTap: () {},
          leading: CircleAvatar(
            backgroundColor: Colors.indigo,
            child: Text(etude["registered"].length.toString()),
          ),
          title: Text(etude["teacherName"]),
          subtitle: Text(
              DateFormat("dd MMMM EEE HH:mm").format(etude["date"].toDate())),
          trailing: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("etudeRequest")
                  .doc(etudeRequest.id)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return ElevatedButton(
                    child: const Text(""),
                    onPressed: () {},
                  );
                }
                // bool isSaved2 = snapshot.data["ref"] == etude.reference;
                bool isDone = snapshot.data["state"] == "done";
                bool isThis = snapshot.data["ref"] == etude.reference;

                return ElevatedButton(
                  // style: ButtonStyle(textStyle: ),
                  style: ElevatedButton.styleFrom(
                    primary: isThis ? Colors.deepPurple : Colors.indigo,
                    // padding:
                    //     EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    // textStyle:
                    //     TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  onPressed: isDone && !isThis ? null : pressed,
                  child: Text(
                    isThis ? "geri al" : "kaydet",
                  ),
                );
              }),
        ));
  }
}
