import 'package:barber/data/barbermodel.dart';
import 'package:barber/data/sqlite_model.dart';
import 'package:barber/pages/search_user.dart';
import 'package:barber/utils/sqlite_helper.dart';
import 'package:barber/widgets/barbermodel2.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:barber/Constant/contants.dart';
import 'package:barber/pages/barberserch_user.dart';
import 'package:barber/pages/test.dart';
import 'package:barber/widgets/barbermodel1.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:intl/intl.dart';

import '../Constant/route_cn.dart';

class HairCutUser extends StatefulWidget {
  List<BarberModel> barbershop;
  HairCutUser({
    Key? key,
    required this.barbershop,
  }) : super(key: key);

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
  List<BarberModel> barbershopOpen = [];
  @override
  void initState() {
    super.initState();
    chechpermission();
    findNameAnEmail();
    getAdvert();
    processReadSQLite();
  }

  Future<Null> processReadSQLite() async {
    if (sqliteModels.isNotEmpty) {
      sqliteModels.clear();
    }

    await SQLiteHelper().readSQLite().then((value) {
      setState(() {
        sqliteModels = value;
        // findDetailSeller();
      });
    });
  }

  checkBarberOpen() {
    DateTime mydatetime = DateTime.now();
    String getnameday = DateFormat('EEEE').format(mydatetime);
    String nameday = "";
    DateTime timeopen;
    DateTime timeclose;

    // print("${mydatetime.toString()} 999999");
    // print("ชื่อวัน ${DateFormat('EEEE').format(mydatetime)}");
    switch (getnameday) {
      case "Sunday":
        nameday = "su";
        break;
      case "Monday":
        nameday = "mo";
        break;
      case "Tuesday":
        nameday = "tu";
        break;
      case "Wednesday":
        nameday = "we";
        break;
      case "Thursday":
        nameday = "th";
        break;
      case "Friday":
        nameday = "fr";
        break;
      case "Saturday":
        nameday = "sa";
        break;
      default:
    }
    for (var i = 0; i < barbershop!.length; i++) {
      // *** เช็คว่าวันที่ร้านนี้เปิด ตรงกับวันที่ ณ ตอนนี้ไหม
      if (barbershop![i].dayopen[nameday] == true) {
        timeopen = DateFormat('yyyyy-MM-dd HH:mm:ss').parse(
            '2020-04-03 ${barbershop![i].timeopen.replaceAll(' ', '')}:00');
        timeclose = DateFormat('yyyyy-MM-dd HH:mm:ss').parse(
            '2020-04-03 ${barbershop![i].timeopen.replaceAll(' ', '')}:00');
        mydatetime.isBefore(timeclose);
        barbershopOpen.add(barbershop![i]);
      }
    }

    for (var n = 0; n < barbershopOpen.length; n++) {
      print(">>>>>>> ${barbershopOpen[n]} ");
    }
  }

  Future<Null> getAdvert() async {
    final ListResult result =
        await FirebaseStorage.instance.ref().child('advert').list();
    final List<Reference> allFiles = result.items;
    print(allFiles.length);
    List<String> files = [];
    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();

      files.add(fileUrl);
      print(files);
    });
    setState(() {
      imgList = files;
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
        setState(() {
          name = event!.displayName!;
          email = event.email!;
          phone = event.phoneNumber;
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
                  child: const Text("Login"))
        ],
        backgroundColor: Colors.grey,
      ),
      body: load == true
          ? Center(
              child: LoadingAnimationWidget.newtonCradle(
                  color: const Color.fromARGB(255, 111, 111, 240), size: 200),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 200,
                        child: imgList == []
                            ? const Text("ไม่มีโฆษณา")
                            : CarouselSlider(
                                carouselController: buttonCarouselController,
                                items: imgList
                                    .map((item) => Container(
                                          child: Center(
                                              child: Image.network(item,
                                                  fit: BoxFit.cover,
                                                  width: 1000)),
                                        ))
                                    .toList(),
                                options: CarouselOptions(
                                    autoPlay: true,
                                    enlargeCenterPage: true,
                                    autoPlayInterval:
                                        const Duration(seconds: 3),
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        _current = index;
                                      });
                                    }),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 165),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: imgList.asMap().entries.map((entry) {
                            return GestureDetector(
                              onTap: () => buttonCarouselController
                                  .animateToPage(entry.key),
                              child: Container(
                                width: 12.0,
                                height: 12.0,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 4.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: (Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : Colors.black)
                                      .withOpacity(
                                          _current == entry.key ? 0.9 : 0.4),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () {
                        print(sqliteModels);
                      },
                      child: const Text("เทสส")),
                  buttonChooseAType(size),
                  sectionListview(size, "ร้านที่เคยใช้บริการ"),
                  // listStoreHistory(size),
                  sectionListview(size, "ร้านที่ถูกใจ"),
                  // listStoreLike(size),
                ],
              ),
            ),
    );
  }

  Container listStoreLike(double size) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 180,
      child: Expanded(
        flex: 3,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 20,
            itemBuilder: (context, index) => BarberModel2(
                  barberModel: barbershop![index],
                  url: "",
                  nameUser: name!,
                )),
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
        style: TextStyle(fontSize: 20),
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
                              )));
                },
                child: const Text("ร้านตัดผมชาย")),
            width: size * 0.4,
            height: 50,
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
                              )));
                },
                child: const Text("ร้านเสริมสวย")),
            width: size * 0.4,
            height: 50,
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
