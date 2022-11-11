import 'dart:async';
import 'package:barber/main.dart';
import 'package:barber/pages/User/reservation_detail_user.dart';
import 'package:barber/utils/dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:barber/Constant/contants.dart';
import 'package:barber/data/barbermodel.dart';
import 'package:barber/data/sqlite_model.dart';
import 'package:barber/pages/User/barberserch_user.dart';
import 'package:barber/pages/User/search_user.dart';
import 'package:barber/utils/sqlite_helper.dart';
import 'package:barber/widgets/barbermodel3.dart';
import 'dart:math' as math;
import '../../Constant/route_cn.dart';

class HairCutUser extends StatefulWidget {
  String nameUser, idUser;
  Stream<BarberModel> stream2;
  HairCutUser(
      {Key? key,
      required this.stream2,
      required this.nameUser,
      required this.idUser})
      : super(key: key);

  @override
  State<HairCutUser> createState() =>
      _HairCutUserState(nameUser: nameUser, idUser: idUser);
}

class _HairCutUserState extends State<HairCutUser> {
  List<SQLiteModel> sqliteModels = [];
  String nameUser, idUser;
  _HairCutUserState({required this.nameUser, required this.idUser});
  double? lat, lng;
  String? dataPositionUser;
  bool loadHistory = true;
  bool loadSqlite = true;
  bool clickshowmore = false;
  bool haveOnStatus = false;
  void mySetState2() {
    setState(() {
      barberLike;
    });
  }

  @override
  void initState() {
    super.initState();
    widget.stream2.listen((barberModel) {
      mySetState2();
    });
    chechpermission();
    getLikeShop();
    getHistoryshop();
  }

  getLikeShop() async {
    if (sqliteModels.isNotEmpty) {
      sqliteModels.clear();
    }
    List<BarberModel> data = [];
    List<String> emailvalueGetSqlite = [];
    await SQLiteHelper().readSQLite().then((value) async {
      for (var i = 0; i < value.length; i++) {
        emailvalueGetSqlite.add(value[i].email);
      }
      await FirebaseFirestore.instance
          .collection("Barber")
          .where("email", whereIn: emailvalueGetSqlite)
          .get()
          .then((newvalue) async {
        var alldata = newvalue.docs.map((e) => e.data()).toList();
        List<BarberModel> listLike = [];
        for (var i = 0; i < alldata.length; i++) {
          double average = 0;
          if (alldata[i]["score"] != null) {
            average = alldata[i]["score"]["num"] / alldata[i]["score"]["count"];
          } else {
            average = 0;
          }

          if (average.isNaN) {
            average = 0;
          }
          print("dqdqwe1 $average");
          listLike.add(BarberModel(
              email: alldata[i]["email"],
              name: alldata[i]["name"],
              lasiName: alldata[i]["lastname"],
              phone: alldata[i]["phone"],
              typebarber: alldata[i]["typeBarber"],
              shopname: alldata[i]["shopname"],
              shoprecommend: alldata[i]["shoprecommend"],
              dayopen: alldata[i]["dayopen"],
              timeopen: alldata[i]["timeopen"],
              timeclose: alldata[i]["timeclose"],
              lat: alldata[i]["position"]["lat"],
              lng: alldata[i]["position"]["lng"],
              districtl: alldata[i]["position"]["district"],
              subDistrict: alldata[i]["position"]["subdistrict"],
              addressdetails: alldata[i]["position"]["addressdetails"],
              url: alldata[i]["url"],
              score: average,
              geoHasher: alldata[i]["position"]["geohash"]));
        }
        setState(() {
          barberLike = listLike;
          loadSqlite = false;
        });
      });
    });
  }

