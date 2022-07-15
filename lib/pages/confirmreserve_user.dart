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
  @override
  void initState() {
    super.initState();
    findEmail().then((value) {});
    print(servicemodel);
    totalTimeAndPrice();
    checkdayclose();
  }

  totalTimeAndPrice() {
    int _time = 0, _price = 0;
    for (var i = 0; i < servicemodel.length; i++) {
      _time += servicemodel[i].time.toInt();
      _price += servicemodel[i].price.toInt();
    }
    setState(() {
      time = _time;
      price = _price;
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
        open = true;
      });
    } else {
      setState(() {
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
          : Column(
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
                        child: const Text("เปลี่ยนวันที่ "))
                  ],
                ),
                open
                    ? Container(
                        child: Text("ร้านเปิด"),
                      )
                    : Container(
                        child: Text("ร้านปิดทำการ "),
                      )
              ],
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
    }
  }
}
