import 'package:barber/Constant/route_cn.dart';
import 'package:barber/utils/dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({Key? key}) : super(key: key);

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  PhoneAuthCredential? phoneCredential;
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("สมัครสมาชิก"),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: size * 0.2,
                ),
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
                        return "กรุณากรอกEmail";
                      } else {}
                    },
                    controller: userController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
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
                    controller: passwordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "กรุณากรอกรหัสผ่าน";
                      } else {}
                    },
                    decoration: InputDecoration(
                      labelText: "Password",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      vertical: 8, horizontal: size * 0.08),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "กรุณากรอกรหัสผ่าน";
                      } else if (value != passwordController.text) {
                        return "กรุณากรอกรหัสผ่านให้ตรงกัน";
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                SizedBox(
                    width: size * 0.5,
                    height: 80,
                    child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            registerFirebase();
                          }
                        },
                        child: const Text(
                          "สมัคร",
                          style: TextStyle(fontSize: 20),
                        )))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> registerFirebase() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: userController.text, password: passwordController.text)
          .then((value) async {
        await value.user!.updateDisplayName(nameController.text).then(
              (value) => Navigator.pop(context),
            );
        print("สมัครแล้ว $value");
      }).catchError((value) {
        MyDialog().normalDialog(context, value.message);
      });
    });
  }
}
