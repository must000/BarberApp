import 'dart:async';
import 'package:barber/main.dart';
import 'package:barber/pages/User/barber_user.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  List<BarberModel> barbershop;
  Stream<BarberModel> stream2;
  HairCutUser({Key? key, required this.barbershop, required this.stream2})
      : super(key: key);

  @override
  State<HairCutUser> createState() =>
      _HairCutUserState(barbershop: this.barbershop);
}

class _HairCutUserState extends State<HairCutUser> {
  List<SQLiteModel> sqliteModels = [];
  List<BarberModel>? barbershop;
  _HairCutUserState({required this.barbershop});
  String? name, email, phone;
  double? lat, lng;
  String? dataPositionUser;
  bool? load = true;
  bool? getSqlite = false;

  BarberUser? barberUser;
  Widget? currentUser;
  String menuName = 'A';

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
    findNameAnEmail();
    processReadSQLite().then((value) => getURL());
  }

 

  Future<Null> processReadSQLite() async {
    if (sqliteModels.isNotEmpty) {
      sqliteModels.clear();
    }
    List<BarberModel> data = [];
    await SQLiteHelper().readSQLite().then((value) {
      for (var i = 0; i < value.length; i++) {
        for (var n = 0; n < barbershop!.length; n++) {
          if (value[i].email == barbershop![n].email) {
            data.add(barbershop![n]);
          }
        }
      }
      setState(() {
        barberLike = data;
      });
    });
  }

  Future<Null> getURL() async {
    Map<String, String>? urlImgFrontModel = {};
    for (var i = 0; i < barberLike.length; i++) {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child("imgfront/${barberLike[i].email}");
      var url = await ref.getDownloadURL().then((value) {
        urlImgFrontModel[barberLike[i].email] = value;
      }).catchError((c) => print(c + "is an error getURL $c"));
    }
    setState(() {
      urlImgLike = urlImgFrontModel;
      if (barberLike.isNotEmpty) {
        getSqlite = true;
      }
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
            load = false;
          });
        } else {
          findposition().then((value) => getDataPosition());
        }
      } else {
        if (locationPermission == LocationPermission.deniedForever) {
          //  print("LocationPermission.deniedForever");
          setState(() {
            dataPositionUser = "LocationPermission ไม่ได้รับอนุญาต";
            load = false;
          });
        } else {
          findposition().then((value) => getDataPosition());
        }
      }
    } else {
      setState(() {
        dataPositionUser = "Location ปิดอยู่";
        load = false;
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
        load = false;
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

  Future<Null> findNameAnEmail() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) {
        print("is an event");
        print(event);
        print(event!.phoneNumber);
        setState(() {
          name = event.displayName!;
          email = event.email!;
          phone = event.phoneNumber!;
        });
      });
    });
  }

  CarouselController buttonCarouselController = CarouselController();
  int _current = 0;
  List<String> imgList = [];

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    late final user = FirebaseAuth.instance.currentUser;
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
                    nameUser: name == null ? "" : name!,
                    barberModel: barbershop!,
                  ),
                ));
          },
        ),
        title:
            dataPositionUser == null ? const Text('') : Text(dataPositionUser!),
        actions: [
          FirebaseAuth.instance.currentUser != null
              ? Center(
                  child: Text(name == null
                      ? ""
                      : name == ""
                          ? email.toString()
                          : "$name"))
              : TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Rount_CN.routeLogin);
                  },
                  child: Text(
                    "Login",
                    style: Contants().h3SpringGreen(),
                  ))
        ],
        backgroundColor: Contants.myBackgroundColordark,
      ),
      body: load == true
          ? Center(
              child: LoadingAnimationWidget.newtonCradle(
                  color: const Color.fromARGB(255, 111, 111, 240), size: 200),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  buttonChooseAType(size),
                  // sectionListview(size, "ร้านที่เคยใช้บริการ"),
                  // listStoreHistory(size),
                  urlImgLike.isNotEmpty
                      ? sectionListview(size, "ร้านที่ถูกใจ")
                      : const SizedBox(child: Text("")),
                  urlImgLike.isNotEmpty
                      ? listStoreLike(size)
                      : const SizedBox(
                          child: Text(""),
                        ),
                ],
              ),
            ),
    );
  }

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
                    nameUser: name == null ? "" : name!,
                    barberModel: barberLike[index],
                    url: urlImgLike[barberLike[index].email]!),
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

  // Container listStoreHistory(double size) {
  //   return Container(
  //     margin: const EdgeInsets.only(bottom: 20),
  //     height: 180,
  //     child: Expanded(
  //       flex: 3,
  //       child: ListView.builder(
  //           scrollDirection: Axis.horizontal,
  //           itemCount: 20,
  //           itemBuilder: (context, index) => BarberModel1(
  //                 size: size,
  //                 nameBarber: "ชื่อร้าน",
  //                 img:
  //                     "https://images.ctfassets.net/81iqaqpfd8fy/3r4flvP8Z26WmkMwAEWEco/870554ed7577541c5f3bc04942a47b95/78745131.jpg?w=1200&h=1200&fm=jpg&fit=fill",
  //               )),
  //     ),
  //   );
  // }

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
                List<BarberModel> barberman = [];
                for (var n = 0; n < barbershop!.length; n++) {
                  if (barbershop![n].typebarber == "man") {
                    barberman.add(barbershop![n]);
                  }
                }
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BarberSerchUser(
                              nameUser: name == null ? "" : name!,
                              typeBarber: true,
                              barbershop: barberman,
                              lat: lat,
                              lon: lng,
                              stream2: streamController2.stream,
                            )));
              },
              child: Text(
                "ตัดผมชาย ",
                style: Contants().h2OxfordBlue(),
              ),
              style: ElevatedButton.styleFrom(primary: Contants.colorWhite),
            ),
            width: size * 0.4,
            height: 40,
          ),
          SizedBox(
            child: ElevatedButton(
              onPressed: () {
                List<BarberModel> barberwoman = [];
                for (var n = 0; n < barbershop!.length; n++) {
                  if (barbershop![n].typebarber == "woman") {
                    barberwoman.add(barbershop![n]);
                  }
                }
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BarberSerchUser(
                              nameUser: name == null ? "" : name!,
                              typeBarber: false,
                              barbershop: barberwoman,
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