  List<BarberModel> barberHistory = [];
  Future<Null> getHistoryshop() async {
    var data = await FirebaseFirestore.instance
        .collection('Queue')
        .where("user.id", isEqualTo: idUser)
        .get()
        .then((value) async {
      var alldata = value.docs.map((e) => e.data()).toList();
      var listHistory = [];
      if (alldata.isEmpty) {
        setState(() {
          loadHistory = false;
        });
      }
      for (var i = 0; i < alldata.length; i++) {
        if (listHistory.contains(alldata[i]["barber"]["id"])) {
        } else {
          listHistory.add(alldata[i]["barber"]["id"]);
        }
      }
      var data2 = await FirebaseFirestore.instance
          .collection("Barber")
          .where("email", whereIn: listHistory)
          .get();
      var alldata2 = data2.docs.map((e) => e.data()).toList();
      List<BarberModel> barberlist = [];
      if (alldata2.isNotEmpty) {
        for (var n = 0; n < alldata2.length; n++) {
          double average = 0;
          if (alldata2[n]["score"] != null) {
            print("dweqeqeqeq");
            average =
                alldata2[n]["score"]["num"] / alldata2[n]["score"]["count"];
          } else {
            print("dweqeqeqeq5");

            average = 0;
          }
          if (average.isNaN) {
            average = 0;
          }
          barberlist.add(BarberModel(
              email: alldata2[n]["email"],
              name: alldata2[n]["name"],
              lasiName: alldata2[n]["lastname"],
              phone: alldata2[n]["phone"],
              typebarber: alldata2[n]["typeBarber"],
              shopname: alldata2[n]["shopname"],
              shoprecommend: alldata2[n]["shoprecommend"],
              dayopen: alldata2[n]["dayopen"],
              timeopen: alldata2[n]["timeopen"],
              timeclose: alldata2[n]["timeclose"],
              lat: alldata2[n]["position"]["lat"],
              lng: alldata2[n]["position"]["lng"],
              districtl: alldata2[n]["position"]["district"],
              subDistrict: alldata2[n]["position"]["subdistrict"],
              addressdetails: alldata2[n]["position"]["addressdetails"],
              url: alldata2[n]["url"],
              score: average,
              geoHasher: alldata2[n]["position"]["geohash"]));
        }
      } else {
        setState(() {
          loadHistory = false;
        });
      }

      setState(() {
        barberHistory = barberlist;
        loadHistory = false;
      });
    });
  }

  Future<Null> chechpermission() async {
    bool locationService;
    LocationPermission locationPermission;
    locationService = await Geolocator.isLocationServiceEnabled();
    if (locationService) {
      print("location open");
      locationPermission = await Geolocator.checkPermission();
      if (locationPermission == LocationPermission.denied) {
        locationPermission = await Geolocator.requestPermission();
        if (locationPermission == LocationPermission.deniedForever) {
          // print("LocationPermission.deniedForever");
          setState(() {
            dataPositionUser = "LocationPermission ไม่ได้รับอนุญาต";
          });
        } else {
          findposition().then((value) => getDataPosition());
        }
      } else {
        if (locationPermission == LocationPermission.deniedForever) {
          //  print("LocationPermission.deniedForever");
          setState(() {
            dataPositionUser = "LocationPermission ไม่ได้รับอนุญาต";
          });
        } else {
          findposition().then((value) => getDataPosition());
        }
      }
    } else {
      setState(() {
        dataPositionUser = "Location ปิดอยู่";
      });
    }
  }

  Future<Null> getDataPosition() async {
    String path =
        "https://api.longdo.com/map/services/address?lon=$lng&lat=$lat&nopostcode=0&noroad=0&noaoi=0&noelevation=0&nowater=0&key=${Contants.keyLongdomap}";
    await Dio().get(path).then((value) {
      setState(() {
        dataPositionUser =
            "${value.data["subdistrict"]} ${value.data["district"]}";
      });
    });
  }

