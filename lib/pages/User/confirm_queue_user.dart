import 'package:barber/pages/index.dart';
import 'package:barber/utils/dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:barber/data/servicemodel.dart';

class ConfirmQueueUser extends StatefulWidget {
  DateTime datetime;
  String nameUser, nameBarber;
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
      hairdresserID: hairdresserID);
}

class _ConfirmQueueUserState extends State<ConfirmQueueUser> {
  DateTime datetime;
  String nameUser, nameBarber;
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
      required this.hairdresserID});

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
    double fontSize = 17;
    return Scaffold(
        appBar: AppBar(),
        body: Column(children: [
          const SizedBox(
            height: 20,
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: size * 0.16),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Text(
                      "วันที่ ${datetime.day.toString().padLeft(2, "0")} / ${datetime.month.toString().padLeft(2, "0")} / ${datetime.year}",
                      style: TextStyle(fontSize: fontSize),
                    ),
                    Text(
                      "ระยะเวลา $time ชม.    ${datetime.hour.toString().padLeft(2, "0")}.${datetime.minute.toString().padLeft(2, "0")} -  ${datetime.add(Duration(minutes: timeint)).hour.toString().padLeft(2, "0")}.${datetime.add(Duration(minutes: timeint)).minute.toString().padLeft(2, "0")}",
                      style: TextStyle(fontSize: fontSize),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      nameUser,
                      style: TextStyle(fontSize: fontSize),
                    ),
                    Text(
                      "ร้าน " + nameBarber,
                      style: TextStyle(fontSize: fontSize),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: size * 0.16),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        servicemodel[index].name,
                        style: TextStyle(fontSize: fontSize),
                      ),
                      Text(
                        servicemodel[index].price.toInt().toString(),
                        style: TextStyle(fontSize: fontSize),
                      )
                    ],
                  ),
                  itemCount: servicemodel.length,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: size * 0.16),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(""),
                      Text(
                        "$price",
                        style: TextStyle(fontSize: fontSize),
                      )
                    ]),
              ),
            ],
          )
        ]),
        bottomNavigationBar: BottomAppBar(
          child: SizedBox(
              height: 100,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: size * 0.10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(""),
                          Text(
                            "ยอมรวม $price",
                            style: const TextStyle(fontSize: 33),
                          )
                        ]),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: const Color.fromARGB(255, 67, 165, 58),
                          ),
                          onPressed: () {
                            // insertQueueOnDatabase();
                          },
                          child: const Text("ยืนยัน"),
                        ),
                        width: size * 0.5,
                        height: 55,
                      ),
                      SizedBox(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("ยกเลิก")),
                        width: size * 0.5,
                        height: 55,
                      ),
                    ],
                  ),
                ],
              )),
        ));
  }

  Future<void> checkQueueInDatabase() async {
    // print(listdateStart);
    var data = await FirebaseFirestore.instance
        .collection('Queue')
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
                // caninsert = false;
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
    print("is an items");
    print(items);

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
