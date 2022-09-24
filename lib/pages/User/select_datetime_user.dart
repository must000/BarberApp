import 'package:barber/Constant/contants.dart';
import 'package:barber/data/breaktimemodel.dart';
import 'package:barber/data/queuemodel2.dart';
import 'package:barber/pages/Authentication/register_phone_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:barber/data/queuemodel.dart';
import 'package:barber/data/servicemodel.dart';
import 'package:barber/pages/User/confirm_queue_user.dart';
import 'package:barber/utils/dialog.dart';

class SelectDateTimeUser extends StatefulWidget {
  List<ServiceModel> servicemodel;
  Map<String, dynamic> dayopen;
  String timeopen;
  String timeclose;
  String email;
  String nameUser, nameBarber, hairdresserID, nameHairresser;
   String  phonebarber, phoneHairresser;
  SelectDateTimeUser(
      {Key? key,
      required this.servicemodel,
      required this.dayopen,
      required this.timeopen,
      required this.timeclose,
      required this.email,
      required this.nameUser,
      required this.nameBarber,
      required this.hairdresserID,
      required this.nameHairresser ,required this.phoneHairresser,
      required this.phonebarber})
      : super(key: key);

  @override
  State<SelectDateTimeUser> createState() => _SelectDateTimeUserState(
      servicemodel: servicemodel,
      dayopen: dayopen,
      timeclose: timeclose,
      timeopen: timeopen,
      email: email,
      nameUser: nameUser,
      nameBarber: nameBarber,
      hairdresserID: hairdresserID,
      nameHairresser: nameHairresser,
      phoneHairresser: phoneHairresser,
      phonebarber: phonebarber);
}

class _SelectDateTimeUserState extends State<SelectDateTimeUser> {
  List<ServiceModel> servicemodel;
  Map<String, dynamic> dayopen;
  String timeopen;
  String timeclose;
  String email;
  String nameUser, nameBarber, hairdresserID, nameHairresser;
String  phonebarber, phoneHairresser;
  _SelectDateTimeUserState(
      {required this.servicemodel,
      required this.dayopen,
      required this.timeopen,
      required this.timeclose,
      required this.email,
      required this.nameUser,
      required this.nameBarber,
      required this.hairdresserID,
      required this.nameHairresser,
       required this.phoneHairresser,
      required this.phonebarber});
  DateTime selectedDate = DateTime.now();
  String? uid;
  bool load = true;
  double time = 0, price = 0;
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
    getBreakTime();
  }

  List<BreakTimeModel> breakTime = [];

  Future<Null> getBreakTime() async {
    var queryS = await FirebaseFirestore.instance
        .collection("Hairdresser")
        .doc(hairdresserID)
        .collection("breakTime")
        .get();
    var alldata2 = queryS.docs.map((e) => e.data()).toList();
    List<BreakTimeModel> dataEx2 = [];
    print(alldata2);
    if (alldata2.isNotEmpty) {
      for (int n = 0; n < alldata2.length; n++) {
        dataEx2.add(BreakTimeModel(
            day: alldata2[n]["break"].toString().substring(0, 2),
            time: alldata2[n]["break"].toString().substring(3)));
      }
    } else {
      print("ไม่มีค่า breakTime");
    }

    setState(() {
      breakTime = dataEx2;
    });
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
    // print(alldata2);
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
    for (var i = 0; i < servicemodel.length; i++) {
      time += servicemodel[i].time;
    }
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
      print("ดึงข้อมูล");
      getQueueWhareDate2();
    } else {
      setState(() {
        dateResult = DateFormat('yyyyy-MM-dd HH:mm:ss').parse(
            '${selectedDate.year}-${selectedDate.month}-${selectedDate.day} ${timeopen.replaceAll(' ', '')}:00');
        open = false;
      });
    }
  }

  List<QueueModel2> listQueue = [];

  Future getQueueWhareDate2() async {
    var datadate = await FirebaseFirestore.instance
        .collection('Queue')
        .where("hairdresser.id", isEqualTo: hairdresserID)
        .where("status", isEqualTo: "on")
        .orderBy("time.timestart")
        .startAt([(DateFormat('yyyy-MM-dd').format(selectedDate))]).endAt([
      (DateFormat('yyyy-MM-dd')
          .format(selectedDate.add(const Duration(days: 1))))
    ]).get();
    var alldata = datadate.docs.map((e) => e.data()).toList();
    if (alldata.isNotEmpty) {
      List<QueueModel2> list = [];
      if (alldata.isNotEmpty) {
        for (int i = 0; i < alldata.length; i++) {
          list.add(QueueModel2(
              timestart: DateTime.parse(alldata[i]["time"]['timestart']),
              timeend: DateTime.parse(alldata[i]["time"]['timeend'])));
        }
        setState(() {
          listQueue = list;
        });
      } else {
        print("ไม่มีข้อมูลคิว");
      }
    } else {
      print("ไม่มีค่า 2");
    }

    // .onError((e) => print("$e error"));
  }

  void fc() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RegisterPhoneUser(),
        ));
  }
