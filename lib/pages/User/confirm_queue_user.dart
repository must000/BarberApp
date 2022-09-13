import 'package:barber/Constant/contants.dart';
import 'package:barber/pages/index.dart';
import 'package:barber/utils/dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:barber/data/servicemodel.dart';

class ConfirmQueueUser extends StatefulWidget {
  DateTime datetime;
  String nameUser, nameBarber,nameHairresser;
  String emailBarber, idUser, hairdresserID;
  List<ServiceModel> servicemodel;

  ConfirmQueueUser({
    Key? key,
    required this.datetime,
    required this.nameUser,
    required this.nameBarber,
    required this.emailBarber,
    required this.idUser,
    required this.servicemodel,
    required this.hairdresserID,
    required this.nameHairresser,
  }) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<ConfirmQueueUser> createState() => _ConfirmQueueUserState(
      datetime: datetime,
      emailBarber: emailBarber,
      idUser: idUser,
      nameBarber: nameBarber,
      nameUser: nameUser,
      servicemodel: servicemodel,
      hairdresserID: hairdresserID,nameHairresser:nameHairresser);
}

class _ConfirmQueueUserState extends State<ConfirmQueueUser> {
  DateTime datetime;
  String nameUser, nameBarber,nameHairresser;
  String emailBarber, idUser, hairdresserID;
  List<ServiceModel> servicemodel;

  List<Object> listdateStart = [];
  List<Object> listdateend = [];
  _ConfirmQueueUserState(
      {required this.datetime,
      required this.nameUser,
      required this.nameBarber,
      required this.emailBarber,
      required this.idUser,
      required this.servicemodel,
      required this.hairdresserID,required this.nameHairresser});

