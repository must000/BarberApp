import 'dart:async';
import 'package:barber/main.dart';
import 'package:barber/pages/User/barber_user.dart';
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
import 'package:barber/pages/search_user.dart';
import 'package:barber/utils/sqlite_helper.dart';
import 'package:barber/widgets/barbermodel3.dart';

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
    // getLikeShop();
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
              lat: alldata[i]["lat"],
              lng: alldata[i]["lon"],
              districtl: alldata[i]["district"],
              subDistrict: alldata[i]["subdistrict"],
              addressdetails: alldata[i]["addressdetails"],
              url: alldata[i]["url"],
              score: average));
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
      for (var n = 0; n < alldata2.length; n++) {
        double average;
        if (alldata2[n]["score"] != null) {
          average = alldata2[n]["score"]["num"] / alldata2[n]["score"]["count"];
        } else {
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
            lat: alldata2[n]["lat"],
            lng: alldata2[n]["lon"],
            districtl: alldata2[n]["district"],
            subDistrict: alldata2[n]["subdistrict"],
            addressdetails: alldata2[n]["addressdetails"],
            url: alldata2[n]["url"],
            score: average));
      }
      setState(() {
        barberHistory = barberlist;
        loadHistory = false;
      });
    });
  }

  // Future<Null> processReadSQLite() async {
  //   if (sqliteModels.isNotEmpty) {
  //     sqliteModels.clear();
  //   }
  //   List<BarberModel> data = [];
  //   await SQLiteHelper().readSQLite().then((value) {
  //     for (var i = 0; i < value.length; i++) {
  //       for (var n = 0; n < barbershop!.length; n++) {
  //         if (value[i].email == barbershop![n].email) {
  //           data.add(barbershop![n]);
  //         }
  //       }
  //     }
  //     setState(() {
  //       barberLike = data;
  //     });
  //   });
  // }

  // Future<Null> getURL() async {
  //   Map<String, String>? urlImgFrontModel = {};
  //   for (var i = 0; i < barberLike.length; i++) {
  //     Reference ref = FirebaseStorage.instance
  //         .ref()
  //         .child("imgfront/${barberLike[i].email}");
  //     var url = await ref.getDownloadURL().then((value) {
  //       urlImgFrontModel[barberLike[i].email] = value;
  //     }).catchError((c) => print(c + "is an error getURL $c"));
  //   }
  //   setState(() {
  //     urlImgLike = urlImgFrontModel;
  //     if (barberLike.isNotEmpty) {
  //       getSqlite = true;
  //     }
  //   });
  // }

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
      print(value);
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
      print("lat = $lat" + "lng = $lng");
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
        title:
            dataPositionUser == null ? const Text('') : Text(dataPositionUser!),
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
            barberHistory.isNotEmpty && loadHistory == false
                ? sectionListview(size, "ร้านที่เคยใช้บริการ")
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
                ? sectionListview(size, "ร้านที่ถูกใจ")
                : const SizedBox(),
            barberLike.isNotEmpty ? listStoreLike(size) : const SizedBox(),
          ],
        ),
      ),
    );
  }

  // Future<Null> test() async {
  //   await FirebaseFirestore.instance
  //       .collection('test')
  //       .doc("76cvuBjj8UcCx0K6wDeq").update({"score":FieldValue.increment(4)});
  // }

  Widget listStoreLike(double size) {
    return SizedBox(
      // margin: const EdgeInsets.only(bottom: 20,right: 10),
      height: 120,
      child: Expanded(
        flex: 3,
        child: ListView.builder(
          // itemExtent: 100,
          scrollDirection: Axis.horizontal,
          itemCount: barberLike.length,
          itemBuilder: (context, index) => Stack(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: 120,
                height: 120,
                child: BarberModel3(
                    nameUser: nameUser == "" ? "" : nameUser,
                    barberModel: barberLike[index],
                    url: barberLike[index].url),
              ),
              Center(
                child: Container(
                    margin: const EdgeInsets.only(),
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

  SizedBox listStoreHistory(double size) {
    return SizedBox(
      // margin: const EdgeInsets.only(bottom: 20,right: 10),
      height: 120,
      child: Expanded(
        flex: 3,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: barberHistory.length,
          itemBuilder: (context, index) => Stack(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: 120,
                height: 120,
                child: BarberModel3(
                    nameUser: nameUser == "" ? "" : nameUser,
                    barberModel: barberHistory[index],
                    url: barberHistory[index].url),
              ),
              Center(
                child: Container(
                    margin: const EdgeInsets.only(),
                    child: IconButton(
                      icon: Icon(Icons.favorite,
                          color: barberLike.contains(barberHistory[index])
                              ? Colors.red
                              : Colors.grey),
                      onPressed: () async {
                        if (barberLike.contains(barberHistory[index]) ==
                            false) {
                          SQLiteModel sqLiteModel =
                              SQLiteModel(email: barberHistory[index].email);
                          await SQLiteHelper().insertValueToSQlite(sqLiteModel);
                          setState(() {
                            barberLike.add(barberHistory[index]);
                          });
                        } else {
                          await SQLiteHelper()
                              .deleteSQLiteWhereId(barberLike[index].email);
                          setState(() {
                            barberLike.removeAt(index);
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

  Container sectionListview(double size, String title) {
    return Container(
      child: Text(
        title,
        style: Contants().h2white(),
      ),
      width: size,
      padding: EdgeInsets.symmetric(horizontal: size * 0.1),
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
                            )));
              },
              child: Column(
                children: [
                  Text(
                    "ตัดผมชาย ",
                    style: Contants().h2OxfordBlue(),
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(primary: Contants.colorWhite),
            ),
            width: size * 0.4,
            height: 40,
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
              child: Text(
                "เสริมสวย",
                style: Contants().h2OxfordBlue(),
              ),
              style: ElevatedButton.styleFrom(primary: Contants.colorWhite),
            ),
            width: size * 0.4,
            height: 40,
          )
        ],
      ),
    );
  }
  //  StreamBuilder<User?> buildUsername_Login(User? user) {
  //   return StreamBuilder(
  //     stream: FirebaseAuth.instance.authStateChanges(),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return const CircularProgressIndicator();
  //       } else if (snapshot.hasData) {
  //         return user?.displayName == null
  //             ? const Text("")
  //             : Center(child: Text("ชื่อผู้ใช้"+user!.displayName!,style: const TextStyle(color: Colors.white),));
  //       } else if (snapshot.hasError) {
  //         return Text("error");
  //       } else {
  //         return TextButton(
  //             onPressed: () {
  //               Navigator.pushNamed(context, Rount_CN.routeLogin);
  //             },
  //             child: const Text("Login"));
  //       }
  //     },
  //   );
  // }
}
