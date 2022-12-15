import 'package:barber/pages/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:barber/Constant/contants.dart';
import 'package:barber/utils/dialog.dart';

class BarberHairdresser extends StatefulWidget {
  String barberState, idHairdresser;
  BarberHairdresser({
    Key? key,
    required this.barberState,
    required this.idHairdresser,
  }) : super(key: key);

  @override
  State<BarberHairdresser> createState() => _BarberHairdresserState(
      barberState: this.barberState, idHairdresser: this.idHairdresser);
}

class _BarberHairdresserState extends State<BarberHairdresser> {
  String barberState, idHairdresser;
  _BarberHairdresserState(
      {required this.barberState, required this.idHairdresser});
  String? barberImg;
  String nameBarber = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (barberState != "no") {
      getUrlImgBarber();
      getNameBarber();
    }
    print(idHairdresser);
  }

  Future<Null> getUrlImgBarber() async {
    Reference ref =
        FirebaseStorage.instance.ref().child("imgfront/$barberState");
    var url = await ref.getDownloadURL().then((value) {
      print("url");
      print(value);
      setState(() {
        barberImg = value;
      });
    }).catchError((c) => print(c + "is an error"));
  }

  Future<Null> getNameBarber() async {
    final data =
        FirebaseFirestore.instance.collection('Barber').doc(barberState);
    final snapshot = await data.get();
    if (snapshot.exists) {
      // print("snapshot ${snapshot.data()}");
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      setState(() {
        nameBarber = data["shopname"];
      });
    }
  }

  void fc() {
    String emailbarber = barberState;
    CollectionReference users =
        FirebaseFirestore.instance.collection('Hairdresser');
    users.doc(idHairdresser).update({"barberState": "no"}).then((value) {
      FirebaseFirestore.instance
          .collection('Barber')
          .doc(emailbarber)
          .collection('hairdresserMember')
          .where("hairdresserID", isEqualTo: idHairdresser)
          .get()
          .then((value) {
        print("ลาออกแล้ว");
        print(value.docs);
        // value.docs[0].reference.delete().then(
        //       (value) => MyDialog(funcAction: fc2).hardDialog(context, "", "ลาออกเรียบร้อย")
        //     );
        FirebaseFirestore.instance
            .collection('Barber')
            .doc(emailbarber)
            .collection('hairdresserMember')
            .doc(value.docs[0].id.toString())
            .delete()
            .then((value) {
          print("]dwdw");
          return MyDialog(funcAction: fc2)
              .hardDialogv2(context, "", "ลาออกเรียบร้อย");
        });
        print("ลบสำเร็จ");
      });
    }).catchError((x) => MyDialog().normalDialog(context, x));
  }

  void fc2() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => IndexPage(),
        ),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ร้านที่สังกัด",
          style: Contants().h2white(),
        ),
        backgroundColor: Contants.myBackgroundColordark,
      ),
      backgroundColor: Contants.myBackgroundColor,
      body: barberState == "no"
          ? const Center(
              child: Text("ยังไม่มีร้านที่สังกัด"),
            )
          : ListView(
              children: [
                barberImg == null 
                    ? const SizedBox()
                    : Container(
                        margin: EdgeInsets.all(size * 0.1),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 5),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: CachedNetworkImage(
                          imageUrl: barberImg!,
                          fit: BoxFit.cover,
                          imageBuilder: (context, imageProvider) => Container(
                            height: 200,
                            width: size * 0.7,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ),
                Center(
                    child: Text(
                  "ร้าน $nameBarber",
                  style: Contants().h2white(),
                )),
                const SizedBox(height: 30),
                Center(
                  child: SizedBox(
                    width: size * 0.6,
                    height: 50,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Contants.colorRed)),
                        onPressed: () {
                          MyDialog(funcAction: fc).superDialog(context,
                              "ระบบจะทำการลบคุณออกจากร้าน", "ลาออกจากร้าน ? ");
                        },
                        child: Text(
                          "ลงชื่อออกจากร้าน",
                          style: Contants().h2white(),
                        )),
                  ),
                )
              ],
            ),
    );
  }
}