  // เวลาที่ใช้ แบบตัดเป็น ชม.
  String time = "";
  //เวลาที่ใช้รวมนาที รวมราคาที่ยูเซอร์ต้องจ่าย
  int timeint = 0, price = 0;
  bool caninsert = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setdata();
    checkQueueInDatabase();
    calculatorTimeandprice();
  }

  setdata() {
    for (var i = 0; i < servicemodel.length; i++) {
      timeint += servicemodel[i].time.toInt();
    }
    double count = timeint / 30;
    for (var i = 0; i < count; i++) {
      listdateStart.add(datetime.add(Duration(minutes: i * 30)).toString());
      if (i != 0) {
        listdateend.add(datetime.add(Duration(minutes: i * 30)).toString());
      }
    }
  }

  calculatorTimeandprice() {
    String timehours;
    int _time = 0, _price = 0;
    for (var i = 0; i < servicemodel.length; i++) {
      _time += servicemodel[i].time.toInt();
    }
    int hour = _time ~/ 60;
    int minutes = _time % 60;
    timehours = '${hour.toString()}:${minutes.toString().padLeft(2, "0")}';
    for (var i = 0; i < servicemodel.length; i++) {
      _price += servicemodel[i].price.toInt();
    }
    setState(() {
      time = timehours;
      timeint = _time;
      price = _price;
    });
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Contants.myBackgroundColor,
        appBar: AppBar(
          backgroundColor: Contants.myBackgroundColordark,
          title: const Text("สรุปรายการ"),
        ),
        body: Padding(
          padding:  EdgeInsets.symmetric(horizontal:size*0.07),
          child: ListView(shrinkWrap: true, children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  "ชื่อ : ",
                  style: Contants().h2white(),
                ),
                Text(
                  nameUser,
                  style: Contants().h2SpringGreen(),
                )
              ],
            ),
            line(),
            Text(
              "ร้าน : $nameBarber",
              style: Contants().h2white(),
            ),
            Text(
              "ช่างทำผม : $nameHairresser",
              style: Contants().h2white(),
            ),
            line(),
            Text(
              "เวลาการใช้บริการ",
              style: Contants().h2white(),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                "วันที่   ${datetime.day.toString().padLeft(2, "0")} / ${datetime.month.toString().padLeft(2, "0")} / ${datetime.year}",
                style: Contants().h3white(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                "เวลา   ${datetime.hour.toString().padLeft(2, "0")}.${datetime.minute.toString().padLeft(2, "0")} -  ${datetime.add(Duration(minutes: timeint)).hour.toString().padLeft(2, "0")}.${datetime.add(Duration(minutes: timeint)).minute.toString().padLeft(2, "0")}",
                style: Contants().h3white(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                "ใช้เวลาโดยประมาณ   $time ชม.",
                style: Contants().h3white(),
              ),
            ),
            line(),
            Text(
              "บริการ",
              style: Contants().h2white(),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: size * 0.05),
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) => Card(
                  color: Contants.colorWhite,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          servicemodel[index].name,
                          style: Contants().h2OxfordBlue(),
                        ),
                        Text(
                          "${servicemodel[index].price.toInt().toString()} บาท",
                          style: Contants().h2OxfordBlue(),
                        )
                      ],
                    ),
                  ),
                ),
                itemCount: servicemodel.length,
              ),
            ),
            line(),
            Container(
              margin: EdgeInsets.symmetric(horizontal: size * 0.05),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(""),
                    Text(
                      "รวม : $price บาท",
                      style: Contants().h2white(),
                    )
                  ]),
            ),
            line()
          ]),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
              color: Contants.colorOxfordBlue,
              height: 100,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "ยกเลิก",
                            style: Contants().h2white(),
                          )),
                      width: size * 0.38,
                      height: 55,
                    ),
                    SizedBox(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Contants.colorSpringGreen,
                        ),
                        onPressed: () {
                          
                          if (caninsert) {
                            insertQueueOnDatabase();
                          } else {
                            MyDialog(funcAction: f3).hardDialog(
                                context,
                                "อาจมีผู้ใช้ท่านอื่น บันทึกคิวเข้าสู่ระบบเมื่อไม่นานมานี้ ขออภัยในความไม่สะดวก",
                                "ไม่สามารถบันทึกคิวได้");
                          }
                        },
                        child: Text("ยืนยัน", style: Contants().h2OxfordBlue()),
                      ),
                      width: size * 0.38,
                      height: 55,
                    ),
                  ],
                ),
              )),
        ));
  }

  Widget line() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Divider(
        thickness: 2,
        color: Colors.white,
      ),
    );
  }

  Future<void> checkQueueInDatabase() async {

    var data = await FirebaseFirestore.instance
        .collection('Queue')
         .where("hairdresserID",isEqualTo: hairdresserID)
        .where("status", isEqualTo: "on")
        .orderBy("time.timestart")
        .startAt([(DateFormat('yyyy-MM-dd').format(datetime))])
        .endAt([
          (DateFormat('yyyy-MM-dd')
              .format(datetime.add(const Duration(days: 1))))
        ])
        .snapshots()
        .listen((event) {
          if (event.docs.isNotEmpty) {
            int o = 0;
            while (o < event.docs.length && caninsert) {
              if (listdateStart.contains(event.docs[o]["time"]["timestart"]) ||
                  listdateend.contains(event.docs[o]["time"]["timeend"])) {
                caninsert = false;
                print("มีคิว");
              } else {
                print("ไม่มี");
              }
              o++;
            }
          }
        });
  }

  void f1() {
    Navigator.pop(context);
    Navigator.pop(context);
  }

  void f2() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => IndexPage(),
        ));
  }

  void f3() {
    Navigator.pop(context);
  }

  Future<void> insertQueueOnDatabase() async {
    List<ServiceModel> items = [];
    for (var i = 0; i < servicemodel.length; i++) {
      items.add(ServiceModel(
          id: servicemodel[i].id,
          name: servicemodel[i].name,
          detail: servicemodel[i].detail,
          time: servicemodel[i].time,
          price: servicemodel[i].price));
    }
    await FirebaseFirestore.instance.collection('Queue').add({
      "status": "on",
      "barberEmail": emailBarber,
      "hairdresserID": hairdresserID,
      "UserID": idUser,
      "time": {
        "timestart": datetime.toString(),
        "timeend": datetime.add(Duration(minutes: timeint)).toString(),
      },
      "service": items.map<Map>((e) => e.toMap()).toList()
    }).then((value) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return IndexPage();
      }), (route) => false);
    });
  }
}
