import 'package:barber/Constant/contants.dart';
import 'package:barber/data/sqlite_model.dart';
import 'package:barber/main.dart';
import 'package:barber/utils/sqlite_helper.dart';
import 'package:barber/widgets/barbermodel2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_geohash/dart_geohash.dart';
import 'package:flutter/material.dart';
import 'package:barber/data/barbermodel.dart';

class BarberSerchUser extends StatefulWidget {
  final bool typeBarber;
  double? lat, lon;
  String nameUser;
  Stream<BarberModel> stream2;
  BarberSerchUser(
      {Key? key,
      required this.typeBarber,
      this.lat,
      this.lon,
      required this.nameUser,
      required this.stream2})
      : super(key: key);

  @override
  State<BarberSerchUser> createState() => _BarberSerchUserState(
      typeBarber: typeBarber, lat: lat, lon: lon, nameUser: nameUser);
}

class _BarberSerchUserState extends State<BarberSerchUser> {
  bool typeBarber;
  String nameUser;
  double? lat, lon;
  var geoHasher = GeoHasher();
  _BarberSerchUserState(
      {required this.typeBarber, this.lat, this.lon, required this.nameUser});
  List<BarberModel>? barberResult = [];
  List<BarberModel>? barber = [];
  Map<String, String>? urlImgFront;
  List<SQLiteModel> sqliteModels = [];
  @override
  void initState() {
    widget.stream2.listen((barberModel) {
      mySetState2();
    });
    // TODO: implement initState
    super.initState();
    getDataBarber().then((value) {
      setState(() {});
    });
  }

  Future<Null> getDataBarber() async {
    String type;
    if (typeBarber) {
      type = "man";
    } else {
      type = "woman";
    }
    final db = FirebaseFirestore.instance;
    final citiesRef = db.collection("Barber");
    // print("$geohashstart ${lon! - 0.03} ${lat! - 0.03}");
    // print("$geohashend ${lon! + 0.03} ${lat! + 0.03}");
    if (lat == null || lon == null) {
      // ไม่เปิดตำแหน่ง
      print("1");
      await citiesRef
          .where("typeBarber", isEqualTo: type)
          .limit(40)
          .get()
          .then((value) {
        print("2");
        if (value.docs.isNotEmpty) {
          for (var i = 0; i < value.docs.length; i++) {
            print("13");
            double average = 0;
            if (value.docs[i]["score"] != null) {
              average = value.docs[i]["score"]["num"] /
                  value.docs[i]["score"]["count"];
            } else {
              average = 0;
            }
            if (average.isNaN) {
              average = 0;
            }
            barberResult!.add(BarberModel(
                email: value.docs[i]["email"],
                name: value.docs[i]["name"],
                lasiName: value.docs[i]["lastname"],
                phone: value.docs[i]["phone"],
                typebarber: value.docs[i]["typeBarber"],
                shopname: value.docs[i]["shopname"],
                shoprecommend: value.docs[i]["shoprecommend"],
                dayopen: value.docs[i]["dayopen"],
                timeopen: value.docs[i]["timeopen"],
                timeclose: value.docs[i]["timeclose"],
                lat: value.docs[i]["position"]["lat"],
                lng: value.docs[i]["position"]["lng"],
                districtl: value.docs[i]["position"]["district"],
                subDistrict: value.docs[i]["position"]["subdistrict"],
                addressdetails: value.docs[i]["position"]["addressdetails"],
                url: value.docs[i]["url"],
                score: average,
                geoHasher: value.docs[i]["position"]["geohash"]));
          }
          setState(() {
            barber = barberResult;
          });
        } else {
        }
      });
    } else {
      print("3");
      // เปิดตำแหน่ง
      String geohashstart = geoHasher.encode(lon! - 0.02, lat! - 0.02);
      String geohashend = geoHasher.encode(lon! + 0.02, lat! + 0.02);
      print("ตำแหน่งเครื่องคือ ${geoHasher.encode(lon!,lat!).toString()}");
      await citiesRef
          .where("typeBarber", isEqualTo: type)
          .orderBy("position.geohash")
          .startAt([(geohashstart)])
          .endAt([(geohashend)])
          .limit(40)
          .get()
          .then((value) async {
            if (value.docs.isNotEmpty) {
              print("ร้านที่อยู่ไกล้");
              for (var i = 0; i < value.docs.length; i++) {
                double average = 0;
                if (value.docs[i]["score"] != null) {
                  average = value.docs[i]["score"]["num"] /
                      value.docs[i]["score"]["count"];
                } else {
                  average = 0;
                }
                if (average.isNaN) {
                  average = 0;
                }
                barberResult!.add(BarberModel(
                    email: value.docs[i]["email"],
                    name: value.docs[i]["name"],
                    lasiName: value.docs[i]["lastname"],
                    phone: value.docs[i]["phone"],
                    typebarber: value.docs[i]["typeBarber"],
                    shopname: value.docs[i]["shopname"],
                    shoprecommend: value.docs[i]["shoprecommend"],
                    dayopen: value.docs[i]["dayopen"],
                    timeopen: value.docs[i]["timeopen"],
                    timeclose: value.docs[i]["timeclose"],
                    lat: value.docs[i]["position"]["lat"],
                    lng: value.docs[i]["position"]["lng"],
                    districtl: value.docs[i]["position"]["district"],
                    subDistrict: value.docs[i]["position"]["subdistrict"],
                    addressdetails: value.docs[i]["position"]["addressdetails"],
                    url: value.docs[i]["url"],
                    score: average,
                    geoHasher: value.docs[i]["position"]["geohash"]));
                    print(value.docs[i]["email"]);
              }
            } else {
              print("ไม่มีร้านที่อยู่ไกล้");
              await citiesRef
                  .where("typeBarber", isEqualTo: type)
                  .limit(40)
                  .get()
                  .then((value) {
                for (var i = 0; i < value.docs.length; i++) {
                  double average = 0;
                  if (value.docs[i]["score"] != null) {
                    average = value.docs[i]["score"]["num"] /
                        value.docs[i]["score"]["count"];
                  } else {
                    average = 0;
                  }
                  if (average.isNaN) {
                    average = 0;
                  }
                  barberResult!.add(BarberModel(
                      email: value.docs[i]["email"],
                      name: value.docs[i]["name"],
                      lasiName: value.docs[i]["lastname"],
                      phone: value.docs[i]["phone"],
                      typebarber: value.docs[i]["typeBarber"],
                      shopname: value.docs[i]["shopname"],
                      shoprecommend: value.docs[i]["shoprecommend"],
                      dayopen: value.docs[i]["dayopen"],
                      timeopen: value.docs[i]["timeopen"],
                      timeclose: value.docs[i]["timeclose"],
                      lat: value.docs[i]["position"]["lat"],
                      lng: value.docs[i]["position"]["lng"],
                      districtl: value.docs[i]["position"]["district"],
                      subDistrict: value.docs[i]["position"]["subdistrict"],
                      addressdetails: value.docs[i]["position"]
                          ["addressdetails"],
                      url: value.docs[i]["url"],
                      score: average,
                      geoHasher: value.docs[i]["position"]["geohash"]));
                }
              });
            }
            setState(() {
              barber = barberResult;
            });
          });
    }
  }

