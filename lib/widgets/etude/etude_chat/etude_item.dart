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
  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    dynamic etude = widget.etude;
    dynamic etudeRequest = widget.etudeRequest;
    // if (!etude["registered"].contains(etudeRequest["uid"])) return Container();

    return Container(
        width: 150,
        margin: EdgeInsets.only(right: 5),
        color: Colors.black12,
        // padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.indigo,
            child: Text(etude["registered"].length.toString()),
          ),
          title: Text(etude["teacherName"]),
          subtitle:
              Text(DateFormat("dd MMMM HH:mm").format(etude["date"].toDate())),
          trailing: ElevatedButton(
            onPressed: etudeRequest["state"] == "done" &&
                    etude.reference != etudeRequest["ref"]
                ? null
                : () async {
                    List registered = etude["registered"];
                    if (!registered.contains(etudeRequest["uid"])) {
                      registered.add(etudeRequest["uid"]);

                      await FirebaseFirestore.instance
                          .collection("etude")
                          .doc(etude.id)
                          .update({"registered": registered});

                      await FirebaseFirestore.instance
                          .collection("etudeRequest")
                          .doc(etudeRequest.id)
                          .update({"state": "done", "ref": etude.reference});

                      // TODO : düzenle burayı
                      await FirebaseFirestore.instance
                          .collection("etudeChat")
                          .add({
                        "created": true,
                        "date": DateTime.now(),
                        "displayName": auth.currentUser.displayName,
                        "eRequestid": etudeRequest.id,
                        "note":
                            "Etüdünüz ${etude["date"].toDate().toString()} tarihi için oluşturuldu",
                        "uid": auth.currentUser.uid,
                      });
                    } else {
                      registered.removeWhere(
                          (element) => element == etudeRequest["uid"]);

                      await FirebaseFirestore.instance
                          .collection("etude")
                          .doc(etude.id)
                          .update({"registered": registered});

                      await FirebaseFirestore.instance
                          .collection("etudeRequest")
                          .doc(etudeRequest.id)
                          .update({"state": "waiting", "ref": null});

                      // TODO : düzenle burayı
                      final x = await FirebaseFirestore.instance
                          .collection("etudeChat")
                          .where("created", isEqualTo: true)
                          .where("eRequestid", isEqualTo: etudeRequest.id)
                          .get();

                      await FirebaseFirestore.instance
                          .collection("etudeChat")
                          .doc(x.docs[0].id)
                          .delete();
                    }
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
            child: Text(etude["registered"].contains(etudeRequest["uid"])
                ? "Geri Al"
                : "kaydet"),
          ),
        ));
  }
}
