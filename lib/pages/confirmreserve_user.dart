import 'package:barber/data/queuemodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:barber/data/barbermodel.dart';
import 'package:barber/data/servicemodel.dart';
import 'package:barber/utils/dialog.dart';

class ConfirmReserveUser extends StatefulWidget {
  List<ServiceModel> servicemodel;
  Map<String, dynamic> dayopen;
  String timeopen;
  String timeclose;
  String email;
  ConfirmReserveUser({
    Key? key,
    required this.servicemodel,
    required this.dayopen,
    required this.timeopen,
    required this.timeclose,
    required this.email,
  }) : super(key: key);

  @override
  State<ConfirmReserveUser> createState() => _ConfirmReserveUserState(
      servicemodel: servicemodel,
      dayopen: dayopen,
      timeclose: timeclose,
      timeopen: timeopen,
      email: email);
}

class _ConfirmReserveUserState extends State<ConfirmReserveUser> {
  List<ServiceModel> servicemodel;
  Map<String, dynamic> dayopen;
  String timeopen;
  String timeclose;
  String email;
  _ConfirmReserveUserState(
      {required this.servicemodel,
      required this.dayopen,
      required this.timeopen,
      required this.timeclose,
      required this.email});
  DateTime selectedDate = DateTime.now();
  String? uid;
  bool load = true;
  int time = 0, price = 0;
  String? o;
  bool open = false;
  DateTime? timeOpen;
  DateTime? xxx;
  int? timediff;
  @override
  void initState() {
    super.initState();
    findEmail();
    getQueue().then(
      (value) {
        checkdayclose();
        setQueue();
      },
    );
    totalTimeAndPrice();
  }

  List<DateTime>? dateData;
  List<String>? idDate;
  List<QueueModel>? queue;
  List<DateTime>? listDayClosed;
  var alldata, alldata2;
  Future<Null> getQueue() async {
    print("1");
    var querySnapshot = await FirebaseFirestore.instance
        .collection("reservation")
        .doc(email)
        .collection("queue")
        .get();
    alldata = querySnapshot.docs.map((e) => e.data()).toList();
    List<QueueModel> dataEx = [];
    if (alldata.isNotEmpty) {
      print("$alldata qqqqq");
      for (int n = 0; n < alldata.length; n++) {
        dataEx.add(QueueModel(
          datetime: (alldata[n]["datetime"] as Timestamp).toDate(),
          idUser: alldata[n]["idUser"],
          emailBarber: alldata[n]["emailBarber"],
        ));
      }
    } else {
      // dataEx.add(QueueModel(datetime: DateTime.now(), idUser: "dawq", emailBarber: email));
      print("ไม่มีค่า");
    }
    var queryS = await FirebaseFirestore.instance
        .collection("Barber")
        .doc(email)
        .collection("dayclose")
        .get();
    alldata2 = queryS.docs.map((e) => e.data()).toList();
    List<DateTime> dataEx2 = [];
    if (dataEx2.isNotEmpty) {
      for (int n = 0; n < alldata2.length; n++) {
        // print((alldata2[n]["dayclosed"] as Timestamp).toDate());

        dataEx2.add((alldata2[n]["dayclosed"] as Timestamp).toDate());
      }
    } else {
      // dataEx2.add(    timeOpen = DateFormat('yyyyy-MM-dd HH:mm:ss').parse(
      //   '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} 00:00:00'));
      print("ไม่มีค่า 2");
    }

    setState(() {
      queue = dataEx;
      listDayClosed = dataEx2;
    });
  }

  List<Map<DateTime, dynamic>>? queuemodel3 = [];
  List<Map<DateTime, dynamic>>? queuemodelInsert = [];

  setQueue() {
    for (var i = 0; i < timediff! * 2; i++) {
      queuemodel3!.add({xxx!.add(Duration(minutes: i * 30)): null});
      queuemodelInsert!.add({xxx!.add(Duration(minutes: i * 30)): null});
      for (var n = 0; n < queue!.length; n++) {
        if (xxx!.add(Duration(minutes: i * 30)) == queue![n].datetime) {
          queuemodel3![i] = {xxx!.add(Duration(minutes: i * 30)): "มีค่า"};
        }
      }
    }
    setState(() {
      load = false;
    });
  }

