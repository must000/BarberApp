import 'dart:io';
import 'dart:typed_data';

import 'package:barber/data/hairdressermodel.dart';
import 'package:barber/main.dart';
import 'package:barber/pages/Barbermanager/drawerobject.dart';
import 'package:barber/pages/Barbermanager/scan_qrcode.dart';
import 'package:barber/utils/dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:barber/Constant/contants.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:scan/scan.dart';

class MemberBarberPage extends StatefulWidget {
  MemberBarberPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MemberBarberPage> createState() => _MemberBarberPageState();
}

class _MemberBarberPageState extends State<MemberBarberPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMember();
  }

  TextEditingController idCodeController = TextEditingController();
  List<HairdresserModel> member = [];
  Map<String, String> urlImageMember = {};
  bool load = false;
  Future<void> getMember() async {
    load = true;
    FirebaseFirestore.instance
        .collection('Hairdresser')
        .where("barberState", isEqualTo: barberModelformanager!.email)
        .get()
        .then((value) {
      List<HairdresserModel> data = [];
      for (var i = 0; i < value.docs.length; i++) {
        data.add(HairdresserModel(
            hairdresserID: value.docs[i].id,
            email: value.docs[i]["email"],
            idCode: value.docs[i]["idCode"],
            name: value.docs[i]["name"],
            lastname: value.docs[i]["lastname"],
            serviceID: value.docs[i]["serviceID"],
            barberStatus: value.docs[i]["barberState"],
            phone: value.docs[i]["phone"]));
      }
      print("1");
      getURL(data);
    });
  }

  Future<Null> getURL(List<HairdresserModel> data) async {
    Map<String, String>? urlimg = {};
    print("2");
    for (var i = 0; i < data.length; i++) {
      print("3");
      Reference ref =
          FirebaseStorage.instance.ref().child("avatar/${data[i].email}");
      print("4");
      var url = await ref.getDownloadURL().then((value) {
        print("5");
        urlimg[data[i].email] = value;
        print("6");
      }).catchError((c) => print(c + "is an error"));
    }

    setState(() {
      print("7");
      member = data;
      urlImageMember = urlimg;
      load = false;
    });
  }

  Future<Null> searchIDHairresser() async {
    if (idCodeController.text == "") {
      MyDialog().normalDialog(context, "ยังไม่ได้ใส่ข้อมูลไอดีโค้ด");
    } else {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (conttext) => SimpleDialog(
                children: [
                  LoadingAnimationWidget.threeArchedCircle(
                      color: Contants.colorSpringGreen, size: 50)
                ],
              ));
      FirebaseFirestore.instance
          .collection('Hairdresser')
          .where("idCode", isEqualTo: idCodeController.text)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          if (value.docs[0]["barberState"] != "no") {
            //มีร้านที่สังกัดอยู่แล้ว
            Navigator.pop(context);
            MyDialog().normalDialog(
                context, "ช่างทำผมคนนี้ มีร้านทำผมที่สังกัดอยู่แล้ว");
          } else {
            Navigator.pop(context);
            MyDialog(
                funcAction: fc(
              value.docs[0].id,
              value.docs[0]["email"],
              value.docs[0]["idCode"],
              value.docs[0]["name"],
              value.docs[0]["lastname"],
              value.docs[0]["serviceID"],
              value.docs[0]["phone"],
            )).addHairresserDialog(
                context,
                idCodeController.text,
                "${value.docs[0]["name"]} ${value.docs[0]["lastname"]}",
                value.docs[0]["phone"],
                value.docs[0]["email"]);
          }
        } else {
          Navigator.pop(context);
          MyDialog().normalDialog(context, "ไม่เจอช่างทำผม");
        }
      });
    }
  }

  fc(String docid, String email, String idCode, String name, String lastname,
      String serviceID, String phone) async {
    print("เพิ่มมมม");
    await FirebaseFirestore.instance
        .collection('Hairdresser')
        .doc(docid)
        .update({"barberState": barberModelformanager!.email});
    await FirebaseFirestore.instance
        .collection('Barber')
        .doc(barberModelformanager!.email)
        .collection("hairdresserMember")
        .add({"hairdresserID": docid});
    print("เพิ่มแล้ว");
    getMember();
  }

  Future<void> removeMember(String name, String docid) async {
    MyDialog(funcAction: fc2(docid)).superDialog(
        context, "คุณต้องการจะลบช่างทำผมคนนี้ออกจากร้านหรือไม่ ?", "ลบ $name");
  }

  fc2(String docid) async {
    // member[0].
    await FirebaseFirestore.instance
        .collection('Hairdresser')
        .doc(docid)
        .update({"barberState": "no"});
    await FirebaseFirestore.instance
        .collection('Barber')
        .doc(barberModelformanager!.email)
        .collection("hairdresserMember")
        .where("hairdresserID", isEqualTo: docid)
        .get()
        .then((value) async {
      await FirebaseFirestore.instance
          .collection('Barber')
          .doc(barberModelformanager!.email)
          .collection("hairdresserMember")
          .doc(value.docs[0].id)
          .delete()
          .then((value) {
        getMember();
      });
    });
  }

  String idClick = "";
  bool openscan = false;
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Contants.myBackgroundColordark,
        ),
        backgroundColor: Contants.myBackgroundColor,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(
            FocusNode(),
          ), //กดที่หน้าจอ แล้วคีย์อบร์ดดรอปลง
          behavior: HitTestBehavior.opaque,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ScanQRdoe(),
                          ));
                      setState(() {
                        idCodeController.text = result;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      primary: Contants.colorWhite,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.qr_code_scanner,
                          color: Contants.colorSpringGreen,
                        ),
                        Text(
                          "สแกน QR code",
                          style: Contants().h3OxfordBlue(),
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "ช่างทำผมของร้าน",
                  style: Contants().h2white(),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: size * 0.7,
                        child: TextFormField(
                          style: Contants().h4white(),
                          controller: idCodeController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            fillColor: Contants.colorOxfordBlue,
                            filled: true,
                            hintText: "code",
                            hintStyle: Contants().h4Grey(),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Contants.colorGreySilver),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Contants.colorSpringGreen),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                        ),
                      ),
                      Container(
                          width: size * 0.2,
                          child: ElevatedButton(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.person_add,
                                  color: Contants.colorOxfordBlue,
                                ),
                                Text(
                                  "เพิ่ม",
                                  style: Contants().h3OxfordBlue(),
                                ),
                              ],
                            ),
                            onPressed: () {
                              searchIDHairresser();
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              primary: Contants.colorSpringGreen,
                            ),
                          ))
                    ],
                  ),
                ),
                load
                    ? LoadingAnimationWidget.waveDots(
                        color: Contants.colorSpringGreen, size:60)
                    : member.isEmpty
                        ? Container(
                            margin: const EdgeInsets.only(top: 30),
                            child: Text(
                              "ไม่มีช่างทำผมภายในร้าน",
                              style: Contants().h3white(),
                            ),
                          )
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                if (idClick == member[index].hairdresserID) {
                                  setState(() {
                                    idClick = "";
                                  });
                                } else {
                                  setState(() {
                                    idClick = member[index].hairdresserID;
                                  });
                                }
                              },
                              child: idClick == member[index].hairdresserID
                                  ? Card(
                                      child: ListTile(
                                        leading: CachedNetworkImage(
                                            imageUrl: urlImageMember[
                                                member[index].email]!,
                                            placeholder: (context, url) =>
                                                CircularProgressIndicator()),
                                        title: Text(
                                          "${member[index].name} ${member[index].lastname}",
                                          style: Contants().h3OxfordBlue(),
                                        ),
                                        subtitle: Flexible(
                                          child: ListView(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            children: [
                                              Text(
                                                "อีเมล : ${member[index].email} ",
                                                style: Contants().h4Grey(),
                                              ),
                                              Text(
                                                "เบอร์โทร ${member[index].phone} ",
                                                style: Contants().h4Grey(),
                                              ),
                                              Text(
                                                "รหัสเชิญ ${member[index].idCode} ",
                                                style: Contants().h4Grey(),
                                              ),
                                            ],
                                          ),
                                        ),
                                        trailing: IconButton(
                                            icon: Icon(
                                              Icons.person_remove,
                                              color: Contants.colorRed,
                                            ),
                                            onPressed: () {
                                              removeMember(member[index].name,
                                                  member[index].hairdresserID);
                                            }),
                                      ),
                                    )
                                  : Card(
                                      child: ListTile(
                                        leading: CachedNetworkImage(
                                            imageUrl: urlImageMember[
                                                member[index].email]!,
                                            placeholder: (context, url) =>
                                                LoadingAnimationWidget.staggeredDotsWave(color: Contants.colorSpringGreen,size: 30),),
                                        title: Text(
                                          "${member[index].name} ${member[index].lastname}",
                                          style: Contants().h3OxfordBlue(),
                                        ),
                                        trailing: IconButton(
                                            icon: Icon(
                                              Icons.person_remove,
                                              color: Contants.colorRed,
                                            ),
                                            onPressed: () {
                                              removeMember(member[index].name,
                                                  member[index].hairdresserID);
                                            }),
                                      ),
                                    ),
                            ),
                            itemCount: member.length,
                          ),
              ],
            ),
          ),
        ),
        drawer: DrawerObject());
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        idCodeController.text = result!.code!;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
