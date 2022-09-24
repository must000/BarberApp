import 'package:barber/Constant/contants.dart';
import 'package:barber/pages/Hairdresser/queue_setting_hairdresser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  DateTime selectedDate = DateTime.now();
  final Uri _url = Uri.parse('https://flutter.dev');
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
                        style: Contants().h3white(),
                      ),
                      TextButton(
                          onPressed: () {
                            _launchUrl();
                          },
                          child: Text(
                            "เข้าสู่หน้าผู้จัดการร้าน",
                            style: TextStyle(color: Contants.colorRed),
                          ))
                    ],
                  ),
                )
              : Column(
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
                                        .subtract(Duration(days: 1));
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
                    buildQueue(),
                    // ElevatedButton(
                    //     onPressed: () {
                    //       print(
                    //           (DateFormat('yyyy-MM-dd').format(selectedDate)));
                    //       print((DateFormat('yyyy-MM-dd').format(
                    //           selectedDate.add(const Duration(days: 1)))));
                    //           print(hairdresserID);
                    //           print(barberState);
                    //     },
                    //     child: Text("dwqqeqeq"))
                  ],
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
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Card(
                      color: Contants.colorGreySilver,
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    "ชื่อลูกค้า : ${data[index]["user"]["name"]}"),
                                Text(
                                    "เวลา ${DateTime.parse(data[index]["time"]["timestart"]).hour.toString().padLeft(2, "0")}.${DateTime.parse(data[index]["time"]["timestart"]).minute.toString().padLeft(2, "0")} - ${DateTime.parse(data[index]["time"]["timeend"]).hour.toString().padLeft(2, "0")}.${DateTime.parse(data[index]["time"]["timeend"]).minute.toString().padLeft(2, "0")}"),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                    "0${data[index]["user"]["phone"].toString().substring(3)}"),
                                const Text("")
                              ],
                            ),
                            Row(
                              children: const [Text("รายการ"), Text("")],
                            ),
                            ListView.builder(
                               shrinkWrap: true,
                              itemBuilder: (context, i) => Row(
                                children:[
                                  Text(data[index]["service"][i]["name"])
                                ],
                              ),
                              itemCount: data[index]["service"].length,
                            )
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

  Future _selectedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 5)));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      // checkdayclose();
    }
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }
}