  totalTimeAndPrice() {
    int _time = 0, _price = 0;
    for (var i = 0; i < servicemodel.length; i++) {
      _time += servicemodel[i].time.toInt();
      _price += servicemodel[i].price.toInt();
    }

    DateTime tOpen = DateFormat('yyyyy-MM-dd HH:mm:ss').parse(
        '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} ${timeopen.replaceAll(' ', '')}:00');
    DateTime tClose = DateFormat('yyyyy-MM-dd HH:mm:ss').parse(
        '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} ${timeclose.replaceAll(' ', '')}:00');

    Duration diff = tClose.difference(tOpen);
    timeOpen = DateFormat('yyyyy-MM-dd HH:mm:ss').parse(
        '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} ${timeopen.replaceAll(' ', '')}:00');
    setState(() {
      time = _time;
      price = _price;
      timediff = diff.inHours;
    });
  }

  checkdayclose() {
    // print(dayopen);
    String x = DateFormat('EEEE').format(selectedDate);

    if (x == "Sunday") {
      o = "su";
    } else if (x == "Monday") {
      o = "mo";
    } else if (x == "Tuesday") {
      o = "tu";
    } else if (x == "Wednesday") {
      o = "we";
    } else if (x == "Thursday") {
      o = "th";
    } else if (x == "Friday") {
      o = "fr";
    } else if (x == "Saturday") {
      o = "sa";
    }

    int p = 0;
    if (dayopen[o] == true) {
      setState(() {
        xxx = DateFormat('yyyyy-MM-dd HH:mm:ss').parse(
            '${selectedDate.year}-${selectedDate.month}-${selectedDate.day} ${timeopen.replaceAll(' ', '')}:00');
        open = true;
      });
      if (listDayClosed!.isNotEmpty) {
        do {
          if (listDayClosed![p].day == selectedDate.day &&
              listDayClosed![p].month == selectedDate.month) {
            print("หยุด");
            p = listDayClosed!.length + 1;
            setState(() {
              open = false;
            });
          } else {
            print("ไม่หยุด");
          }
          p++;
        } while (p < listDayClosed!.length);
      } else {
        print("ไม่มีข้อมูลวันหยุด");
      }
    } else {
      setState(() {
        xxx = DateFormat('yyyyy-MM-dd HH:mm:ss').parse(
            '${selectedDate.year}-${selectedDate.month}-${selectedDate.day} ${timeopen.replaceAll(' ', '')}:00');
        open = false;
      });
    }
  }

