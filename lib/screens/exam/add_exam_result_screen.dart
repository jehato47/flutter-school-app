import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/exam.dart';

class AddExamResultScreen extends StatefulWidget {
  static const url = "add-ex-res";

  @override
  _AddExamResultScreenState createState() => _AddExamResultScreenState();
}

class _AddExamResultScreenState extends State<AddExamResultScreen> {
  String lecture = "matematik";
  dynamic generalData = {};
  final _formKey = GlobalKey<FormState>();
  int index = 0;
  List<QueryDocumentSnapshot> ids;
  bool isInit = true;
  dynamic args;
  dynamic examData;
  showPickerModal(BuildContext context) async {
    // final att = FirebaseFirestore.instance.collection('attendance');

    // QuerySnapshot attendance = await att.get();
    // final classes = attendance.docs.map((e) => e.id).toList();
    final students = ids.map((e) => e["displayName"]).toList();
    // return;
    FocusScope.of(context).unfocus();
    await Future.delayed(Duration(milliseconds: 10));
    new Picker(
        adapter: PickerDataAdapter<String>(pickerdata: students),
        changeToFirst: true,
        hideHeader: false,
        confirmText: "Seç",
        cancelText: "Iptal",
        diameterRatio: 2,
        magnification: 1,
        selecteds: [index],
        height: 250,
        // columnFlex: [10],
        title: Text(""),
        onConfirm: (Picker picker, List value) {
          setState(() {
            index = value.first;
            // currentClass = picker.getSelectedValues().first;
          });
        }).showModal(this.context);
  }

  Widget buildItem(int number) {
    TextEditingController controller = TextEditingController();
    if (generalData.containsKey(ids[index].id)) {
      examData = generalData[ids[index].id][lecture];
    } else {
      examData = ids[index][lecture];
    }
    if (examData["$number"] != null) {
      controller.text = examData["$number"].toString();
      // generalData[ids[index].id] = {lecture: examData};
    }

    return Column(
      children: [
        ListTile(
          title: Text("$number. sınav"),
          trailing: Container(
            width: 70,
            height: 50,
            child: TextFormField(
              textInputAction: TextInputAction.next,
              onChanged: (value) {
                if (value != "") {
                  try {
                    if (double.parse(value) < 0 || double.parse(value) > 100) {
                      controller.text = controller.text.substring(0, 2);
                    }

                    examData["$number"] = int.parse(controller.text);
                  } catch (err) {
                    examData["$number"] = double.parse(controller.text);
                  }
                  generalData[ids[index].id] = {lecture: examData};
                }
              },
              controller: controller,
              validator: (value) {
                try {
                  if (value != "" &&
                      (double.parse(value) < 0 || double.parse(value) > 100)) {
                    controller.text = controller.text.substring(0, 2);
                  }
                } catch (err) {
                  return "";
                }
                return null;
              },
              maxLength: 4,
              decoration: InputDecoration(
                counterText: "",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          ),
        ),
        Divider()
      ],
    );
  }

  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments;
    if (isInit) {
      ids = args[0];
      index = args[1];
    }
    isInit = false;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              CollectionReference reference =
                  FirebaseFirestore.instance.collection("exam");

              generalData.forEach((key, value) async {
                await reference.doc(key).update(value);
              });
              await Provider.of<Exam>(context).setDetails(lecture);
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
        title: Text("Sınav Sonucu"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              ListTile(
                trailing: Icon(Icons.autorenew_sharp),
                onTap: () async {
                  FocusScope.of(context).unfocus();
                  await Future.delayed(Duration(milliseconds: 10));
                  await showPickerModal(context);
                },
                leading: Text(
                  "${index + 1}/${ids.length}",
                  style: TextStyle(fontSize: 25),
                ),
                title: Text(
                  ids[index]["displayName"],
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Divider(thickness: 1),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, i) {
                    return buildItem(i + 1);
                  },
                  itemCount: ids[index][lecture].length,
                ),
              ),
              Row(
                children: [
                  if (index != 0)
                    Expanded(
                      child: ElevatedButton(
                        child: Text("önceki"),
                        onPressed: () async {
                          setState(() {
                            index -= 1;
                          });
                        },
                      ),
                    ),
                  if (index != 0) SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      child:
                          Text(index == ids.length - 1 ? "Bitti" : "sonraki"),
                      onPressed: () async {
                        if (index < ids.length - 1)
                          setState(() {
                            index += 1;
                          });
                        else {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
