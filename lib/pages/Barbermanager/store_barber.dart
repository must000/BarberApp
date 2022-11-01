import 'dart:io';

import 'package:barber/Constant/contants.dart';
import 'package:barber/main.dart';
import 'package:barber/pages/Barbermanager/drawerobject.dart';
import 'package:barber/utils/dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class StoreBarber extends StatefulWidget {
  const StoreBarber({
    Key? key,
  }) : super(key: key);

  @override
  State<StoreBarber> createState() => _StoreBarberState();
}

class _StoreBarberState extends State<StoreBarber> {
  TextEditingController recommendController = TextEditingController();
  TextEditingController shopNameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  bool change = false;
  CollectionReference users = FirebaseFirestore.instance.collection('Barber');
  File? photoShopFront;
  final ImagePicker imgpicker = ImagePicker();
  String? groupTypeBarber;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setdata();
  }

  setdata() {
    recommendController.text = barberModelformanager!.shoprecommend;
    shopNameController.text = barberModelformanager!.shopname;
    groupTypeBarber = barberModelformanager!.typebarber;
    nameController.text = barberModelformanager!.name;
    lastNameController.text = barberModelformanager!.lasiName;
  }

  Future<Null> deleteImg() async {
    final storageRef = FirebaseStorage.instance.ref();
    final desertRef =
        storageRef.child("imgfront/${barberModelformanager!.email}");
    await desertRef.delete().then((value) => debugPrint("delete succeed"));
  }

  Future<Null> normalDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  chooseImage(ImageSource.camera);
                  Navigator.pop(context);
                },
                child: const Icon(Icons.camera_alt),
              ),
              ElevatedButton(
                onPressed: () {
                  chooseImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.collections_outlined,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<Null> chooseImage(ImageSource source) async {
    try {
      // ignore: deprecated_member_use
      var result = await ImagePicker().getImage(
        source: source,
      );
      setState(() {
        photoShopFront = File(result!.path);
      });
    } catch (e) {}
  }

  Future<Null> uploadphoto(String email) async {
    final path = 'imgfront/$email';
    final file = File(photoShopFront!.path);
    final ref = FirebaseStorage.instance.ref().child(path);
    await ref.putFile(file).then((p0) async {
      await ref.getDownloadURL().then((value) async {
        print("url หน้าร้าน คือ $value");
        await FirebaseFirestore.instance
            .collection('Barber')
            .doc(email)
            .update({"url": value}).then((values) {
          setState(() {
            barberModelformanager!.url = value;
            photoShopFront = null;
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: DrawerObject(),
      appBar: AppBar(
        backgroundColor: Contants.myBackgroundColordark,
      ),
      backgroundColor: Contants.myBackgroundColor,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: SingleChildScrollView(
          child: Column(
            children: [
              topicTitle("ผู้จัดการร้าน"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: size * 0.4,
                    child: TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "ชื่อ",
                        fillColor: Contants.colorWhite,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size * 0.4,
                    child: TextFormField(
                      controller: lastNameController,
                      decoration: InputDecoration(
                        labelText: "นามสกุล",
                        fillColor: Contants.colorWhite,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
              topicTitle("ข้อมูลร้าน"),
              showShopName(),
              showRecommend(),
              radiobuttonTypeBarber(),
              ElevatedButton(
                onPressed: () {
                  MyDialog(funcAction: fc)
                      .superDialog(context, "", "บันทึกข้อมูล");
                },
                child: Text(
                  "บันทึก",
                  style: Contants().h3OxfordBlue(),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Contants.colorYellow),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "รูปหน้าร้าน",
                style: Contants().h2white(),
              ),
              showimageFront(size),
              buttonChangeImgFront(context),
              photoShopFront == null
                  ? const SizedBox()
                  : buttonDeleteAndUpdateImgFront(),
              const SizedBox(
                height: 10,
              ),
              topicTitle("เวลาเปิดปิดร้าน"),
              buildSelectDaycloseButton(),
              topicTitle("ที่อยู่ร้าน")
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSelectDaycloseButton() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Container(
            child: ElevatedButton(
              onPressed: () {
              },
              child: const Text("จ"),
              style: ElevatedButton.styleFrom(
                primary:
                    barberModelformanager!.dayopen["mo"]? Contants.colorSpringGreen : Contants.colorRed,
                shape: const CircleBorder(),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: ElevatedButton(
              onPressed: () {
              },
              child: const Text("อ"),
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                primary:
                    barberModelformanager!.dayopen["tu"]? Contants.colorSpringGreen : Contants.colorRed,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: ElevatedButton(
              onPressed: () {
              },
              child: const Text("พ"),
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                primary:
                   barberModelformanager!.dayopen["we"]?  Contants.colorSpringGreen : Contants.colorRed,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: ElevatedButton(
              onPressed: () {
              },
              child: const Text("พฤ"),
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                primary:
                    barberModelformanager!.dayopen["th"]? Contants.colorSpringGreen : Contants.colorRed,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: ElevatedButton(
              onPressed: () {
              },
              child: const Text("ศ"),
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                primary:
                    barberModelformanager!.dayopen["fr"]? Contants.colorSpringGreen : Contants.colorRed,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: ElevatedButton(
              onPressed: () {
              },
              child: const Text("ส"),
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                primary:
                    barberModelformanager!.dayopen["sa"]? Contants.colorSpringGreen : Contants.colorRed,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: ElevatedButton(
              onPressed: () {
              },
              child: const Text("อา"),
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                primary:
                    barberModelformanager!.dayopen["su"]? Contants.colorSpringGreen : Contants.colorRed,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void fc() {
    FocusScope.of(context).requestFocus(FocusNode());
    insertdata();
  }

  Future<Null> insertdata() async {
    await FirebaseFirestore.instance
        .collection("Barber")
        .doc(barberModelformanager!.email)
        .update({
      "name": nameController.text,
      "lastname": lastNameController.text,
      "shopname": shopNameController.text,
      "shoprecommend": recommendController.text,
      "typeBarber": groupTypeBarber
    }).then((value) {
      Navigator.pop(context);
      MyDialog().normalDialog(context, "บันทึกสำเร็จ");
      setState(() {
        barberModelformanager!.name = nameController.text;
        barberModelformanager!.lasiName = lastNameController.text;
        barberModelformanager!.shopname = shopNameController.text;
        barberModelformanager!.shoprecommend = recommendController.text;
        barberModelformanager!.typebarber = recommendController.text;
      });
    });
  }

  Container topicTitle(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Text(
            title,
            style: Contants().h3white(),
          ),
        ],
      ),
    );
  }

  Row radiobuttonTypeBarber() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              groupTypeBarber = "man";
            });
          },
          child: Text("ร้านตัดผมชาย", style: Contants().h3OxfordBlue()),
          style: ElevatedButton.styleFrom(
              primary: groupTypeBarber == "man"
                  ? Contants.colorSpringGreen
                  : Colors.grey,
              onPrimary: Colors.black),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              groupTypeBarber = "woman";
            });
          },
          child: Text(
            "ร้านเสริมสวย",
            style: Contants().h3OxfordBlue(),
          ),
          style: ElevatedButton.styleFrom(
              primary: groupTypeBarber == "woman"
                  ? Contants.colorSpringGreen
                  : Colors.grey,
              onPrimary: Colors.black),
        ),
      ],
    );
  }

  Row buttonDeleteAndUpdateImgFront() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
          ),
          onPressed: () {
            setState(() {
              photoShopFront = null;
            });
          },
          child: Text(
            "ลบรูปภาพ",
            style: Contants().h4white(),
          ),
        ),
        ElevatedButton(
            onPressed: () {
              deleteImg()
                  .then((value) => uploadphoto(barberModelformanager!.email));
            },
            child: Text(
              "อัพเดตรูปภาพ",
              style: Contants().h4white(),
            ))
      ],
    );
  }

  ElevatedButton buttonChangeImgFront(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          normalDialog(context);
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Contants.colorYellow),
        ),
        child: Text(
          "เปลี่ยนรูปภาพ",
          style: Contants().h3OxfordBlue(),
        ));
  }

  Container showimageFront(double size) {
    return Container(
      width: size * 0.7,
      margin: const EdgeInsets.only(top: 10),
      height: 180,
      decoration: BoxDecoration(border: Border.all()),
      child: photoShopFront != null
          ? Image.file(photoShopFront!)
          : CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: barberModelformanager!.url,
              placeholder: (context, url) => SizedBox(
                child: LoadingAnimationWidget.waveDots(
                    color: Contants.colorSpringGreen, size: 15),
                width: size * 0.3,
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
    );
  }

  Widget showRecommend() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: TextFormField(
        controller: recommendController,
        maxLines: 4,
        onChanged: (value) {
          setState(() {
            change = true;
          });
        },
        decoration: InputDecoration(
          labelText: "คำแนะนำร้าน",
          fillColor: Contants.colorWhite,
          labelStyle: Contants().h3yellow(),
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Container showShopName() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: TextFormField(
        controller: shopNameController,
        decoration: InputDecoration(
          labelText: "ชื่อร้าน",
          labelStyle: Contants().h3yellow(),
          fillColor: Contants.colorWhite,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
