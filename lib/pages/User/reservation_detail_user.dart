import 'dart:developer';
import 'dart:ffi';

import 'package:barber/utils/dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:barber/Constant/contants.dart';
import 'package:barber/data/servicemodel.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ReservationDetailUser extends StatefulWidget {
  String urlimg, namebarber, nameUser,phoneBarber,phoneHairresser;
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
      required this.nameUser,required this.phoneBarber,required this.phoneHairresser})
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
        phoneBarber: phoneBarber,
        phoneHairresser: phoneHairresser
      );
}

class _ReservationDetailUserState extends State<ReservationDetailUser> {
  String urlimg, namebarber, nameUser,phoneBarber,phoneHairresser;
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
      required this.nameUser,required this.phoneBarber,required this.phoneHairresser});
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setservice();
    getdataRealtime();
    print(docID);
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
  bool haveComment = false;
  int score = 5;
  bool show = false;
  TextEditingController commentController = TextEditingController();
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
            if (event["comment"]["show"] == false) {
              haveComment = true;
              show =false;
              //สถานะ ไม่โชว์
            } else {
              comment = event["comment"]["message"];
              score = event["comment"]["score"];
              haveComment = true;
              show = true;
            }
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
              "ร้าน : $namebarber",
              style: Contants().h2white(),
            ),
            Text("เบอร์ร้าน : $phoneBarber",style: Contants().h3white(),),
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
            Text("เบอร์โทร : $phoneHairresser",style: Contants().h4white(),),
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
                            : haveComment
                                ? show
                                    ? Column(
                                        //มีคอมเม้น แสดงดาว คอมเม้นต์ ปุ่มลบคอมเม้นต์
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "คะแนนและรีวิว",
                                                style:
                                                    Contants().h2SpringGreen(),
                                              ),
                                            ],
                                          ),
                                          ListTile(
                                            title: Text(
                                              "$nameUser : ",
                                              style: Contants().h3white(),
                                            ),
                                            subtitle: Text(
                                              comment,
                                              style: Contants().h2white(),
                                            ),
                                            trailing: IconButton(
                                              onPressed: () {
                                                MyDialog(funcAction: fc)
                                                    .superDialog(
                                                        context,
                                                        "ลบคอมเมนต์",
                                                        "ความคิดเห็นและคะแนนของคุณจะถูกลบ");
                                              },
                                              icon: const Icon(
                                                Icons.delete_forever,
                                                color: Colors.red,
                                                size: 40,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Text(
                                        'คอมเมนต์ถูกลบแล้ว',
                                        style: Contants().h3Red(),
                                      )
                                : Column(
                                    //ไม่มีคอมเม้น แสดงช่องใส่คอมเม้นและช่องให้ดาว
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "คะแนนและรีวิว",
                                            style: Contants().h2SpringGreen(),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  score = 1;
                                                });
                                              },
                                              icon: Icon(
                                                Icons.star,
                                                color: score > 0
                                                    ? Colors.yellow
                                                    : Colors.grey,
                                                size: 40,
                                              )),
                                          IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  score = 2;
                                                });
                                              },
                                              icon: Icon(
                                                Icons.star,
                                                color: score > 1
                                                    ? Colors.yellow
                                                    : Colors.grey,
                                                size: 40,
                                              )),
                                          IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  score = 3;
                                                });
                                              },
                                              icon: Icon(
                                                Icons.star,
                                                color: score > 2
                                                    ? Colors.yellow
                                                    : Colors.grey,
                                                size: 40,
                                              )),
                                          IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  score = 4;
                                                });
                                              },
                                              icon: Icon(
                                                Icons.star,
                                                color: score > 3
                                                    ? Colors.yellow
                                                    : Colors.grey,
                                                size: 40,
                                              )),
                                          IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  score = 5;
                                                });
                                              },
                                              icon: Icon(
                                                Icons.star,
                                                color: score > 4
                                                    ? Colors.yellow
                                                    : Colors.grey,
                                                size: 40,
                                              ))
                                        ],
                                      ),
                                      ListTile(
                                        title: Text(
                                          "$nameUser : ",
                                          style: Contants().h2white(),
                                        ),
                                        subtitle: TextFormField(
                                          controller: commentController,
                                          maxLines: 2,
                                          style: Contants().h4OxfordBlue(),
                                          decoration: InputDecoration(
                                              filled: true,
                                              fillColor:
                                                  Contants.colorGreySilver,
                                              border: const OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  20),
                                                          topRight:
                                                              Radius.circular(
                                                                  20)))),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          print(
                                              "$score ${commentController.text}");
                                          insertComment();
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Contants.colorSpringGreen),
                                        ),
                                        child: Text(
                                          "ส่ง",
                                          style: Contants().h3white(),
                                        ),
                                      )
                                    ],
                                  )
              ]),
            )
          ],
        ),
      ),
    );
  }

  void fc() {
    deleteComment();
  }

  Future<Null> deleteComment() async {
    await FirebaseFirestore.instance.collection('Queue').doc(docID).update({
      "comment": {
         "message": comment,
        "score": score,
        "show": false,}
    }).then((value) => Navigator.pop(context));
  }

  Future<Null> insertComment() async {
    await FirebaseFirestore.instance.collection('Queue').doc(docID).set({
      "comment": {
        "message": commentController.text.toString(),
        "score": score,
        "show": true
      },
    }, SetOptions(merge: true));
  }
}
