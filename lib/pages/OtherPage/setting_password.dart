import 'dart:io';

import 'package:barber/Constant/contants.dart';
import 'package:barber/pages/index.dart';
import 'package:barber/utils/dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SettingPassword extends StatefulWidget {
 
  String email;
  bool typebarber;
  SettingPassword({
    Key? key,
  
    required this.email,
    required this.typebarber,
  }) : super(key: key);

  @override
  State<SettingPassword> createState() => _SettingPasswordState(
       email: email, typebarber: this.typebarber);
}

class _SettingPasswordState extends State<SettingPassword> {
  TextEditingController nameController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String email;
  bool typebarber;
  _SettingPasswordState(
      { required this.email, required this.typebarber});

  @override
  Widget build(BuildContext context) {

    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Contants.myBackgroundColor,
        appBar: AppBar(
          title: const Text("เปลี่ยนรหัสผ่าน"),
          backgroundColor: Contants.myBackgroundColordark,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
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
                       filled: true,
                        labelStyle: Contants().h2OxfordBlue(),
                  fillColor: Colors.white,
                      labelText: "รหัสผ่านเดิม",
                       floatingLabelStyle: Contants().floatingLabelStyle(),
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
                         filled: true,
                        labelStyle: Contants().h2OxfordBlue(),
                  fillColor: Colors.white,
                      labelText: "รหัสผ่านใหม่",
                       floatingLabelStyle: Contants().floatingLabelStyle(),
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
                         filled: true,
                        labelStyle: Contants().h2OxfordBlue(),
                  fillColor: Colors.white,
                      labelText: "ยืนยืนรหัสผ่าน",
                       floatingLabelStyle: Contants().floatingLabelStyle(),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
               Container(
                    width: size * 0.5,
                    margin: const EdgeInsets.only(top: 20),
              height: 50,
                  child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.white),

                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          proceedUpdatePassword();
                        }
                      },
                      child: Text("บันทึก"  ,style: Contants().h1OxfordBlue(),)),
                )
              ],
            ),
          ),
        ));
  }

  proceedUpdatePassword() async {
    final user = await FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(
        email: email, password: oldPasswordController.text);
    user!.reauthenticateWithCredential(cred).then((value) async {
      if (newPasswordController.text.isNotEmpty) {
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
    }).catchError((e) {
      MyDialog().normalDialog(context, "เกิดข้อผิดพลาดขึ้น $e");
    });
  }
}
