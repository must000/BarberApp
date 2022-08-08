import 'dart:async';
import 'dart:collection';

import 'package:barber/data/barbermodel.dart';
import 'package:barber/pages/other_Hairdresser.dart';
import 'package:barber/pages/queue_Hairdresser.dart';
import 'package:barber/pages/queue_setting_hairdresser.dart';
import 'package:barber/pages/service_barber.dart';
import 'package:barber/pages/store_barber.dart';
import 'package:barber/utils/show_progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:barber/pages/haircut_user.dart';
import 'package:barber/pages/other_user.dart';
import 'package:barber/pages/reservation_user.dart';

class IndexPage extends StatefulWidget {
  bool? isbarber;
  IndexPage({
    Key? key,
    this.isbarber,
  }) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState(isbarber: isbarber);
}

class _IndexPageState extends State<IndexPage> {
  String? email;

  bool load = true;
  List<BarberModel> barbershop = [];
  @override
  void initState() {
    super.initState();
    findEmail().then((value) {
      if (isbarber != false) {
        getDataBarberForUser().then((value) {
          setState(() {
            load = false;
          });
        });
      }
    });
  }

  // await Firebase.initializeApp().then((value) async {
  //   await FirebaseAuth.instance.authStateChanges().listen((event) async {
  //     setState(() {
  //       email = event!.email;
  //     });
  //     final data = FirebaseFirestore.instance
  //         .collection('Hairdresser')
  //         .doc(event!.email);
  //     final snapshot = await data.get();
  //     if (snapshot.exists) {
  //       print("snapshot +++ ${snapshot.data()} ");

  //     }
  //   });
  // });

  bool? isbarber;
  String? dataHairresser;
  Future<Null> findEmail() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        setState(() {
          email = event!.email;
        });
        FirebaseFirestore.instance
            .collection('Hairdresser')
            .where("email", isEqualTo: "$email")
            .snapshots()
            .listen((event) {
          var doc = event.docs;

          if (doc.isNotEmpty) {
            print("listener attached ${doc[0].data()["email"]}");
             print("listener attached ${doc[0].data()["serviceID"]}");
          setState(() {
              dataHairresser = doc[0].data()["serviceID"].toString();
            isbarber = true;
            load = false;
          });
          } else {
            print("daaaaaa");
          }
        }, onError: (error) => print("Listen failed: $error"));
      });
    });
  }

  // final cities = [];
  // for (var doc in event.docs) {
  //   cities.add(doc.data()["email"]);
  // }
  // print("cities in CA: ${cities.join(", ")}");

  Future<Null> getDataBarberForUser() async {
    // get ข้อมูลBarber get Url imgfront
    var data = await FirebaseFirestore.instance.collection('Barber').get();
    var alldata = data.docs.map((e) => e.data()).toList();
    // print("is a dataaaaaaaaaaaaaaaaaaaaa");
    // print(alldata);
    for (int n = 0; n < alldata.length; n++) {
      barbershop.add(BarberModel(
          email: alldata[n]["email"],
          name: alldata[n]["name"],
          lasiName: alldata[n]["lastname"],
          phone: alldata[n]["phone"],
          typebarber: alldata[n]["typeBarber"],
          shopname: alldata[n]["shopname"],
          shoprecommend: alldata[n]["shoprecommend"],
          dayopen: alldata[n]["dayopen"],
          timeopen: alldata[n]["timeopen"],
          timeclose: alldata[n]["timeclose"],
          lat: alldata[n]["lat"],
          lng: alldata[n]["lon"],
          districtl: alldata[n]["district"],
          subDistrict: alldata[n]["subdistrict"],
          addressdetails: alldata[n]["addressdetails"]));
    }
  }

  _IndexPageState({this.isbarber});
  @override
  Widget build(BuildContext context) {
    return load == true
        ? const ShowProgress()
        : isbarber == null
            ? DefaultTabController(
                length: 3,
                child: Scaffold(
                  body: TabBarView(children: [
                    HairCutUser(
                      barbershop: barbershop,
                    ),
                    const ReservationUser(),
                    const OtherUser(),
                  ]),
                  bottomNavigationBar: const TabBar(
                    tabs: [
                      Tab(
                        child: Icon(
                          Icons.cut,
                          color: Colors.black,
                        ),
                      ),
                      Tab(
                        child: Icon(
                          Icons.format_list_bulleted,
                          color: Colors.black,
                        ),
                      ),
                      Tab(
                        child: Icon(
                          Icons.account_box,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : DefaultTabController(
                length: 3,
                child: Scaffold(
                  body: TabBarView(
                    children: [
                      QueueHairdresser(
                        email: email!,
                      ),
                      ServiceBarber(
                        serviceID: dataHairresser!,
                      ),
                      OtherHairdresser(
                        email: email!,
                      ),
                    ],
                  ),
                  bottomNavigationBar: const TabBar(
                    tabs: [
                      Tab(
                        child: Icon(
                          Icons.table_chart_outlined,
                          color: Colors.black,
                        ),
                      ),
                      Tab(
                        child: Icon(
                          Icons.cut_sharp,
                          color: Colors.black,
                        ),
                      ),
                      Tab(
                        child: Icon(
                          Icons.store,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
  }
}
