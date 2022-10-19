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
  Map<String, String>? urlImgFront;
  List<SQLiteModel> sqliteModels = [];
  @override
  void initState() {
    widget.stream2.listen((barberModel) {
      mySetState2();
    });
    // TODO: implement initState
    super.initState();
    // getDataBarber();
    print("${geoHasher.encode(lon!, lat!)} $lat $lon ");
   
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
    citiesRef
        .where("typeBarber", isEqualTo: type)
        .where("lat", isGreaterThan: "13.9")
        .where("lat", isLessThan: "14.0")
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        for (var i = 0; i < value.docs.length; i++) {
          print(value.docs[i]["email"]);
        }
      } else {
        print("ไม่เจอส้นตีนอะไรเลย");
      }
    });
  }

  //  .orderBy("lat",)
  //     .orderBy("lon")
  //     .startAt(["13.9","13.9"])
  //     .endAt(["14.0","14.0"])
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
                                          setState(() {
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
}
