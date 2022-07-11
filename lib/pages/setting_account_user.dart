import 'dart:math';

import 'package:barber/pages/index.dart';
import 'package:barber/utils/dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class SettingAccountUser extends StatefulWidget {
  String username, email;
  SettingAccountUser({
    Key? key,
    required this.username,
    required this.email,
  }) : super(key: key);

  @override
  State<SettingAccountUser> createState() =>
      _SettingAccountUserState(username: this.username, email: this.email);
}

class _SettingAccountUserState extends State<SettingAccountUser> {
  TextEditingController nameController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String username, email;
  _SettingAccountUserState({required this.username, required this.email});

  @override
  Widget build(BuildContext context) {
    nameController.text = username;
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(),
        body: Form(
          key: formKey,
          child: Column(
            children: [
              Container(
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
                      proceedUpdateProfile();
                    }
                  },
                  child: const Text("บันทึก"))
            ],
          ),
        ));
  }

  proceedUpdateProfile() async {
    final user = await FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(
        email: email, password: oldPasswordController.text);
    user!.reauthenticateWithCredential(cred).then((value) {
      if (newPasswordController.text.isNotEmpty) {
        return user.updatePassword(newPasswordController.text).then((value) =>
            Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IndexPage(),
                    ),
                    (route) => false)
                .catchError((e) =>
                    MyDialog().normalDialog(context, "เกิดข้อผิดพลาดขึ้น")));
      }
      return user.updateDisplayName(nameController.text);
    }).catchError((e) {
      MyDialog().normalDialog(context, "เกิดข้อผิดพลาดขึ้น");
    });
  }
}
