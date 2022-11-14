import 'dart:io';

import 'package:barber/Constant/contants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';

import 'package:barber/pages/index.dart';
import 'package:barber/utils/dialog.dart';

class SettingAccount extends StatefulWidget {
  bool typebarber;
  String name;
  String? lastname;
  String email;
  SettingAccount({
    Key? key,
    required this.typebarber,
    required this.name,
    this.lastname,
    required this.email,
  }) : super(key: key);

  @override
  State<SettingAccount> createState() => _SettingAccountState(
      email: email,
      typebarber: this.typebarber,
      name: name,
      lastname: lastname);
}

class _SettingAccountState extends State<SettingAccount> {
  String email;
  bool typebarber;
  String name;
  String? lastname;
  _SettingAccountState(
      {required this.email,
      required this.typebarber,
      required this.name,
      required this.lastname});
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (typebarber) {
      getAvartar();
      lastNameController.text = lastname!;
    }
    nameController.text = name;
  }

  final formKey = GlobalKey<FormState>();
  File? avertarIng;
  File? avatarOld;
  String? urlAvaterOld;
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  Future<Null> getAvartar() async {
    Reference ref = FirebaseStorage.instance.ref().child("avatar/$email");
    var url = await ref.getDownloadURL().then((value) {
      print(value);
      setState(() {
        urlAvaterOld = value;
      });
    }).catchError((c) => print(c + "is an error"));
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Contants.myBackgroundColor,
      appBar: AppBar(
        title: const Text("แก้ไขโปรไฟล์ "),
        backgroundColor: Contants.myBackgroundColordark,
      ),
      body: SingleChildScrollView(
          child: Form(
        key: formKey,
        child: Column(
          children: [
            typebarber ? const SizedBox() : title(size, "ชื่อ"),
            typebarber
                ? inputAvartar(size, context)
                : Container(
                    margin:
                        EdgeInsets.only(left: size * 0.08, right: size * 0.08),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "กรุณากรอกชื่อ";
                        } else {}
                      },
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      style: Contants().h4OxfordBlue(),
                      decoration: InputDecoration(
                        filled: true,
                        labelStyle: Contants().h2OxfordBlue(),
                        fillColor: Colors.white,
                        floatingLabelStyle: Contants().floatingLabelStyle(),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
            typebarber ? title(size, "ชื่อ") : const SizedBox(),
            typebarber
                ? Container(
                    margin: const EdgeInsets.only(),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "กรุณากรอกชื่อจริง";
                        } else {}
                      },
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      style: Contants().h4OxfordBlue(),
                      decoration: InputDecoration(
                        filled: true,
                        labelStyle: Contants().h2OxfordBlue(),
                        fillColor: Colors.white,
                        floatingLabelStyle: Contants().floatingLabelStyle(),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  )
                : const SizedBox(),
            typebarber ? title(size, "นามสกุล") : const SizedBox(),
            typebarber
                ? Container(
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "กรุณากรอกนามสกุล";
                        } else {}
                      },
                      controller: lastNameController,
                      keyboardType: TextInputType.name,
                      style: Contants().h4OxfordBlue(),
                      decoration: InputDecoration(
                        filled: true,
                        labelStyle: Contants().h2OxfordBlue(),
                        fillColor: Colors.white,
                        floatingLabelStyle: Contants().floatingLabelStyle(),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  )
                : const SizedBox(),
            Container(
              width: size * 0.5,
              margin: const EdgeInsets.only(top: 20),
              height: 50,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.white),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (avertarIng == null) {
                        //ไม่เปลี่ยนรูป
                        proceedUpdateNameData();
                      } else {
                        //เปลี่ยนรูป
                        proceedUpdateImgProfile()
                            .then((value) => proceedUpdateNameData());
                      }
                    }
                  },
                  child: Text(
                    "บันทึก",
                    style: Contants().h1OxfordBlue(),
                  )),
            )
          ],
        ),
      )),
    );
  }

  Container title(double size, String title) {
    return Container(
      margin: EdgeInsets.only(left: size * 0.08, right: size * 0.08),
      child: Row(
        children: [
          Text(
            title,
            style: Contants().h3white(),
          )
        ],
      ),
    );
  }

  proceedUpdateImgProfile() async {
    final storageRef = FirebaseStorage.instance.ref();
    final desertRef = storageRef.child("avatar/$email");
    await desertRef.delete().then((value) async {
      print("ลบแล้ว");
      final path = 'avatar/$email';
      final file = File(avertarIng!.path);
      final ref = FirebaseStorage.instance.ref().child(path);
      await ref.putFile(file).then((p0) => print("อัพโหลดสำเร็จ"));
    });
  }

  Future proceedUpdateNameData() async {
    final user = await FirebaseAuth.instance.currentUser;
    // user ธรรมด่า
    if (typebarber == false) {
      return user!
          .updateDisplayName(nameController.text)
          .then((value) => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => IndexPage(),
              ),
              (route) => false))
          .catchError((e) =>
              MyDialog().normalDialog(context, "เกิดข้อผิดพลาดขึ้น !! $e"));
    } else {
      var datadate = await FirebaseFirestore.instance
          .collection('Hairdresser')
          .where("email", isEqualTo: email)
          .get()
          .then((value) async {
        await FirebaseFirestore.instance
            .collection('Hairdresser')
            .doc(value.docs[0].id)
            .update({
          "name": nameController.text,
          "lastname": lastNameController.text
        }).then((value) => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => IndexPage(),
                ),
                (route) => false));
      });
    }
  }

  Stack inputAvartar(double size, BuildContext context) {
    return Stack(children: [
      Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black),
        ),
        child: urlAvaterOld != null
            ? CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: urlAvaterOld!,
                placeholder: (context, url) => SizedBox(
                  child: const CircularProgressIndicator(),
                  width: size * 0.3,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                imageBuilder: (context, imageProvider) => Container(
                  width: 200.0,
                  height: 200.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
              )
            : avertarIng == null
                ? const Icon(
                    Icons.account_circle,
                    size: 200,
                  )
                : Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black),
                    ),
                    child: ClipOval(
                      child: Image.file(
                        avertarIng!,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
      ),
      Container(
        alignment: Alignment.bottomRight,
        child: IconButton(
            onPressed: () {
              normalDialog(context);
            },
            icon: const Icon(
              Icons.add_circle,
              size: 50,
            )),
        height: 190,
        width: 190,
      )
    ]);
  }

  Future<Null> chooseImage(ImageSource source) async {
    try {
      // ignore: deprecated_member_use
      var result = await ImagePicker().getImage(
        source: source,
      );
      setState(() {
        urlAvaterOld = null;
        avertarIng = File(result!.path);
      });
    } catch (e) {}
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
}
