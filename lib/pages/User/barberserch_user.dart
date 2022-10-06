import 'dart:collection';
import 'package:barber/Constant/contants.dart';
import 'package:barber/data/sqlite_model.dart';
import 'package:barber/main.dart';
import 'package:barber/pages/User/barber_user.dart';
import 'package:barber/pages/User/haircut_user.dart';
import 'package:barber/utils/sqlite_helper.dart';
import 'package:barber/widgets/barbermodel2.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:barber/data/barbermodel.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../widgets/barbermodel1.dart';

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
      typeBarber: typeBarber,
      lat: lat,
      lon: lon,
      nameUser: nameUser);
}

class _BarberSerchUserState extends State<BarberSerchUser> {
  bool typeBarber;
  String nameUser;
  double? lat, lon;
  _BarberSerchUserState(
      {required this.typeBarber,
      this.lat,
      this.lon,
      required this.nameUser});
  List<BarberModel>? barberResult = [];
  Map<String, String>? urlImgFront;
  List<SQLiteModel> sqliteModels = [];
  @override
  void initState() {
    widget.stream2.listen((barberModel) {
      mySetState2();
    });
    // TODO: implement initState
    super.initState();
    // calculateLatLon(barbershop);
    getURL();
  }

  void mySetState2() {
    setState(() {
      barberLike;
    });
  }

  calculateLatLon(List<BarberModel> barber) {
    var mapBarber = SplayTreeMap<double, BarberModel>();
    if (lat != null && lon != null) {
      for (var n = 0; n < barber.length; n++) {
        double x, y, sum, sum2;
        x = lat! - double.parse(barber[n].lat);
        // print("$x *");
        x = x.abs();
        y = lon! - double.parse(barber[n].lng);
        // print("$y *");
        y = y.abs();
        sum = x + y;
        // print("$n x=$x y=$y sum = $sum");
        sum2 = sum;
        mapBarber[sum] = barber[n];
      }
      mapBarber.forEach((key, val) {
        // print('{ key: $key, value: $val}');
        barberResult!.add(val);
      });
    } else {
      print("ไม่สามารถเข้าถึงlocation ของผู้ใช้ได้");
    }
  }

  Future<Null> getURL() async {
    Map<String, String>? urlImgFrontModel = {};
    for (var i = 0; i < barberResult!.length; i++) {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child("imgfront/${barberResult![i].email}");
      var url = await ref.getDownloadURL().then((value) {
        urlImgFrontModel[barberResult![i].email] = value;
        print("${barberResult![i].email} ===>> $value");
      }).catchError((c) => print(c + "is an error"));
    }
    setState(() {
      urlImgFront = urlImgFrontModel;
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
              urlImgFront == null
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16.0,
                                mainAxisSpacing: 5,
                                childAspectRatio: 0.82),
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              BarberModel2(
                                  nameUser: nameUser,
                                  barberModel: barberResult![index],
                                  url: urlImgFront![
                                      barberResult![index].email]!),
                              Center(
                                child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 100, top: 50),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.favorite,
                                        color: barberLike
                                                .contains(barberResult![index])
                                            ? Colors.red
                                            : Colors.white,
                                      ),
                                      onPressed: () async {
                                        if (barberLike.contains(
                                                barberResult![index]) ==
                                            false) {
                                          SQLiteModel sqLiteModel = SQLiteModel(
                                              email:
                                                  barberResult![index].email);
                                          await SQLiteHelper()
                                              .insertValueToSQlite(sqLiteModel);
                                          // print(barberResult![index].email);
                                          setState(() {
                                            // barberResult![index].like = true;
                                            barberLike
                                                .add(barberResult![index]);
                                            urlImgLike.addAll({
                                              barberResult![index].email:
                                                  urlImgFront![
                                                      barberResult![index]
                                                          .email]!
                                            });
                                          });
                                          streamController2
                                              .add(barberResult![index]);
                                        } else {
                                          await SQLiteHelper()
                                              .deleteSQLiteWhereId(
                                                  barberResult![index].email);
                                          setState(() {
                                            barberLike
                                                .remove(barberResult![index]);
                                            urlImgLike.remove(
                                                barberResult![index].email);
                                          });
                                          streamController2
                                              .add(barberResult![index]);
                                        }
                                      },
                                    )),
                              ),
                            ],
                          );
                        },
                        itemCount: barberResult!.length,
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

  // Container listStoreHistory(double size) {
  //   return Container(
  //     margin: const EdgeInsets.only(bottom: 20),
  //     height: 140,
  //     child: Expanded(
  //       flex: 3,
  //       child: ListView.builder(
  //         scrollDirection: Axis.horizontal,
  //         itemCount: 20,
  //         itemBuilder: (context, index) => BarberModel1(
  //           nameUser: nameUser,
  //           size: size,
  //           nameBarber: "ชื่อร้าน",
  //           img:
  //               "https://images.ctfassets.net/81iqaqpfd8fy/3r4flvP8Z26WmkMwAEWEco/870554ed7577541c5f3bc04942a47b95/78745131.jpg?w=1200&h=1200&fm=jpg&fit=fill",
  //           score: "4",
  //           addressdetails: '',
  //           dayopen: barberResult![0].dayopen,
  //           lat: '',
  //           lon: '',
  //           phoneNumber: '',
  //           recommend: '',
  //           timeclose: '',
  //           timeopen: '',
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
