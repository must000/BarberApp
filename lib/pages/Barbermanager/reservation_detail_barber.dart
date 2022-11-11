import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:barber/Constant/contants.dart';
import 'package:barber/main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../data/servicemodel.dart';

class ReservationDetailBarber extends StatefulWidget {
  String id;
  String time;
  ReservationDetailBarber({
    Key? key,
    required this.id,
    required this.time,
  }) : super(key: key);

  @override
  State<ReservationDetailBarber> createState() =>
      _ReservationDetailBarberState(id: id, time: time);
}

class _ReservationDetailBarberState extends State<ReservationDetailBarber> {
  String id;
  _ReservationDetailBarberState({required this.id, required this.time});
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDatawhereID();
  }

  String time;
  String nameShop = barberModelformanager!.shopname;

  String? nameHairresser;
  String? nameUser;
  String? phoneHairresser;
  String? phoneUser;
  List<ServiceModel> servicemodel = [];
  String? status;
  String? comment;
  int? score;

  Future<Null> getDatawhereID() async {
    await FirebaseFirestore.instance
        .collection('Queue')
        .doc(id)
        .snapshots()
        .listen((event) {
      List<ServiceModel> data = [];
      for (var i = 0; i < event["service"].length; i++) {
        data.add(ServiceModel(
            id: event["service"][i]["id"],
            name: event["service"][i]["name"],
            detail: event["service"][i]["detail"],
            time: event["service"][i]["time"],
            price: event["service"][i]["price"]));
      }
      setState(() {
        nameHairresser = event["hairdresser"]["name"];
        phoneHairresser = event["hairdresser"]["phone"];
        phoneUser = event["user"]["phone"];
        servicemodel = data;
        status = event["status"];
        nameUser = event["user"]["name"];
        if (event.data()!.containsKey("comment")) {
          comment = event["comment"]["message"];
          score = event["comment"]["score"];
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Contants.myBackgroundColor,
      appBar: AppBar(backgroundColor: Contants.myBackgroundColordark),
      body: nameHairresser == null
          ? Center(
              child: LoadingAnimationWidget.waveDots(
                  color: Contants.colorSpringGreen, size: size * 0.4),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListView(
                children: [
                  status == "succeed"? 
                    Text(
                    "สถานะ : สำเร็จ",
                    style: Contants().h2SpringGreen(),
                  ): status == "on"?  Text(
                    "สถานะ : รอ",
                    style: Contants().h2yellow(),): Text(
                    "สถานะ : ยกเลิก",
                    style: Contants().h2Red(),),
                  
                  Text(
                    "ร้าน : $nameShop",
                    style: Contants().h2white(),
                  ),
                  Text(
                    "เวลาที่ใช้บริการ : $time",
                    style: Contants().h3white(),
                  ),
                  Text(
                    "ช่างทำผม : $nameHairresser",
                    style: Contants().h3white(),
                  ),
                  Text(
                    "เบอร์โทร : $phoneHairresser",
                    style: Contants().h4white(),
                  ),
                  Text(
                    "ชื่อลูกค้า : $nameUser",
                    style: Contants().h4white(),
                  ),
                  phoneUser == ""?Text("") :
                  Text(
                    "เบอร์โทร : 0${phoneUser!.substring(2)}",
                    style: Contants().h4white(),
                  ),
                  Container(
                    
                    decoration: BoxDecoration(
                      border: Border.all(width: 1,color: Contants.colorYellow)
                    ),
                      margin: const EdgeInsets.only(top: 20,bottom: 20),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(children: [
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                );
                              },
                              itemCount: servicemodel.length,
                            ),
                          ),
                        ]),
                      )),
                  score == null
                      ? const SizedBox()
                      : Container(
                        decoration: BoxDecoration(border: Border.all(color: Contants.colorSpringGreen)),
                        child: ListTile(
                            title: Text(comment!,style: Contants().h4white(),),
                            leading: Icon(Icons.comment,color: Contants.colorSpringGreen,),
                            trailing: Wrap(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      score.toString(),
                                      style: Contants().h3yellow(),
                                    ),
                                  Icon(
                                      Icons.star,
                                      color: Contants.colorYellow,
                                      size: 30,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                      ),
                ],
              ),
            ),
    );
  }
}
