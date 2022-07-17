import 'package:barber/data/queuemodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
  ConfirmReserveUser({
    Key? key,
    required this.servicemodel,
    required this.dayopen,
    required this.timeopen,
    required this.timeclose,
  }) : super(key: key);

  @override
  State<ConfirmReserveUser> createState() => _ConfirmReserveUserState(
      servicemodel: servicemodel,
      dayopen: dayopen,
      timeclose: timeclose,
      timeopen: timeopen);
}

class _ConfirmReserveUserState extends State<ConfirmReserveUser> {
  List<ServiceModel> servicemodel;
  Map<String, dynamic> dayopen;
  String timeopen;
  String timeclose;

  _ConfirmReserveUserState(
      {required this.servicemodel,
      required this.dayopen,
      required this.timeopen,
      required this.timeclose});
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
    findEmail().then((value) {});
    totalTimeAndPrice();
    checkdayclose();
    setQueue();
  }

  List<Map<DateTime, dynamic>>? queuemodel3 = [
  ];

  List<QueueModel> datatest = [
    QueueModel(
        datetime: DateTime.parse('2022-07-18 14:30:00'),
        idUser: "dasdqwdadwq",
        emailBarber: "tt@gmail.com",
        idService: "diqyqdksjdw",
        nameService: "ตัดผมชา่ย",
        detailService: "dddddd"),
    QueueModel(
        datetime: DateTime.parse('2022-07-18 16:30:00'),
        idUser: "dasdqwdadwq",
        emailBarber: "tt@gmail.com",
        idService: "diqyqdksjdw",
        nameService: "ตัดผมชา่ย",
        detailService: "dddddd"),
    QueueModel(
        datetime: DateTime.parse('2022-07-19 14:30:00'),
        idUser: "dasdqwdadwq",
        emailBarber: "tt@gmail.com",
        idService: "diqyqdksjdw",
        nameService: "ตัดผมชา่ย",
        detailService: "dddddd"),
           QueueModel(
        datetime: DateTime.parse('2022-07-19 15:30:00'),
        idUser: "dasdqwdadwq",
        emailBarber: "tt@gmail.com",
        idService: "diqyqdksjdw",
        nameService: "ตัดผมชา่ย",
        detailService: "dddddd"),
           QueueModel(
        datetime: DateTime.parse('2022-07-19 16:00:00'),
        idUser: "dasdqwdadwq",
        emailBarber: "tt@gmail.com",
        idService: "diqyqdksjdw",
        nameService: "ตัดผมชา่ย",
        detailService: "dddddd")
  ];

  setQueue() {
    for (var i = 0; i < timediff! * 2; i++) {
      queuemodel3!.add({xxx!.add(Duration(minutes: i * 30)): null});
      for (var n = 0; n < datatest.length; n++) {
        if (xxx!.add(Duration(minutes: i * 30)) == datatest[n].datetime) {
          // queuemodel3!.add({timeOpen!.add(Duration(minutes: i * 30)): "มีค่า"});
          queuemodel3![i] = {xxx!.add(Duration(minutes: i * 30)): "มีค่า"};
        }
      }
    }
    print(queuemodel3![13]);
    print(xxx);
    setState(() {});
  }

  totalTimeAndPrice() {
    int _time = 0, _price = 0;
    for (var i = 0; i < servicemodel.length; i++) {
      _time += servicemodel[i].time.toInt();
      _price += servicemodel[i].price.toInt();
    }

    DateTime t1 = DateFormat('yyyyy-MM-dd HH:mm:ss').parse(
        '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} ${timeopen.replaceAll(' ', '')}:00');
    DateTime t2 = DateFormat('yyyyy-MM-dd HH:mm:ss').parse(
        '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} ${timeclose.replaceAll(' ', '')}:00');

    Duration diff = t2.difference(t1);
    timeOpen = DateFormat('yyyyy-MM-dd HH:mm:ss').parse(
        '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} ${timeopen.replaceAll(' ', '')}:00');
    setState(() {
      time = _time;
      price = _price;
      timediff = diff.inHours;
    });
  }

  checkdayclose() {
    print(dayopen);
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
    print("$o $selectedDate");
    if (dayopen[o] == true) {
      setState(() {
        xxx = DateFormat('yyyyy-MM-dd HH:mm:ss').parse(
            '${selectedDate.year}-${selectedDate.month}-${selectedDate.day} ${timeopen.replaceAll(' ', '')}:00');
        open = true;
      });
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
              load = false;
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
      appBar: AppBar(),
      body: load == true
          ? Center(
              child:
                  LoadingAnimationWidget.inkDrop(color: Colors.black, size: 50))
          : SingleChildScrollView(
              child: Column(
                children: [
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
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) => Row(
                            children: [
                              Checkbox(
                                  value: true,
                                  onChanged: (newValue) {
                                    print(
                                        "${xxx!.add(Duration(minutes: index * 30))}");
                                  }),
                              // Text(
                              //     "${timeOpen!.add(Duration(minutes: index * 30)).hour.toString().padLeft(2, "0")} : ${timeOpen!.add(Duration(minutes: index * 30)).minute.toString().padLeft(2, "0")}")
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
                      : Container(
                          child: const Text("ร้านปิดทำการ "),
                        ),
                ],
              ),
            ),
    );
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
}
