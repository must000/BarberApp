import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class SettingAccountUser extends StatefulWidget {
  String username;
  SettingAccountUser({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  State<SettingAccountUser> createState() =>
      _SettingAccountUserState(username: this.username);
}

class _SettingAccountUserState extends State<SettingAccountUser> {
  TextEditingController nameController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();
  String username;
  _SettingAccountUserState({required this.username});

  @override
  Widget build(BuildContext context) {
    nameController.text = username;
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(),
        body: Column(
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
                // validator: (value) {
                //   if (value!.isEmpty) {
                //     return "กรุณากรอกรหัสผ่านเดิม";
                //   } else {}
                // },
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
                // validator: (value) {
                //   if (value!.isEmpty) {
                //     return "กรุณากรอกรหัสผ่านใหม่";
                //   } else {}
                // },
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
                // validator: (value) {
                //   if (value!.isEmpty) {
                //     return "กรุณากรอกรหัสผ่านใหม่อีกครั้ง";
                //   } else {}
                // },
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
            ElevatedButton(onPressed: (){}, child: const Text("บันทึก"))
          ],
        ));
  }
}
