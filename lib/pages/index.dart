import 'dart:async';
import 'dart:collection';

import 'package:barber/data/barbermodel.dart';
import 'package:barber/pages/other_barber.dart';
import 'package:barber/pages/queue_barber.dart';
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
        print('dwerw');
        getDataBarberForUser().then((value) {
          setState(() {
            load = false;
          });
        });
      }
    });
  }

  bool? isbarber;

  Future<Null> findEmail() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        setState(() {
          email = event!.email;
        });
        final data =
            FirebaseFirestore.instance.collection('Barber').doc(event!.email);
        final snapshot = await data.get();
        if (snapshot.exists) {
          setState(() {
            isbarber = true;
            load = false;
          });
        }
      });
    });
  }

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
                  bottomNavigationBar: const TabBar(tabs: [
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
                    )
                  ]),
                ),
              )
            : DefaultTabController(
                length: 4,
                child: Scaffold(
                  body: TabBarView(children: [
                    const QueueBarber(),
                    ServiceBarber(
                      email: email!,
                    ),
                    StoreBarber(
                      email: email!,
                    ),
                    OtherBarber(
                      email: email!,
                    ),
                  ]),
                  bottomNavigationBar: const TabBar(tabs: [
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
                    Tab(
                      child: Icon(
                        Icons.account_box,
                        color: Colors.black,
                      ),
                    )
                  ]),
                ));
  }
}
