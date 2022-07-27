import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:barber/data/barbermodel.dart';
import 'package:barber/data/queuemodel.dart';
import 'package:barber/data/servicemodel.dart';
import 'package:barber/pages/confirm_queue_user.dart';
import 'package:barber/utils/dialog.dart';

class SelectDateTimeUser extends StatefulWidget {
  List<ServiceModel> servicemodel;
  Map<String, dynamic> dayopen;
  String timeopen;
  String timeclose;
  String email;
  String nameUser, nameBarber;
  SelectDateTimeUser({
    Key? key,
    required this.servicemodel,
    required this.dayopen,
    required this.timeopen,
    required this.timeclose,
    required this.email,
    required this.nameUser,
    required this.nameBarber,
  }) : super(key: key);

  @override
  State<SelectDateTimeUser> createState() => _SelectDateTimeUserState(
      servicemodel: servicemodel,
      dayopen: dayopen,
      timeclose: timeclose,
      timeopen: timeopen,
      email: email,
      nameUser: nameUser,
      nameBarber: nameBarber);
}

class _SelectDateTimeUserState extends State<SelectDateTimeUser> {
  List<ServiceModel> servicemodel;
  Map<String, dynamic> dayopen;
  String timeopen;
  String timeclose;
  String email;
  String nameUser, nameBarber;

  _SelectDateTimeUserState(
      {required this.servicemodel,
      required this.dayopen,
      required this.timeopen,
      required this.timeclose,
      required this.email,
      required this.nameUser,
      required this.nameBarber});
  DateTime selectedDate = DateTime.now();
  String? uid;
  bool load = true;
  int time = 0, price = 0;
  String? o;
  bool open = false;
  DateTime? timeOpen;
  DateTime? dateResult;
  int? timediff;
  @override
  void initState() {
    super.initState();
    findEmail();
    getDayClosed().then(
      (value) {
        checkdayclose();
      },
    );
    totalTimeAndPrice();
  }

  List<DateTime>? dateData;
  List<String>? idDate;
  List<QueueModel>? queue;
  List<DateTime>? listDayClosed;
  Future<Null> getDayClosed() async {
    var queryS = await FirebaseFirestore.instance
        .collection("Barber")
        .doc(email)
        .collection("dayclose")
        .get();
    var alldata2 = queryS.docs.map((e) => e.data()).toList();
    List<DateTime> dataEx2 = [];
    print(alldata2);
    if (alldata2.isNotEmpty) {
      for (int n = 0; n < alldata2.length; n++) {
        dataEx2.add((alldata2[n]["dayclosed"] as Timestamp).toDate());
      }
    } else {
      print("ไม่มีค่า 2");
    }

    setState(() {
      listDayClosed = dataEx2;
    });
  }

  List<Map<DateTime, dynamic>>? queuemodel3 = [];
  List<Map<DateTime, dynamic>>? queuemodelInsert = [];

  totalTimeAndPrice() {
    DateTime tOpen = DateFormat('yyyyy-MM-dd HH:mm:ss').parse(
        '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} ${timeopen.replaceAll(' ', '')}:00');
    DateTime tClose = DateFormat('yyyyy-MM-dd HH:mm:ss').parse(
        '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} ${timeclose.replaceAll(' ', '')}:00');

    Duration diff = tClose.difference(tOpen);
    timeOpen = DateFormat('yyyyy-MM-dd HH:mm:ss').parse(
        '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} ${timeopen.replaceAll(' ', '')}:00');
    setState(() {
      timediff = diff.inHours;
      load = false;
    });
  }

  checkdayclose() {
    // print(dayopen);
    //get ชื่อวัน จากวันที่เลือก
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
        dateResult = DateFormat('yyyyy-MM-dd HH:mm:ss').parse(
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
        dateResult = DateFormat('yyyyy-MM-dd HH:mm:ss').parse(
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
    double size = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(),
      body: load == true
          ? Center(
              child:
                  LoadingAnimationWidget.inkDrop(color: Colors.black, size: 50))
          : SingleChildScrollView(
              child: Column(
                children: [
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
                      ? SizedBox(
                          width: size * 0.6,
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) => ElevatedButton(
                              onPressed: () {
                                checkReserve(dateResult!
                                    .add(Duration(minutes: index * 30)));
                              },
                              child: Text(
                                "${dateResult!.add(Duration(minutes: index * 30)).hour.toString().padLeft(2, "0")}:${dateResult!.add(Duration(minutes: index * 30)).minute.toString().padLeft(2, "0")} - ${dateResult!.add(Duration(minutes: (index + 1) * 30)).hour.toString().padLeft(2, "0")}:${dateResult!.add(Duration(minutes: (index + 1) * 30)).minute.toString().padLeft(2, "0")}",
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                            itemCount: timediff! * 2,
                          ),
                        )
                      : const Text("ร้านปิดทำการในวันนี้"),
                ],
              ),
            ),
    );
  }

  checkReserve(DateTime selectime) {
    if (selectime.isBefore(DateTime.now().add(Duration(hours: 2)))) {
      // เวลาที่จอง ไม่เกิน 2 ชม. ต้องจองล่วงหน้า อย่างน้อย 2 ชม.
      MyDialog().normalDialog(context, "ต้องทำการจองล่วงหน้าอย่างน้อย 2 ชม.");
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConfirmQueueUser(
                datetime: selectime,
                nameUser: nameUser,
                nameBarber: nameBarber,
                emailBarber: email,
                idUser: uid!,
                servicemodel: servicemodel),
          ));
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
    }
  }

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
      }).then(((value) {}));
      debugPrint("สำเร็จ");
    });
  }
}
