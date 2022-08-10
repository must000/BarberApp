import 'dart:collection';
import 'package:barber/pages/User/barber_user.dart';
import 'package:barber/widgets/barbermodel2.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:barber/data/barbermodel.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../widgets/barbermodel1.dart';

class BarberSerchUser extends StatefulWidget {
  final bool typeBarber;
  List<BarberModel> barbershop;
  double? lat, lon;
  String nameUser;
  BarberSerchUser(
      {Key? key,
      required this.typeBarber,
      required this.barbershop,
      this.lat,
      this.lon,
      required this.nameUser})
      : super(key: key);

  @override
  State<BarberSerchUser> createState() => _BarberSerchUserState(
      typeBarber: typeBarber,
      barbershop: barbershop,
      lat: lat,
      lon: lon,
      nameUser: nameUser);
}

class _BarberSerchUserState extends State<BarberSerchUser> {
  bool typeBarber;
  List<BarberModel> barbershop;
  String nameUser;
  double? lat, lon;
  _BarberSerchUserState(
      {required this.typeBarber,
      required this.barbershop,
      this.lat,
      this.lon,
      required this.nameUser});
  List<BarberModel>? barberResult = [];
  Map<String, String>? urlImgFront;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    calculateLatLon(barbershop);
    getURL();
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
      }).catchError((c) => print(c + "is an error"));
    }
    print("is an url $urlImgFrontModel");
    setState(() {
      urlImgFront = urlImgFrontModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          title: Text(typeBarber == true ? "ร้านตัดผมชาย" : "ร้านเสริมสวย"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              sectionListview(size, "ร้านยอดฮิต"),
              listStoreHistory(size),
              // sectionListview(size, "ร้านที่เคยใช้บริการ"),
              // listStoreHistory(size),
              // sectionListview(size, "ร้านที่ถูกใจ"),
              // listStoreLike(size),
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
                          return BarberModel2(
                              nameUser: nameUser,
                              barberModel: barberResult![index],
                              url: urlImgFront![barberResult![index].email]!);
                        },
                        itemCount: barberResult!.length,
                      ),
                    )
            ],
          ),
        ));
  }

  // Padding(
  //                             padding: const EdgeInsets.symmetric(
  //                                 vertical: 4, horizontal: 5),
  //                             child: Container(
  //                               decoration: BoxDecoration(border: Border.all()),
  //                               child: Column(
  //                                 children: [
  //                                   CachedNetworkImage(
  //                                     height: 60,
  //                                     fit: BoxFit.fill,
  //                                     imageUrl: urlImgFront![
  //                                         barberResult![index].email]!,
  //                                     placeholder: (context, url) =>
  //                                         LoadingAnimationWidget.inkDrop(
  //                                             color: Colors.black, size: 20),
  //                                   ),
  //                                   ListTile(
  //                                     title:
  //                                         Text(barberResult![index].shopname),
  //                                     subtitle: Text(
  //                                         barberResult![index].shoprecommend),
  //                                   ),
  //                                   Row(
  //                                     children: const [
  //                                       Text("คะแนน X "),
  //                                       Icon(Icons.star)
  //                                     ],
  //                                   )
  //                                 ],
  //                               ),
  //                             ),
  //                           ),

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

  Container listStoreLike(double size) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 140,
      child: Expanded(
        flex: 3,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 20,
            itemBuilder: (context, index) => BarberModel1(
                  nameUser: nameUser,
                  size: size,
                  nameBarber: "ร้านที่ถูกใจ",
                  addressdetails: '',
                  dayopen: barberResult![0].dayopen,
                  lat: '',
                  lon: '',
                  phoneNumber: '',
                  recommend: '',
                  timeclose: '',
                  timeopen: '',
                )),
      ),
    );
  }

  Container listStoreHistory(double size) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 140,
      child: Expanded(
        flex: 3,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 20,
          itemBuilder: (context, index) => BarberModel1(
            nameUser: nameUser,
            size: size,
            nameBarber: "ชื่อร้าน",
            img:
                "https://images.ctfassets.net/81iqaqpfd8fy/3r4flvP8Z26WmkMwAEWEco/870554ed7577541c5f3bc04942a47b95/78745131.jpg?w=1200&h=1200&fm=jpg&fit=fill",
            score: "4",
            addressdetails: '',
            dayopen: barberResult![0].dayopen,
            lat: '',
            lon: '',
            phoneNumber: '',
            recommend: '',
            timeclose: '',
            timeopen: '',
          ),
        ),
      ),
    );
  }
}
