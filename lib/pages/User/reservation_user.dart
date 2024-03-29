import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:barber/Constant/contants.dart';
import 'package:barber/pages/User/reservation_detail_user.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ReservationUser extends StatefulWidget {
  String userID, nameUser;
  ReservationUser({Key? key, required this.userID, required this.nameUser})
      : super(key: key);

  @override
  State<ReservationUser> createState() =>
      _ReservationUserState(userID: userID, nameUser: nameUser);
}

class _ReservationUserState extends State<ReservationUser> {
  String? userID, nameUser;
  _ReservationUserState({required this.userID, required this.nameUser});
  int indexTab = 0;
  Map<String, String> listImageUrl = {};
  bool load = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdataImage();
  }

  Future<Null> getdataImage() async {
    var data = await FirebaseFirestore.instance
        .collection('Queue')
        .where("user.id", isEqualTo: userID)
        .get();
    var alldata = data.docs.map((e) => e.data()).toList();
    if (alldata.isNotEmpty) {
      List<String> list = [];
      if (alldata.isNotEmpty) {
        for (int i = 0; i < alldata.length; i++) {
          list.add(alldata[i]["barber"]["id"]);
        }
        Map<String, String> listurl = {};
        for (var i = 0; i < list.length; i++) {
          Reference ref =
              FirebaseStorage.instance.ref().child("imgfront/${list[i]}");
          await ref.getDownloadURL().then((value) {
            listurl[list[i]] = value;
          }).catchError((c) => print(c + "is an error getURL $c"));
        }
        setState(() {
          listImageUrl = listurl;
          load = false;
        });
      }
    } else {
      setState(() {
        load = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Contants.myBackgroundColor,
        appBar: AppBar(
          title: Center(
              child: Text(
            "การจองของคุณ",
            textAlign: TextAlign.center,
            style: Contants().h1white(),
          )),
          backgroundColor: Contants.myBackgroundColordark,
        ),
        body: userID == ""
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.login_rounded,
                    size: 30,
                    color: Contants.colorSpringGreen,
                  ),
                  Text(
                    "ยังไม่ได้เข้าสู่ระบบ",
                    style: Contants().h2white(),
                  ),
                ],
              ))
            : load
                ? Center(
                    child: LoadingAnimationWidget.waveDots(
                        size: 40, color: Contants.colorSpringGreen),
                  )
                : Column(
                    children: [
                      Row(
                        children: [
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  indexTab = 0;
                                });
                              },
                              child: Text(
                                "กำลังดำเนินการ",
                                style: indexTab == 0
                                    ? Contants().h3SpringGreen()
                                    : Contants().h3white(),
                              )),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  indexTab = 1;
                                });
                              },
                              child: Text(
                                "สำเร็จ",
                                style: indexTab == 1
                                    ? Contants().h3SpringGreen()
                                    : Contants().h3white(),
                              )),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  indexTab = 2;
                                });
                              },
                              child: Text(
                                "ยกเลิก",
                                style: indexTab == 2
                                    ? Contants().h3SpringGreen()
                                    : Contants().h3white(),
                              )),
                        ],
                      ),
                      Flexible(
                        child: ListView(
                          children: [
                            buildReservation(indexTab),
                          ],
                        ),
                      ),
                    ],
                  ));
  }

  Widget buildReservation(int index) {
    String status;
    switch (index) {
      case 0:
        status = "on";
        break;
      case 1:
        status = "succeed";
        break;
      default:
        status = "cancel";
    }
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Queue')
            .where("user.id", isEqualTo: userID)
            .where("status", isEqualTo: status)
            .orderBy("time.timestart")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data.docs;
            if (data.isNotEmpty) {
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  double sum = 0;
                  for (var i = 0; i < data[index]["service"].length; i++) {
                    sum += data[index]["service"][i]["price"];
                  }
                  return InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReservationDetailUser(
                          docID: data[index].id,
                          urlimg:
                              listImageUrl[data[index]["barber"]["id"]] == null
                                  ? ""
                                  : listImageUrl[data[index]["barber"]["id"]]!,
                          namebarber: data[index]["barber"]["name"],
                          nameHairresser: data[index]["hairdresser"]["name"],
                          timestart:
                              "${DateTime.parse(data[index]["time"]["timestart"]).hour.toString().padLeft(2, "0")}.${DateTime.parse(data[index]["time"]["timestart"]).minute.toString().padLeft(2, "0")}",
                          timeend:
                              "${DateTime.parse(data[index]["time"]["timeend"]).hour.toString().padLeft(2, "0")}.${DateTime.parse(data[index]["time"]["timeend"]).minute.toString().padLeft(2, "0")}",
                          service: data[index]["service"],
                          nameUser: nameUser!,
                          phoneBarber: data[index]["barber"]["phone"],
                          phoneHairresser: data[index]["hairdresser"]["phone"],
                          emailBarber: data[index]["barber"]["id"],
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 2),
                      child: Card(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: ListTile(
                          leading: CachedNetworkImage(
                            imageUrl: listImageUrl[data[index]["barber"]
                                        ["id"]] ==
                                    null
                                ? ""
                                : listImageUrl[data[index]["barber"]["id"]]!,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            imageBuilder: (context, imageProvider) => Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          title:
                              Text("ร้าน : ${data[index]["barber"]["name"]}"),
                          subtitle: Text(
                            "วันที่${DateTime.parse(data[index]["time"]["timestart"]).day.toString().padLeft(2, "0")}/${DateTime.parse(data[index]["time"]["timestart"]).month.toString().padLeft(2, "0")} \nเวลา${DateTime.parse(data[index]["time"]["timestart"]).hour.toString().padLeft(2, "0")}.${DateTime.parse(data[index]["time"]["timestart"]).minute.toString().padLeft(2, "0")} - ${DateTime.parse(data[index]["time"]["timeend"]).hour.toString().padLeft(2, "0")}.${DateTime.parse(data[index]["time"]["timeend"]).minute.toString().padLeft(2, "0")} น.",
                            style: Contants().h4Grey(),
                          ),
                          trailing: Text(
                            "฿ ${sum.toStringAsFixed(0)}",
                            style: Contants().h3Red(),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              String text = "";
              switch (status) {
                case "on":
                  text = "ขณะนี้ยังไม่มีคิวที่กำลังดำเนินการ";
                  break;
                case "succeed":
                  text = "ขณะนี้ยังไม่มีคิวที่สำเร็จ";
                  break;
                default:
                  text = "ขณะนี้ยังไม่มีคิวที่ยกเลิก";
              }
              return Center(
                  child: Container(
                      child: Text(
                        text,
                        style: Contants().h3white(),
                      ),
                      margin: const EdgeInsets.only(
                        top: 150,
                      )));
            }
          } else {
            return const Center(child: Text(""));
          }
        });
  }

  Future<String?> _geturl(String email) async {
    Reference ref = FirebaseStorage.instance.ref().child("imgfront/$email");
    await ref.getDownloadURL().then((valuee) {
      return valuee;
    }).onError((error, stackTrace) {
      return "https://karnlab.com/wp-content/uploads/2018/10/LOGO-EP20-Keroppi.jpg";
    }).catchError((e) =>
        "https://karnlab.com/wp-content/uploads/2018/10/LOGO-EP20-Keroppi.jpg");
    return null;
    // return "https://karnlab.com/wp-content/uploads/2018/10/LOGO-EP20-Keroppi.jpg";
  }
}
