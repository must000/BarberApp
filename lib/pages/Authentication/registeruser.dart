import 'package:barber/Constant/contants.dart';
import 'package:barber/Constant/route_cn.dart';
import 'package:barber/pages/Authentication/register_phone_user.dart';
import 'package:barber/pages/index.dart';
import 'package:barber/utils/dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  TextEditingController passwordController = TextEditingController();
  PhoneAuthCredential? phoneCredential;
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Contants.myBackgroundColor,
      appBar: AppBar(
        title: const Text("สมัครสมาชิก"),
        backgroundColor: Contants.myBackgroundColordark,
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
                title(size, "ชื่อ "),
                Container(
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
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                title(size, "นามสกุล "),

                Container(
                  margin: EdgeInsets.only(
                       left: size * 0.08, right: size * 0.08),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "กรุณากรอกEmail";
                      } else {}
                    },
                    controller: userController,
                    style: Contants().h4OxfordBlue(),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                title(size, "รหัสผ่าน "),
                Container(
                  margin: EdgeInsets.only( left: size * 0.08, right: size * 0.08),
                  child: TextFormField(
                    controller: passwordController,
                    style: Contants().h4OxfordBlue(),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "กรุณากรอกรหัสผ่าน";
                      } else {}
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                title(size, "ยืนยันรหัสผ่าน "),

                Container(
                  margin: EdgeInsets.symmetric(
                     horizontal: size * 0.08),
                  child: TextFormField(
                    obscureText: true,
                    style: Contants().h4OxfordBlue(),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "กรุณากรอกรหัสผ่าน";
                      } else if (value != passwordController.text) {
                        return "กรุณากรอกรหัสผ่านให้ตรงกัน";
                      }
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                    width: size * 0.5,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          // registerFirebase();
                          registerFirebase();
                        }
                      },
                      child: Text(
                        "สมัคร",
                        style: Contants().h2OxfordBlue(),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Contants.colorWhite),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
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

  Future<Null> registerFirebase() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: userController.text.toLowerCase(),
              password: passwordController.text)
          .then((value) async {
        await value.user!.updateDisplayName(nameController.text).then(
              (value) => MyDialog(funcAction: fc).hardDialog(
                  context, "เรากำลังนำคุณไปลงทะเบียนเบอร์", "สมัครสำเร็จ"),
            );
        print("สมัครแล้ว $value");
      }).catchError((value) {
        MyDialog().normalDialog(context, value.message);
      });
    });
  }

  void fc() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterPhoneUser(),
      ),
    );
  }
}