  Future<Null> findEmail() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen(
        (event) async {
          if (event == null) {
            MyDialog().checkLoginDialog(context);
          } else {
            setState(() {
              uid = event.uid;
            });
          }
        },
        onError: (e) {
          print("$e error");
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                checkReserve();
              },
              icon: const Icon(Icons.check))
        ],
      ),
      body: load == true
          ? Center(
              child:
                  LoadingAnimationWidget.inkDrop(color: Colors.black, size: 50))
          : SingleChildScrollView(
              child: Column(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        print(listDayClosed);
                      },
                      child: Text("เทสฟังชั่น")),
                  Center(child: Text("เวลาทั้งหมด $time นาที")),
                  Center(child: Text("รวม $price บาท")),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: 30,
                        child: Text(
                            " ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"),
                        decoration: BoxDecoration(border: Border.all()),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _selectedDate(context);
                        },
                        child: const Text("เปลี่ยนวันที่ "),
                      )
                    ],
                  ),
                  open
                      ? ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) => Row(
                            children: [
                              Checkbox(
                                  activeColor: queuemodelInsert![index][xxx!.add(
                                              Duration(minutes: index * 30))] !=
                                          null
                                      ? Colors.green
                                      : Colors.red,
                                  value: queuemodel3![index][xxx!.add(Duration(
                                                  minutes: index * 30))] ==
                                              null &&
                                          queuemodelInsert![index][xxx!.add(
                                                  Duration(minutes: index * 30))] ==
                                              null
                                      ? false
                                      : true,
                                  onChanged: (newValue) {
                                    if (newValue!) {
                                      queuemodelInsert![index] = {
                                        xxx!.add(Duration(minutes: index * 30)):
                                            QueueModel(
                                          datetime: DateTime.parse(
                                              "${xxx!.add(Duration(minutes: index * 30)).year.toString()}-${xxx!.add(Duration(minutes: index * 30)).month.toString().padLeft(2, "0")}-${xxx!.add(Duration(minutes: index * 30)).day.toString().padLeft(2, "0")} ${xxx!.add(Duration(minutes: index * 30)).hour.toString().padLeft(2, "0")}:${xxx!.add(Duration(minutes: index * 30)).minute.toString().padLeft(2, "0")}:00"),
                                          idUser: uid!,
                                          emailBarber: email,
                                        )
                                      };
                                    } else {
                                      queuemodelInsert![index] = {
                                        xxx!.add(Duration(minutes: index * 30)):
                                            null
                                      };
                                    }
                                    setState(() {});
                                    // print(queuemodelInsert![index]);
                                  }),
                              queuemodel3![index][xxx!.add(
                                          Duration(minutes: index * 30))] ==
                                      null
                                  ? Text(
                                      "${xxx!.add(Duration(minutes: index * 30)).hour.toString().padLeft(2, "0")}-${xxx!.add(Duration(minutes: index * 30)).minute.toString().padLeft(2, "0")} คิวว่าง",
                                    )
                                  : const Text("คิวไม่ว่าง")
                            ],
                          ),
                          itemCount: timediff! * 2,
                        )
                      : const Text("ร้านปิดทำการ ในวันนี้"),
                  open
                      ? ElevatedButton(
                          onPressed: () {
                            checkReserve();
                          },
                          child: const Text("ยืนยัน"))
                      : const SizedBox()
                ],
              ),
            ),
    );
  }

  checkReserve() {
    double _time = time / 30;
    List<QueueModel>? queue = [];
    for (var n = 0; n < queuemodelInsert!.length; n++) {
      if (queuemodelInsert![n][xxx!.add(Duration(minutes: n * 30))] != null) {
        queue.add(queuemodelInsert![n][xxx!.add(Duration(minutes: n * 30))]);
      }
    }
    if (queue.length == _time.toInt()) {
      bool c = true;
      for (var i = 0; i < queue.length; i++) {
        // print(queue[i].datetime);
        if (queue[i]
            .datetime
            .isBefore(DateTime.now().add(Duration(hours: 2)))) {
          // เวลาที่จอง ไม่เกิน 2 ชม. ต้องจองล่วงหน้า อย่างน้อย 2 ชม.
          // MyDialog()
          //     .normalDialog(context, "ต้องทำการจองล่วงหน้าอย่างน้อย 2 ชม.");
          c = false;
        }
      }
      if (c) {
        //เรียบร้อยดี
        savedata(queue);
      } else {
        // เวลาที่จอง ไม่เกิน 2 ชม. ต้องจองล่วงหน้า อย่างน้อย 2 ชม.
        MyDialog().normalDialog(context, "ต้องทำการจองล่วงหน้าอย่างน้อย 2 ชม.");
      }
    } else {
      //เวลาที่เลือกไม่สอดคล้องกับบริการที่เลือก
      MyDialog()
          .normalDialog(context, "เวลาที่เลือกไม่สอดคล้องกับบริการที่เลือก");
      print("เวลาที่เลือกไม่สอดคล้องกับบริการที่เลือก");
    }
  }

  Future _selectedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 5)));
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      checkdayclose();
      setQueue();
    }
  }

  // Future<Null> insertData(List<QueueModel> listQueue) async {
  //   final data = FirebaseFirestore.instance.collection('Barber').doc(email).collection('queue').where("");
  //   final snapshot = await data.get();
  //   if (snapshot.exists) {
  //     Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
  //     // recommendController.text = data['shoprecommend'];
  //     // iii = data['shoprecommend'];
  //     if (data["countservice"] != null) {
  //       print("NotEmpty");
  //       setState(() {
  //         // x = data["countservice"];
  //       });
  //     } else {
  //       print('Empty');
  //     }
  //   }
  // }

  Future<Null> savedata(List<QueueModel> listQueue) async {
    listQueue.forEach((element) async {
      await FirebaseFirestore.instance
          .collection('reservation')
          .doc(email)
          .collection('queue')
          .add({
        "datetime": element.datetime,
        "emailBarber": element.emailBarber,
        "idUser": element.idUser
      }).then(((value) {
        
      }));
      debugPrint("สำเร็จ");
    });
  }
}