  Future<Null> findposition() async {
    print("findLatlan ==> Work");
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      lat = position.latitude;
      lng = position.longitude;
    });
  }

  CarouselController buttonCarouselController = CarouselController();
  List<String> imgList = [];

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Contants.myBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchUser(
                    nameUser: nameUser == "" ? "" : nameUser,
                  ),
                ));
          },
        ),
        title: dataPositionUser == null
            ? const Text('')
            : Row(
                children: [
                  Icon(
                    Icons.pin_drop_outlined,
                    color: Contants.colorSpringGreen,
                  ),
                  Text(
                    dataPositionUser!,
                    style: Contants().h3white(),
                  ),
                ],
              ),
        actions: [
          nameUser == ""
              ? TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Rount_CN.routeLogin);
                  },
                  child: Text(
                    "Login",
                    style: Contants().h3SpringGreen(),
                  ))
              : Center(
                  child: Text(
                    nameUser,
                    style: Contants().h3white(),
                  ),
                )
        ],
        backgroundColor: Contants.myBackgroundColordark,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buttonChooseAType(size),
            builfstream(),
            haveOnStatus
                ? TextButton(
                    onPressed: () {
                      setState(() {
                        clickshowmore = !clickshowmore;
                      });
                    },
                    child: Text(
                      clickshowmore ? 'ปิด' : 'ดูเพิ่มเติม',
                      style: Contants().h4SpringGreen(),
                    ))
                : const SizedBox(),
            barberHistory.isNotEmpty && loadHistory == false
                ? sectionListview(
                    size,
                    "ร้านที่เคยใช้บริการ",
                    Icon(
                      Icons.shop,
                      color: Contants.colorSpringGreen,
                      size: 30,
                    ))
                : const SizedBox(),
            loadHistory
                ? LoadingAnimationWidget.waveDots(
                    size: 40, color: Contants.colorSpringGreen)
                : barberHistory.isNotEmpty
                    ? listStoreHistory(size)
                    : const SizedBox(),
            barberHistory.isNotEmpty
                ? const SizedBox(
                    height: 20,
                  )
                : const SizedBox(),
            barberLike.isNotEmpty
                ? sectionListview(
                    size,
                    "ร้านที่ถูกใจ",
                    Icon(
                      Icons.favorite,
                      color: Contants.colorSpringGreen,
                      size: 30,
                    ))
                : const SizedBox(),
            barberLike.isNotEmpty ? listStoreLike(size) : const SizedBox(),
            barberLike.isNotEmpty
                ? const SizedBox(
                    height: 30,
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  String dateTime(var timestart, var timeend) {
    DateTime start = DateTime.parse(timestart);
    DateTime end = DateTime.parse(timeend);
    return "${start.day}/${start.month}/${start.year} ${start.hour.toString().padLeft(2, "0")}.${start.minute.toString().padLeft(2, "0")} - ${end.hour.toString().padLeft(2, "0")}.${end.minute.toString().padLeft(2, "0")}";
  }

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> builfstream() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Queue")
          .where("user.id", isEqualTo: idUser)
          .where("status", isEqualTo: "on")
          .orderBy("time.timestart")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data.docs;
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var time = dateTime(data[index]["time"]["timestart"],
                  data[index]["time"]["timeend"]);
              if (index == 0) {
                return Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Contants.colorBlack,
                    ),
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                  color: Contants.colorOxfordBlueLight,
                  child: ListTile(
                    leading: Text(
                      "รอ",
                      style: Contants().h1yellow(),
                    ),
                    title: Text(
                      data[index]["barber"]["name"],
                      style: Contants().h3white(),
                    ),
                    subtitle: Text(time, style: Contants().h4Grey()),
                    trailing: IconButton(
                      iconSize: 20,
                      color: Contants.colorRed,
                      icon: const Icon(Icons.cancel),
                      onPressed: () {
                        dialogcancelQueue(
                            DateTime.parse(data[index]["time"]["timestart"]),
                            data[index].id);
                      },
                    ),
                    onTap: () {
                      final person = barberHistory.indexWhere(
                        (element) =>
                            element.email == data[index]["barber"]["id"],
                      );
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReservationDetailUser(
                              docID: data[index].id,
                              urlimg: barberHistory[person].url == ""
                                  ? ""
                                  : barberHistory[person].url,
                              namebarber: data[index]["barber"]["name"],
                              nameHairresser: data[index]["hairdresser"]
                                  ["name"],
                              timestart:
                                  "${DateTime.parse(data[index]["time"]["timestart"]).hour.toString().padLeft(2, "0")}.${DateTime.parse(data[index]["time"]["timestart"]).minute.toString().padLeft(2, "0")}",
                              timeend:
                                  "${DateTime.parse(data[index]["time"]["timeend"]).hour.toString().padLeft(2, "0")}.${DateTime.parse(data[index]["time"]["timeend"]).minute.toString().padLeft(2, "0")}",
                              service: data[index]["service"],
                              nameUser: nameUser,
                              phoneBarber: data[index]["barber"]["phone"],
                              phoneHairresser: data[index]["hairdresser"]
                                  ["phone"],
                              emailBarber: data[index]["barber"]["id"],
                            ),
                          ));
                    },
                  ),
                );
              } else {
                haveOnStatus = true;
                if (clickshowmore) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Contants.colorBlack,
                      ),
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                    color: Contants.colorOxfordBlueLight,
                    child: ListTile(
                      leading: Text(
                        "รอ",
                        style: Contants().h1yellow(),
                      ),
                      title: Text(
                        data[index]["barber"]["name"],
                        style: Contants().h3white(),
                      ),
                      subtitle: Text(
                        time,
                        style: Contants().h4Grey(),
                      ),
                      trailing: IconButton(
                        iconSize: 20,
                        color: Contants.colorRed,
                        icon: const Icon(Icons.cancel),
                        onPressed: () {
                          dialogcancelQueue(
                              DateTime.parse(data[index]["time"]["timestart"]),
                              data[index].id);
                        },
                      ),
                      onTap: () {
                        final person = barberHistory.indexWhere(
                          (element) =>
                              element.email == data[index]["barber"]["id"],
                        );
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReservationDetailUser(
                                docID: data[index].id,
                                urlimg: barberHistory[person].url == ""
                                    ? ""
                                    : barberHistory[person].url,
                                namebarber: data[index]["barber"]["name"],
                                nameHairresser: data[index]["hairdresser"]
                                    ["name"],
                                timestart:
                                    "${DateTime.parse(data[index]["time"]["timestart"]).hour.toString().padLeft(2, "0")}.${DateTime.parse(data[index]["time"]["timestart"]).minute.toString().padLeft(2, "0")}",
                                timeend:
                                    "${DateTime.parse(data[index]["time"]["timeend"]).hour.toString().padLeft(2, "0")}.${DateTime.parse(data[index]["time"]["timeend"]).minute.toString().padLeft(2, "0")}",
                                service: data[index]["service"],
                                nameUser: nameUser,
                                phoneBarber: data[index]["barber"]["phone"],
                                phoneHairresser: data[index]["hairdresser"]
                                    ["phone"],
                                emailBarber: data[index]["barber"]["id"],
                              ),
                            ));
                      },
                    ),
                  );
                } else {
                  return SizedBox();
                }
              }
            },
            itemCount: data.length,
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Future<Null> dialogcancelQueue(DateTime times, String idQueue) async {
    showDialog(
        context: context,
        builder: (conttext) => SimpleDialog(
              title: const Text("ยืนยันการยกเลิกคิวใช่หรือไม่"),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "ยกเลิก",
                          style: Contants().h3yellow(),
                        )),
                    TextButton(
                        onPressed: () async {
                          if (times.isAfter(
                              DateTime.now().add(Duration(hours: 2)))) {
                            print("ยกเลิกได้");
                            await FirebaseFirestore.instance
                                .collection("Queue")
                                .doc(idQueue)
                                .update({"status": "cancel"}).then((value) =>
                                    MyDialog(funcAction: fc3).hardDialog(
                                        context,
                                        "ระบบได้ทำการยกเลิกคิวของท่านแล้ว",
                                        "ยกเลิกสำเร็จ"));
                          } else {
                            print("ยกเลิกไม่ได้");
                            MyDialog(funcAction: fc3).hardDialog(
                                context,
                                "ต้องยกเลิกก่อนเวลานัด 2 ชม. เท่านั้น",
                                "การยกเลิกล้มเหลว");
                          }
                        },
                        child: Text(
                          "ยืนยันการยกเลิก",
                          style: Contants().h3Red(),
                        ))
                  ],
                ),
              ],
            ));
  }

  void fc3() {
    Navigator.pop(context);
    Navigator.pop(context);
  }

  Widget listStoreLike(double size) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      height: 165,
      child: Expanded(
        flex: 3,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: barberLike.length,
          itemBuilder: (context, index) => Stack(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                width: 130,
                child: BarberModel3(
                    nameUser: nameUser == "" ? "" : nameUser,
                    barberModel: barberLike[index],
                    url: barberLike[index].url),
              ),
              Center(
                child: Container(
                    margin: const EdgeInsets.only(top: 130, left: 0),
                    child: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () async {
                        await SQLiteHelper()
                            .deleteSQLiteWhereId(barberLike[index].email);
                        setState(() {
                          barberLike.removeAt(index);
                        });
                      },
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container listStoreHistory(double size) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      height: 165,
      child: Expanded(
        flex: 3,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: barberHistory.length,
          itemBuilder: (context, index) => Stack(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                width: 130,
                child: BarberModel3(
                    nameUser: nameUser == "" ? "" : nameUser,
                    barberModel: barberHistory[index],
                    url: barberHistory[index].url),
              ),
              Center(
                child: Container(
                    margin: const EdgeInsets.only(top: 130, left: 0),
                    child: IconButton(
                      icon: Icon(Icons.favorite,
                          color: barberLike.contains(barberHistory[index])
                              ? Colors.red
                              : Colors.grey),
                      onPressed: () async {
                        if (barberLike.contains(barberHistory[index]) ==
                            false) {
                              print(barberHistory[index].email);
                          SQLiteModel sqLiteModel =
                              SQLiteModel(email: barberHistory[index].email);
                          await SQLiteHelper().insertValueToSQlite(sqLiteModel);
                          setState(() {
                            barberLike.add(barberHistory[index]);
                          });
                        } else {
                          print(barberLike[index].email);
                          await SQLiteHelper()
                              .deleteSQLiteWhereId(barberHistory[index].email);
                          setState(() {
                            barberLike.remove(barberHistory[index]);
                          });
                        }
                      },
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Row sectionListview(double size, String title, Icon icon) {
    return Row(
      children: [
        icon,
        Text(
          title,
          style: Contants().h2white(),
        ),
      ],
    );
  }

  Container buttonChooseAType(double size) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BarberSerchUser(
                      nameUser: nameUser == "" ? "" : nameUser,
                      typeBarber: true,
                      lat: lat,
                      lon: lng,
                      stream2: streamController2.stream,
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  Transform(
                      transform: Matrix4.rotationY(math.pi),
                      alignment: Alignment.center,
                      child: Image.asset("images/man.png")),
                  Text(
                    "ตัดผมชาย ",
                    style: Contants().h2OxfordBlue(),
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(primary: Contants.colorWhite),
            ),
            width: size * 0.4,
            height: 100,
          ),
          SizedBox(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BarberSerchUser(
                              nameUser: nameUser == "" ? "" : nameUser,
                              typeBarber: false,
                              lat: lat,
                              lon: lng,
                              stream2: streamController2.stream,
                            )));
              },
              child: Column(
                children: [
                  Image.asset("images/woman.png"),
                  Text(
                    "เสริมสวย ",
                    style: Contants().h2OxfordBlue(),
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(primary: Contants.colorWhite),
            ),
            width: size * 0.4,
            height: 100,
          )
        ],
      ),
    );
  }
}
