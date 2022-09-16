import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:barber/Constant/contants.dart';
import 'package:barber/data/servicemodel.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ReservationDetailUser extends StatefulWidget {
  String urlimg, namebarber, nameUser;
  String nameHairresser;
  String timestart, timeend;
  String docID;
  List service;
  ReservationDetailUser(
      {Key? key,
      required this.urlimg,
      required this.namebarber,
      required this.nameHairresser,
      required this.timestart,
      required this.timeend,
      required this.docID,
      required this.service,
      required this.nameUser})
      : super(key: key);

  @override
  State<ReservationDetailUser> createState() => _ReservationDetailUserState(
        urlimg: urlimg,
        namebarber: namebarber,
        nameHairresser: nameHairresser,
        timeend: timeend,
        timestart: timestart,
        docID: docID,
        service: service,
        nameUser: nameUser,
      );
}

class _ReservationDetailUserState extends State<ReservationDetailUser> {
  String urlimg, namebarber, nameUser;
  String nameHairresser;
  String timestart, timeend;
  List service;
  String docID;
  _ReservationDetailUserState(
      {required this.urlimg,
      required this.namebarber,
      required this.nameHairresser,
      required this.timestart,
      required this.timeend,
      required this.docID,
      required this.service,
      required this.nameUser});
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setservice();
    getdataRealtime();
  }

  List<ServiceModel> servicemodel = [];
  setservice() {
    for (var i = 0; i < service.length; i++) {
      servicemodel.add(ServiceModel(
          id: service[i]["id"],
          name: service[i]["name"],
          detail: service[i]["detail"],
          time: service[i]["time"],
          price: service[i]["price"]));
    }
  }

  late String status = "wait";
  String comment = "";
  Future getdataRealtime() async {
    var data = await FirebaseFirestore.instance
        .collection('Queue')
        .doc(docID)
        .snapshots()
        .listen((event) {
      if (event.data()!.isNotEmpty) {
        if (event["status"] == "succeed") {
          if (event.data()!.containsKey("comment")) {
            // มีคอมเมนต์
            comment = event["comment"];
          } else {
            //ไม่มีคอมเมนต์

          }
        }
        setState(() {
          status = event["status"];
        });
      }
    });
  }

  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Contants.myBackgroundColor,
      appBar: AppBar(
        title: const Text("รายละเอียด"),
        backgroundColor: Contants.myBackgroundColordark,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            Text(
              "ชื่อ : $namebarber",
              style: Contants().h2white(),
            ),
            Container(
              height: 200,
              child: CachedNetworkImage(
                imageUrl: urlimg,
                placeholder: (context, url) => LoadingAnimationWidget.waveDots(
                    size: 10, color: Contants.colorSpringGreen),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            Text(
              "เวลาที่ใช้บริการ : $timestart - $timeend",
              style: Contants().h3white(),
            ),
            Text(
              "ช่างทำผม : $nameHairresser",
              style: Contants().h3white(),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Column(children: [
                const SizedBox(
                  height: 40,
                ),
                Row(
                  children: [
                    Text(
                      "บริการที่ได้รับ",
                      style: Contants().h3white(),
                    ),
                  ],
                ),
                Container(
                  width: size * 0.6,
                  child: ListView.builder(
                    shrinkWrap: true, //    <-- Set this to true
                    physics: const ScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Text(
                            servicemodel[index].name,
                            style: Contants().h4white(),
                          ),
                          Text(
                            ":  ${servicemodel[index].price} บาท",
                            style: Contants().h4white(),
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      );
                    },
                    itemCount: servicemodel.length,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                status == "wait"
                    ? const SizedBox()
                    : status == "on"
                        ? Text(
                            "อยู่ระหว่างดำเนินการ",
                            style: Contants().h2SpringGreen(),
                          )
                        : status == "cancel"
                            ? Text(
                                "ล้มเหลว / ยกเลิก",
                                style: Contants().h2Red(),
                              )
                            : Row(
                                children: [
                                  Text(
                                    "คะแนนและรีวิว",
                                    style: Contants().h2SpringGreen(),
                                  ),
                                ],
                              ),
                ListTile(
                  title: Text(
                    "ชื่อUser",
                    style: Contants().h3white(),
                  ),
                  subtitle: TextFormField(
                    maxLines: 2,
                  ),
                  trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.delete_outline_sharp,
                        color: Colors.red,
                      )),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
