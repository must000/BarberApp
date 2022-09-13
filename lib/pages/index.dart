import 'dart:async';
import 'package:barber/Constant/contants.dart';
import 'package:barber/data/barbermodel.dart';
import 'package:barber/data/hairdressermodel.dart';
import 'package:barber/main.dart';
import 'package:barber/pages/OtherPage/other_Hairdresser.dart';
import 'package:barber/pages/Hairdresser/queue_Hairdresser.dart';
import 'package:barber/pages/Hairdresser/service_barber.dart';
import 'package:barber/pages/User/haircut_user.dart';
import 'package:barber/pages/havenophonenumber.dart';
import 'package:barber/utils/show_progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:barber/pages/OtherPage/other_user.dart';
import 'package:barber/pages/User/reservation_user.dart';

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
  String? hairdresserID;
  String phoneHairdresser = "";

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

  bool? isbarber;
  HairdresserModel? dataHairresser;
  Future<Null> findEmail() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        setState(() {
          email = event!.email;
          if (event.phoneNumber != null) {
            phoneHairdresser = event.phoneNumber!;
          }
        });
        FirebaseFirestore.instance
            .collection('Hairdresser')
            .where("email", isEqualTo: "$email")
            .snapshots()
            .listen((event) {
          var doc = event.docs;
          if (doc.isNotEmpty) {
            // print("listener attached ${doc[0].data()["email"]}");
            // print("listener attached ${doc[0].data()["serviceID"]}");
            setState(() {
              hairdresserID = doc[0].id;
              dataHairresser = HairdresserModel(
                  hairdresserID: doc[0].id,
                  email: doc[0].data()["email"],
                  idCode: doc[0].data()["idCode"],
                  name: doc[0].data()["name"],
                  lastname: doc[0].data()["lastname"],
                  serviceID: doc[0].data()["serviceID"],
                  barberStatus: doc[0].data()["barberState"]);
              print(dataHairresser);
              isbarber = true;
              load = false;
            });
          } else {
            print("ไม่มี data");
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
          addressdetails: alldata[n]["addressdetails"],
          like: false));
    }
  }

  _IndexPageState({this.isbarber});
  @override
  Widget build(BuildContext context) {
    return load == true
        ? const ShowProgress()
        : isbarber == null
            ? DefaultTabController(
                // initialIndex: tabsele,
                length: 3,
                child: Scaffold(
                  body: TabBarView(children: [
                    HairCutUser(
                      barbershop: barbershop,
                      stream2: streamController2.stream,
                    ),
                    const ReservationUser(),
                    const OtherUser(),
                  ]),
                  bottomNavigationBar: Container(
                    color: Contants.colorBlack,
                    child: TabBar(
                      indicatorColor: Contants.colorSpringGreen,
                      labelColor: Contants.colorSpringGreen,
                      unselectedLabelColor: Colors.white,
                      labelStyle: Contants().h3SpringGreen(),
                      tabs: const [
                        Tab(
                          text: "ตัดผม",
                          icon: Icon(
                            Icons.cut,
                            size: 30,
                          ),
                        ),
                        Tab(
                          text: "การจอง",
                          icon: Icon(
                            Icons.format_list_bulleted,
                            size: 30,
                          ),
                        ),
                        Tab(
                          text: "อื่นๆ",
                          icon: Icon(
                            Icons.account_box,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : phoneHairdresser == ""
                ? const DefaultTabController(
                    length: 1, child: HaveNoPhoneNumbar())
                : DefaultTabController(
                    length: 3,
                    child: Scaffold(
                      body: TabBarView(
                        children: [
                          QueueHairdresser(
                            hairdresserID: hairdresserID!,
                            barberState: dataHairresser!.barberStatus,
                            idCode: dataHairresser!.idCode,
                          ),
                          ServiceBarber(
                            serviceID: dataHairresser!.serviceID,
                          ),
                          OtherHairdresser(
                            fullname:
                                "${dataHairresser!.name} ${dataHairresser!.lastname}",
                            email: email!,
                            barberState: dataHairresser!.barberStatus,
                            idHairdresser: hairdresserID!,
                          ),
                        ],
                      ),
                      bottomNavigationBar: Container(
                        color: Contants.colorBlack,
                        child: TabBar(
                          indicatorColor: Contants.colorSpringGreen,
                          labelColor: Contants.colorSpringGreen,
                          unselectedLabelColor: Colors.white,
                          labelStyle: Contants().h3SpringGreen(),
                          tabs: const [
                            Tab(
                              text: "การจอง",
                              icon: Icon(
                                Icons.table_chart_outlined,
                                size: 30,
                              ),
                            ),
                            Tab(
                              text: "บริการ",
                              icon: Icon(
                                Icons.cut_sharp,
                                size: 30,
                              ),
                            ),
                            Tab(
                              text: "อื่นๆ",
                              icon: Icon(
                                Icons.store,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
  }
}
