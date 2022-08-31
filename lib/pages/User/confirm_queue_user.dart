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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    calculatorTimeandprice();
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
                            // insertQueue();
                            // checkQueueInDatabase2();
                            insertQueueOnDatabase();
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
    DateTime timee = DateFormat('yyyyy-MM-dd HH:mm:ss')
        .parse('${datetime.year}-${datetime.month}-${datetime.day} 00:00:00');
    var data = await FirebaseFirestore.instance
        .collection('Barber')
        .doc(emailBarber)
        .collection('queue')
        .doc("$timee")
        .collection("time")
        .get();
    var alldata = data.docs.map((e) => e.data()).toList();
    if (alldata.isNotEmpty) {
      for (int n = 0; n < alldata.length; n++) {
        // print("$n ${alldata[n]}");
        // print((alldata[n]["timestart"] as Timestamp).toDate());
        if ((alldata[n]["timestart"] as Timestamp).toDate() == datetime) {
          print("คิวไม่ว่าง เวลาตรงกัน");
        } else {
          for (var i = 0; i < timeint / 30; i++) {
            if ((alldata[n]["timestart"] as Timestamp).toDate() ==
                datetime.add(Duration(minutes: i * 30))) {
              return print('คิวไม่ว่่าง มีเวลาที่อยู่ในคิว');
            } else if ((alldata[n]["timeend"] as Timestamp).toDate() ==
                datetime.add(Duration(minutes: (i + 1) * 30))) {
            } else {
              print("คิวว่าง");
            }
          }
          print("บันทึกคิวลงในระบบได้");
        }
      }
    } else {
      print("คิวว่าง ไม่มีค่า");
    }
  }

  Future<void> checkQueueInDatabase2() async {
    DateTime timee = DateFormat('yyyyy-MM-dd HH:mm:ss')
        .parse('${datetime.year}-${datetime.month}-${datetime.day} 00:00:00');
    var data = await FirebaseFirestore.instance
        .collection('Barber')
        .doc(emailBarber)
        .collection('queue')
        .doc("$timee")
        .collection("time")
        .get();
    var alldata = data.docs.map((e) => e.data()).toList();
    bool queue = true;
    if (alldata.isNotEmpty) {
      int i = 0;
      while (i < alldata.length) {
        if ((alldata[i]["timestart"] as Timestamp).toDate() == datetime) {
          print("คิวไม่ว่าง เวลาตรงกัน");
          i = alldata.length;
          queue = false;
        } else {
          int n = 0;
          while (n < timeint / 30) {
            if ((alldata[i]["timestart"] as Timestamp).toDate() ==
                datetime.add(Duration(minutes: n * 30))) {
              print('คิวไม่ว่่าง มีเวลาที่อยู่ในคิว *');
              n = 200;
              i = alldata.length;
              queue = false;
            } else if (n != 0) {
              if ((alldata[i]["timeend"] as Timestamp).toDate() ==
                  datetime.add(Duration(minutes: (n) * 30))) {
                print('คิวไม่ว่่าง มีเวลาที่อยู่ในคิว **');
                n = 200;
                i = alldata.length;
                queue = false;
              }
            } else {
              print("คิวว่าง");
            }
            n++;
          }
        }
        i++;
      }
    } else {
      print("คิวว่าง ไม่มีค่า");
      queue = false;
    }
    if (queue) {
      // print("บันทึกคิวลงในระบบ");
      insertQueue();
    } else {
      // print("ไม่บันทึกคิวลงในระบบ");
      MyDialog(funcAction: f1).hardDialog(
        context,
        "กรุณาเปลี่ยนเวลาที่ต้องการจอง",
        "คิวไม่ว่าง",
      );
    }
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

  Future<void> insertQueue() async {
    List<String> listid = [];
    List<String> listname = [];
    List<String> listdetail = [];
    List listprice = [];
    List listtime = [];
    for (var i = 0; i < servicemodel.length; i++) {
      listid.add(servicemodel[i].id);
      listname.add(servicemodel[i].name);
      listdetail.add(servicemodel[i].detail);
      listprice.add(servicemodel[i].price);
      listtime.add(servicemodel[i].time);
    }
    DateTime timee = DateFormat('yyyyy-MM-dd HH:mm:ss')
        .parse('${datetime.year}-${datetime.month}-${datetime.day} 00:00:00');
    await FirebaseFirestore.instance
        .collection('Barber')
        .doc(emailBarber)
        .collection('queue')
        .doc("$timee")
        .collection("time")
        .doc("$datetime")
        .set({
      "emailbarber": emailBarber,
      "idUser": idUser,
      "timestart": datetime,
      "timeend": datetime.add(Duration(minutes: timeint))
    }).then((value) async {
      await FirebaseFirestore.instance
          .collection('Barber')
          .doc(emailBarber)
          .collection('queue')
          .doc("$timee")
          .collection("time")
          .doc("$datetime")
          .collection("service")
          .add({
        "idService": listid,
        "nameService": listname,
        "detailService": listdetail,
        "priceService": listprice,
        "timeService": listtime,
      }).then((value) => MyDialog(funcAction: f2).hardDialog(
              context, "ขอบคุณที่ใช้บริการจองคิวของเรา", "บันทึกสำเร็จ"));
    });
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
      "barberEmail": emailBarber,
      "hairdresserID": hairdresserID,
      "UserID": idUser,
      "timestart": datetime,
      "timeend": datetime.add(Duration(minutes: timeint)),
      "service": items.map<Map>((e) => e.toMap()).toList()
    }).then((value) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) {
          return IndexPage();
        }
        
      ), (route) => false);
    });
  }
}