  void mySetState2() {
    setState(() {
      barberLike;
    });
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Contants.myBackgroundColor,
        appBar: AppBar(
          backgroundColor: Contants.myBackgroundColordark,
          title: Text(typeBarber == true ? "ร้านตัดผมชาย" : "ร้านเสริมสวย"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // sectionListview(size, "ร้านยอดฮิต"),
              barber == []
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              BarberModel2(
                                  nameUser: nameUser,
                                  barberModel: barber![index],
                                  url: barber![index].url, score: barber![index].score, size: size,),
                              Center(
                                child: Container(
                                    margin:  EdgeInsets.only(
                                        left: size*0.7, top: 10),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.favorite,
                                        color:
                                            barberLike.contains(barber![index])
                                                ? Colors.red
                                                : Colors.white,
                                                size: 30,
                                      ),
                                      onPressed: () async {
                                        if (barberLike
                                                .contains(barber![index]) ==
                                            false) {
                                          SQLiteModel sqLiteModel = SQLiteModel(
                                              email: barber![index].email);
                                          await SQLiteHelper()
                                              .insertValueToSQlite(sqLiteModel);
                                          setState(() {
                                            barberLike.add(barber![index]);
                                          });
                                          streamController2.add(barber![index]);
                                        } else {
                                          await SQLiteHelper()
                                              .deleteSQLiteWhereId(
                                                  barber![index].email);
                                          setState(() {
                                            barberLike.remove(barber![index]);
                                          });
                                          streamController2.add(barber![index]);
                                        }
                                      },
                                    )),
                              ),
                            ],
                          );
                        },
                        itemCount: barber!.length,
                      ),
                    )
            ],
          ),
        ));
  }

  Container sectionListview(double size, String title) {
    return Container(
      child: Text(
        title,
        style: const TextStyle(fontSize: 20),
      ),
      width: size,
      padding: EdgeInsets.symmetric(horizontal: size * 0.1),
    );
  }
}
