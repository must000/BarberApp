import 'dart:async';
import 'package:barber/Constant/contants.dart';
import 'package:barber/data/barbermodel.dart';
import 'package:barber/data/hairdressermodel.dart';
import 'package:barber/main.dart';
import 'package:barber/pages/Barbermanager/member_barber.dart';
import 'package:barber/pages/OtherPage/other_Hairdresser.dart';
import 'package:barber/pages/Hairdresser/queue_Hairdresser.dart';
import 'package:barber/pages/Hairdresser/service_barber.dart';
import 'package:barber/pages/User/haircut_user.dart';
import 'package:barber/pages/havenophonenumber.dart';
import 'package:barber/pages/icon_page.dart';
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
  String userID = "";
  String nameUser = "";
  bool load = true;
  List<BarberModel> barbershop = [];
  @override
  void initState() {
    super.initState();
    
    findEmail().then((value) {
      setState(() {
        load = false;
      });
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
          userID = event.uid;
          if (event.displayName != null) {
            nameUser = event.displayName!;
          }

          if (event.phoneNumber != null) {
            phoneHairdresser = event.phoneNumber!;
          }
        });
        FirebaseFirestore.instance
            .collection('Hairdresser')
            .where("email", isEqualTo: "$email")
            .snapshots()
            .listen((event) async {
          var doc = event.docs;
          if (doc.isNotEmpty) {
            setState(() {
              hairdresserID = doc[0].id;
              dataHairresser = HairdresserModel(
                  hairdresserID: doc[0].id,
                  email: doc[0].data()["email"],
                  idCode: doc[0].data()["idCode"],
                  name: doc[0].data()["name"],
                  lastname: doc[0].data()["lastname"],
                  serviceID: doc[0].data()["serviceID"],
                  barberStatus: doc[0].data()["barberState"],
                  phone: doc[0].data()["phone"]);
              isbarber = true;
              load = false;
            });
          } else {
            print("email is $email");
          await  FirebaseFirestore.instance
                .collection('Barber')
                .doc(email)
                .get()
                .then((value) {
              if (value.data() == null) {
                print("ไม่ใช่ผู้จัดการร้าน");
              } else {
                print("ผู้จัดการร้าน");
                double average = 0;
                if (value.data()!["score"] != null) {
                  average = value.data()!["score"]["num"] /
                      value.data()!["score"]["count"];
                } else {
                  average = 0;
                }
                if (average.isNaN) {
                  average = 0;
                }
                print(value.data());
                barberModelformanager = BarberModel(
                    email: value.data()!["email"],
                    name: value.data()!["name"],
                    lasiName: value.data()!["lastname"],
                    phone: value.data()!["phone"],
                    typebarber: value.data()!["typeBarber"],
                    shopname: value.data()!["shopname"],
                    shoprecommend: value.data()!["shoprecommend"],
                    dayopen: value.data()!["dayopen"],
                    timeopen: value.data()!["timeopen"],
                    timeclose: value.data()!["timeclose"],
                    lat: value.data()!["position"]["lat"],
                    lng: value.data()!["position"]["lng"],
                    districtl: value.data()!["position"]["district"],
                    subDistrict: value.data()!["position"]["subdistrict"],
                    addressdetails: value.data()!["position"]["addressdetails"],
                    url: value.data()!["url"],
                    score: average,
                    geoHasher: value.data()!["position"]["geohash"]);
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  builder: (context) {
                    print("oopppp $phoneHairdresser");
                    if (phoneHairdresser == "") {
                      // phonefff เปิดระบบลงทะเบียนเบอร์ = "" ไม่เปิด != ""
                      return const HaveNoPhoneNumbar();
                    } else {
                      return MemberBarberPage();
                    }
                  },
                ), (route) => false);
              }
            });
          }
        }, onError: (error) => print("Listen failed: $error"));
      });
    });
  }

  _IndexPageState({this.isbarber});
  @override
  Widget build(BuildContext context) {
    return load == true
        ? Image.asset("images/iconapp.png")
        : isbarber == null
            ? DefaultTabController(
                length: 3,
                child: Scaffold(
                  body: TabBarView(children: [
                    HairCutUser(
                      idUser: userID == "" ? "" : userID,
                      nameUser: nameUser == "" ? "" : nameUser,
                      stream2: streamController2.stream,
                    ),
                    ReservationUser(
                      userID: userID,
                      nameUser: nameUser,
                    ),
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
            : phoneHairdresser ==
                    "" // phonefff เปิดระบบลงทะเบียนเบอร์ = "" ไม่เปิด != ""
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
                            name: dataHairresser!.name,
                            lastname: dataHairresser!.lastname,
                            email: email!,
                            barberState: dataHairresser!.barberStatus,
                            idHairdresser: hairdresserID!, phone: phoneHairdresser,
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
