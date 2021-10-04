import 'package:flutter/material.dart';
import 'etude_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GiveEtudeBottomSheet extends StatefulWidget {
  final dynamic doc;
  GiveEtudeBottomSheet(
    this.doc,
  );

  @override
  _GiveEtudeBottomSheetState createState() => _GiveEtudeBottomSheetState();
}

class _GiveEtudeBottomSheetState extends State<GiveEtudeBottomSheet> {
  @override
  Widget build(BuildContext context) {
    dynamic doc = widget.doc;
    final theme = Theme.of(context);

    return Column(
      children: [
        ListTile(
          title: Text(
            'Etütler',
            style: theme.textTheme.subtitle1
                .copyWith(color: theme.colorScheme.onPrimary),
          ),
          tileColor: theme.colorScheme.primary,
        ),
        Expanded(
          child: StreamBuilder<Object>(
            stream: FirebaseFirestore.instance
                .collection("etude")
                .where("lecture", isEqualTo: doc["lecture"])
                .where("date", isGreaterThanOrEqualTo: DateTime.now())
                .orderBy("date")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(
                  child: CircularProgressIndicator(),
                );
              QuerySnapshot snap = snapshot.data;
              List<QueryDocumentSnapshot> docs = snap.docs;

              return ListView.builder(
                // scrollDirection: Axis.horizontal,
                itemCount: docs.length,
                itemBuilder: (context, index) => EtudeItem(
                  docs[index],
                  doc,
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
