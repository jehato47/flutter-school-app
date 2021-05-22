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
    dynamic etude = widget.etude;
    dynamic etudeRequest = widget.etudeRequest;
    // if (!etude["registered"].contains(etudeRequest["uid"])) return Container();

    return Container(
      width: 150,
      margin: EdgeInsets.only(right: 5),
      color: Colors.black12,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(etude["teacherName"]),
          Text(etude["lecture"]),
          Text(DateFormat("d MMMM EEEE").format(etude["date"].toDate())),
          Text("${etude["registered"].length} kişi kayıtlı"),
          ElevatedButton(
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
                    }
                  },
            child: Text(etude["registered"].contains(etudeRequest["uid"])
                ? "Geri Al"
                : "kaydet"),
          )
        ],
      ),
    );
  }
}