String? phoneUser;
  Future<Null> findEmail() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen(
        (event) async {
          //เช็คว่าล็อคอินรึยัง
          if (event == null) {
            MyDialog().checkLoginDialog(context);
          } else {
            //เช็คว่ามีเบอร์ไหม
            if (event.phoneNumber!.isEmpty) {
              MyDialog(funcAction: fc).hardDialog(context,
                  "กรุณายืนยันเบอร์โทรศัพท์ของคุณ", "ยังไม่ได้ยืนยันเบอร์โทรศัพท์");
            } else {
              setState(() {
                phoneUser = event.phoneNumber;
                uid = event.uid;
              });
            }
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
      backgroundColor: Contants.myBackgroundColor,
      appBar: AppBar(
        backgroundColor: Contants.myBackgroundColordark,
      ),
      body: load == true
          ? Center(
              child:
                  LoadingAnimationWidget.inkDrop(color: Colors.black, size: 50))
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: 30,
                          child: Text(
                            " ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                            style: Contants().h3SpringGreen(),
                          ),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Contants.colorSpringGreen),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Contants.colorSpringGreen),
                            ),
                            onPressed: () {
                              _selectedDate(context);
                            },
                            child: Text(
                              "เปลี่ยนวันที่ ",
                              style: Contants().h3Red(),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  open
                      ? SizedBox(
                          width: size * 0.6,
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              String nameday = "";
                              String x =
                                  DateFormat('EEEE').format(selectedDate);
                              if (x == "Sunday") {
                                nameday = "su";
                              } else if (x == "Monday") {
                                nameday = "mo";
                              } else if (x == "Tuesday") {
                                nameday = "tu";
                              } else if (x == "Wednesday") {
                                nameday = "we";
                              } else if (x == "Thursday") {
                                nameday = "th";
                              } else if (x == "Friday") {
                                nameday = "fr";
                              } else if (x == "Saturday") {
                                nameday = "sa";
                              }
                              bool emptyQueue = true;
                              int o = 0;
                              while (o < listQueue.length && emptyQueue) {
                                if (dateResult!
                                        .add(Duration(minutes: index * 30)) ==
                                    listQueue[o].timestart) {
                                  emptyQueue = false;
                                }
                                if (dateResult!
                                        .add(Duration(minutes: index * 30))
                                        .isAfter(listQueue[o].timestart) &&
                                    dateResult!
                                        .add(Duration(minutes: index * 30))
                                        .isBefore(listQueue[o].timeend)) {
                                  emptyQueue = false;
                                }
                                o++;
                              }

                              return Container(
                                height: 55,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<
                                        Color>(breakTime.contains(BreakTimeModel(
                                            day: nameday,
                                            time:
                                                "${dateResult!.add(Duration(minutes: index * 30)).hour.toString().padLeft(2, "0")}.${dateResult!.add(Duration(minutes: index * 30)).minute.toString().padLeft(2, "0")}"))
                                        ? Contants.colorGreySilver
                                        : emptyQueue == false
                                            ? Contants.colorGreySilver
                                            : Contants.colorWhite),
                                  ),
                                  onPressed: breakTime.contains(BreakTimeModel(
                                          day: nameday,
                                          time:
                                              "${dateResult!.add(Duration(minutes: index * 30)).hour.toString().padLeft(2, "0")}.${dateResult!.add(Duration(minutes: index * 30)).minute.toString().padLeft(2, "0")}"))
                                      ? null
                                      : emptyQueue ==
                                              false //อันนี้ต้องเป็น false เป็น true เพื่อการทดลอง
                                          ? null
                                          : () {
                                              print("dwr");
                                              bool canReserved = true;
                                              double count = time / 30;
                                              int ko = 0;
                                              int jo = 1;
                                              while (
                                                  jo < count && canReserved) {
                                                if (breakTime.contains(
                                                    BreakTimeModel(
                                                        day: nameday,
                                                        time:
                                                            "${dateResult!.add(Duration(minutes: (index * 30) + (jo * 30))).hour.toString().padLeft(2, "0")}.${dateResult!.add(Duration(minutes: (index * 30) + (jo * 30))).minute.toString().padLeft(2, "0")}"))) {
                                                  canReserved = false;
                                                }
                                                jo++;
                                              }
                                              while (ko < listQueue.length &&
                                                  canReserved) {
                                                int y = 1;
                                                while (
                                                    y < count && canReserved) {
                                                  if (dateResult!.add(Duration(
                                                          minutes:
                                                              (index * 30) +
                                                                  (y * 30))) ==
                                                      listQueue[ko].timestart) {
                                                    print("1");
                                                    canReserved = false;
                                                  } else if (dateResult!
                                                      .add(Duration(
                                                          minutes:
                                                              (index * 30) +
                                                                  (y * 30)))
                                                      .isAfter(DateFormat(
                                                              'yyyyy-MM-dd HH:mm:ss')
                                                          .parse(
                                                              '${dateResult!.year}-${dateResult!.month}-${dateResult!.day} ${timeclose.replaceAll(' ', '')}:00'))) {
                                                    canReserved = false;
                                                    print("2");
                                                  } else if (dateResult!.add(
                                                          Duration(
                                                              minutes: (index *
                                                                      30) +
                                                                  (y * 30))) ==
                                                      DateFormat(
                                                              'yyyyy-MM-dd HH:mm:ss')
                                                          .parse(
                                                              '${dateResult!.year}-${dateResult!.month}-${dateResult!.day} ${timeclose.replaceAll(' ', '')}:00')) {
                                                    canReserved = false;
                                                    print("3");
                                                  }
                                                  y++;
                                                }
                                                ko++;
                                              }
                                              int xo = 1;
                                              while (
                                                  xo < count && canReserved) {
                                                if (dateResult!
                                                    .add(Duration(
                                                        minutes: (index * 30) +
                                                            (xo * 30)))
                                                    .isAfter(DateFormat(
                                                            'yyyyy-MM-dd HH:mm:ss')
                                                        .parse(
                                                            '${dateResult!.year}-${dateResult!.month}-${dateResult!.day} ${timeclose.replaceAll(' ', '')}:00'))) {
                                                  canReserved = false;
                                                  print("4");
                                                } else if (dateResult!.add(
                                                        Duration(
                                                            minutes: (index *
                                                                    30) +
                                                                (xo * 30))) ==
                                                    DateFormat(
                                                            'yyyyy-MM-dd HH:mm:ss')
                                                        .parse(
                                                            '${dateResult!.year}-${dateResult!.month}-${dateResult!.day} ${timeclose.replaceAll(' ', '')}:00')) {
                                                  canReserved = false;
                                                  print("5");
                                                }
                                                xo++;
                                              }
                                              canReserved
                                                  ? checkReserve(dateResult!
                                                      .add(Duration(
                                                          minutes: index * 30)))
                                                  : MyDialog(funcAction: fc1)
                                                      .hardDialog(
                                                          context,
                                                          "เนื่องจากเวลาที่ต้องการรับบริการของท่าน เกินเวลาที่ช่างทำผมคนนี้ว่าง",
                                                          "ไม่สามารถจองได้");
                                            },
                                  child: Text(
                                    "${dateResult!.add(Duration(minutes: index * 30)).hour.toString().padLeft(2, "0")}:${dateResult!.add(Duration(minutes: index * 30)).minute.toString().padLeft(2, "0")} - ${dateResult!.add(Duration(minutes: (index + 1) * 30)).hour.toString().padLeft(2, "0")}:${dateResult!.add(Duration(minutes: (index + 1) * 30)).minute.toString().padLeft(2, "0")}",
                                    style: Contants().h1OxfordBlue(),
                                  ),
                                ),
                              );
                            },
                            itemCount: timediff! * 2,
                          ),
                        )
                      : Text(
                          "ร้านปิดทำการในวันนี้",
                          style: Contants().h2white(),
                        ),
                ],
              ),
            ),
    );
  }

  void fc1() {
    Navigator.pop(context);
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
              servicemodel: servicemodel,
              hairdresserID: hairdresserID,
              nameHairresser: nameHairresser, phoneHairresser: phoneHairresser, phoneUser: phoneUser!, phonebarber: phonebarber,
            ),
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
}
