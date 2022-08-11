import 'dart:io';

import 'package:barber/pages/index.dart';
import 'package:barber/utils/dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SettingAccountUser extends StatefulWidget {
  String? username;
  String email;
  bool typebarber;
  SettingAccountUser({
    Key? key,
    this.username,
    required this.email,
    required this.typebarber,
  }) : super(key: key);

  @override
  State<SettingAccountUser> createState() => _SettingAccountUserState(
      username: this.username, email: email, typebarber: this.typebarber);
}

class _SettingAccountUserState extends State<SettingAccountUser> {
  TextEditingController nameController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  File? avertarIng;
  File? avatarOld;
  String? urlAvaterOld;
  String email;
  String? username;
  bool typebarber;
  _SettingAccountUserState(
      {this.username, required this.email, required this.typebarber});
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (typebarber) {
      getAvartar();
    }
  }

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
    if (username != null) {
      nameController.text = username!;
    }

    double size = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                typebarber
                    ? inputAvartar(size, context)
                    : Container(
                        margin: EdgeInsets.only(
                            top: 15, left: size * 0.08, right: size * 0.08),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "กรุณากรอกชื่อ";
                            } else {}
                          },
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: "Name",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                Container(
                  margin: EdgeInsets.only(
                      top: 15, left: size * 0.08, right: size * 0.08),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "กรุณากรอกรหัสผ่านเดิม";
                      } else {}
                    },
                    controller: oldPasswordController,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      labelText: "Old password",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: 15, left: size * 0.08, right: size * 0.08),
                  child: TextFormField(
                    controller: newPasswordController,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      labelText: "New password",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: 15, left: size * 0.08, right: size * 0.08),
                  child: TextFormField(
                    validator: (value) {
                      if (value != newPasswordController.text) {
                        return "กรุณากรอกคอนเฟิร์มรหัสผ่านให้ตรงกับรหัสผ่านใหม่";
                      }
                    },
                    controller: confirmNewPasswordController,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      labelText: "Confirm password",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        print(email);
                        print(oldPasswordController.text);
                        proceedUpdateProfile();
                      }
                    },
                    child: const Text("บันทึก"))
              ],
            ),
          ),
        ));
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
                    child: Image.file(
                      avertarIng!,
                      fit: BoxFit.fill,
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

  proceedUpdateProfile() async {
    final user = await FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(
        email: email, password: oldPasswordController.text);
    user!.reauthenticateWithCredential(cred).then((value) async {
      if (newPasswordController.text.isNotEmpty) {
        // user ธรรมด่า
        if (typebarber == false) {
          return user.updateDisplayName(nameController.text).then((value) =>
              user.updatePassword(newPasswordController.text).then((value) {
                FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: email, password: newPasswordController.text)
                    .then((value) => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IndexPage(),
                        ),
                        (route) => false))
                    .catchError((e) => MyDialog()
                        .normalDialog(context, "เกิดข้อผิดพลาดขึ้น !! $e"));
              }));
        }
        // ช่างทำผม

        return user.updatePassword(newPasswordController.text).then((value) =>
            FirebaseAuth.instance
                .signInWithEmailAndPassword(
                    email: email, password: newPasswordController.text)
                .then((value) => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IndexPage(),
                    ),
                    (route) => false))
                .catchError((e) =>
                    MyDialog().normalDialog(context, "เกิดข้อผิดพลาดขึ้น !")));
      }
      if (typebarber == false) {
        user.updateDisplayName(nameController.text);
      } else {
        if (avertarIng != null) {
          print("เริ่ม");
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
        print("ปหห");
        Navigator.pop(context);
      }
    }).catchError((e) {
      MyDialog().normalDialog(context, "เกิดข้อผิดพลาดขึ้น $e");
    });
  }
}
