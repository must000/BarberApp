import 'package:barber/Constant/contants.dart';
import 'package:barber/pages/Hairdresser/queue_setting_hairdresser.dart';
import 'package:barber/utils/dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class QueueHairdresser extends StatefulWidget {
  String hairdresserID;
  String barberState;
  String idCode;
  QueueHairdresser({
    Key? key,
    required this.hairdresserID,
    required this.barberState,
    required this.idCode,
  }) : super(key: key);

  @override
  State<QueueHairdresser> createState() => _QueueHairdresserState(
      hairdresserID: hairdresserID, barberState: barberState, idCode: idCode);
}

class _QueueHairdresserState extends State<QueueHairdresser> {
  String hairdresserID;
  String barberState;
  String idCode;
  String idClick = "";
  DateTime selectedDate = DateTime.now();
  // final Uri _url = Uri.parse('https://flutter.dev');
  _QueueHairdresserState(
      {required this.hairdresserID,
      required this.barberState,
      required this.idCode});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Contants.myBackgroundColor,
      body: SafeArea(
          child: barberState == "no"
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "ยังไม่มีร้านทำผมสำหรับไอดีนี้",
                        style: Contants().h2white(),
                      ),
                      Text(
                        idCode,
                        style: Contants().h1yellow(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("หรือ สแกน",
                            style: Contants().h3white(),),
                                      Text("QRcode",
                            style: Contants().h3yellow(),),
                        ],
                      ),
                      Container(
                        color: Contants.colorWhite,
                        child: QrImage(
                          data: idCode,
                          version: QrVersions.auto,
                          size: 200.0,
                        ),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedDate = selectedDate
                                          .subtract(const Duration(days: 1));
                                    });
                                  },
                                  icon: Icon(
                                    Icons.arrow_back_ios_new,
                                    color: Contants.colorWhite,
                                  )),
                              ElevatedButton(
                                onPressed: () {
                                  _selectedDate(context);
                                },
                                child: Text(
                                  "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                                  style: Contants().h2OxfordBlue(),
                                ),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Contants.colorWhite),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedDate = selectedDate
                                          .add(const Duration(days: 1));
                                    });
                                  },
                                  icon: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Contants.colorWhite,
                                  ))
                            ],
                          ),
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          QueueSettingHairdresser(
                                              emailBarber: barberState,
                                              idHairdresser: hairdresserID),
                                    ));
                              },
                              icon: Icon(
                                Icons.settings,
                                color: Contants.colorWhite,
                                size: 40,
                              )),
                        ],
                      ),
                      const SizedBox(height: 10),
                      buildQueue(),
                    ],
                  ),
                )),
    );
  }

  Widget buildQueue() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Queue')
            .where("hairdresser.id", isEqualTo: hairdresserID)
            .where("barber.id", isEqualTo: barberState)
            .orderBy("time.timestart")
            .startAt([(DateFormat('yyyy-MM-dd').format(selectedDate))]).endAt([
          (DateFormat('yyyy-MM-dd')
              .format(selectedDate.add(const Duration(days: 1))))
        ]).snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data.docs;
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (data[index]["status"] == "on") {
                      if (idClick == data[index].id) {
                        setState(() {
                          idClick = "";
                        });
                      } else {
                        setState(() {
                          idClick = data[index].id;
                        });
                      }
                    }
                  },
                  child: Container(
                      margin: const EdgeInsets.all(10),
                      color: Contants.colorGreySilver,
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "ชื่อ : ${data[index]["user"]["name"]}",
                                  style: Contants().h3white(),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_alarm,
                                      color: Contants.colorWhite,
                                    ),
                                    Text(
                                      "${DateTime.parse(data[index]["time"]["timestart"]).hour.toString().padLeft(2, "0")}.${DateTime.parse(data[index]["time"]["timestart"]).minute.toString().padLeft(2, "0")} - ${DateTime.parse(data[index]["time"]["timeend"]).hour.toString().padLeft(2, "0")}.${DateTime.parse(data[index]["time"]["timeend"]).minute.toString().padLeft(2, "0")} น.",
                                      style: Contants().h3white(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "สถานะ : ",
                                  style: Contants().h3white(),
                                ),
                                Text(
                                  data[index]["status"] == "on"
                                      ? "รอ"
                                      : data[index]["status"] == "succeed"
                                          ? "สำเร็จ"
                                          : "ยกเลิก",
                                  style: data[index]["status"] == "on"
                                      ? Contants().h2OxfordBlue()
                                      : data[index]["status"] == "succeed"
                                          ? Contants().h2SpringGreen()
                                          : Contants().h2Red(),
                                )
                              ],
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, i) {
                                if (i == 0) {
                                  return Text(
                                    "บริการ : ${data[index]["service"][i]["name"]}",
                                    style: Contants().h3white(),
                                  );
                                } else {
                                  return Text(
                                      "              ${data[index]["service"][i]["name"]}",
                                      style: Contants().h3white());
                                }
                              },
                              itemCount: data[index]["service"].length,
                            ),
                            Row(
                              children: [
                                data[index]["user"]["phone"].isEmpty
                                    ? const Text("")
                                    : Text(
                                        "เบอร์โทร 0${data[index]["user"]["phone"].toString().substring(3)}",
                                        style: Contants().h3white(),
                                      ),
                                const Text("")
                              ],
                            ),
                            idClick == data[index].id
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Contants.colorRed),
                                          ),
                                          onPressed: () {
                                            MyDialog(funcAction: fc)
                                                .superDialog(
                                                    context,
                                                    "ระบบจะทำการยกเลิกคิวนี้",
                                                    "ยกเลิกคิว");
                                          },
                                          child: Text(
                                            "ยกเลิก",
                                            style: Contants().h3white(),
                                          )),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        width: 150,
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Contants
                                                          .colorSpringGreen),
                                            ),
                                            onPressed: () {
                                              finishQueue(
                                                      data[index]["user"]["id"])
                                                  .then((value) {
                                                setState(() {
                                                  idClick = "";
                                                });
                                                return MyDialog().normalDialog(
                                                    context, "เสร็จสิ้น");
                                              });
                                            },
                                            child: Text(
                                              'เสร็จสิ้น',
                                              style: Contants().h2OxfordBlue(),
                                            )),
                                      )
                                    ],
                                  )
                                : const SizedBox()
                          ],
                        ),
                      )),
                );
              },
            );
          } else {
            return Center(
                child: Text(
              "ไม่มีคิวในวันนี้",
              style: Contants().h3white(),
            ));
          }
        });
  }

  void fc() {
    Navigator.pop(context);
    cancelQueue().then((value) {
      setState(() {
        idClick = "";
      });
      return MyDialog().normalDialog(context, "ยกเลิกคิวเรียบร้อย");
    });
  }

  Future<Null> cancelQueue() async {
    await FirebaseFirestore.instance
        .collection('Queue')
        .doc(idClick)
        .update({"status": "cancel"});
  }

  Future<Null> finishQueue(String uid) async {
    await FirebaseFirestore.instance
        .collection("user")
        .doc(uid)
        .get()
        .then((value) async {
      if (value.exists) {
        await FirebaseFirestore.instance.collection("user").doc(uid).update({
          "score": FieldValue.increment(10),
        });
      } else {
        await FirebaseFirestore.instance
            .collection("user")
            .doc(uid)
            .set({"score": 10});
      }
    });
    await FirebaseFirestore.instance
        .collection('Queue')
        .doc(idClick)
        .update({"status": "succeed"});
  }

  Future _selectedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2022,1,1),
        lastDate: DateTime.now().add(const Duration(days: 10)));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      // checkdayclose();
    }
  }

 
}
