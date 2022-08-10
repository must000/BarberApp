import 'package:barber/Constant/contants.dart';
import 'package:barber/pages/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:barber/utils/dialog.dart';

class RegisterPhoneUser extends StatefulWidget {
  RegisterPhoneUser({
    Key? key,
  }) : super(key: key);

  @override
  State<RegisterPhoneUser> createState() => _RegisterPhoneUserState();
}

class _RegisterPhoneUserState extends State<RegisterPhoneUser> {
  final formKey = GlobalKey<FormState>();

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController phoneController = TextEditingController();
  TextEditingController smsController = TextEditingController();
  String? _verificationId;
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Contants.myBackgroundColor,
      appBar: AppBar(
        backgroundColor: Contants.myBackgroundColordark,
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Container(
                  height: 50,
                  margin: EdgeInsets.only(left: size * 0.08),
                  width: size * 0.6,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "กรุณากรอกเบอร์โทร";
                      }
                    },
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    style: Contants().h2OxfordBlue(),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Phone",
                      labelStyle: Contants().h2Red(),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                ),
                SizedBox(
                  width: size * 0.25,
                  height: 50,
                  child: ElevatedButton(
                     style: ElevatedButton.styleFrom(primary: Contants.colorBlack),
                    onPressed: () {
                      if (phoneController.text == "") {
                        MyDialog()
                            .normalDialog(context, "กรุณากรอกเบอร์โทรของคุณ");
                      } else {
                        requestVerifyCode();
                      }
                    },
                    child: Text(
                      "ส่งotp",
                      style: Contants().h2white(),
                    ),
                  ),
                ),
              ],
            ),
            Container(
               height: 50,
              margin: EdgeInsets.only(
                  top: 15, left: size * 0.08, right: size * 0.08),
              child: TextFormField(
                controller: smsController,
                keyboardType: TextInputType.number,
                style: Contants().h2OxfordBlue(),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "กรุณากรอกหมายเลขotp";
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: "Code",labelStyle: Contants().h2Red(),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: size * 0.5,
              height: 50,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.white),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      verifyPhone();
                    }
                  },
                  child: Text(
                    "บันทึก",
                    style: Contants().h1OxfordBlue(),
                  )),
            )
          ],
        ),
      ),
    );
  }

  requestVerifyCode() {
    _auth.verifyPhoneNumber(
        phoneNumber: "+66" + phoneController.text,
        timeout: const Duration(seconds: 120),
        verificationCompleted: (firebaseUser) {},
        verificationFailed: (error) {
          print("error === $error");
        },
        codeSent: (verificationId, [force]) {
          setState(() {
            _verificationId = verificationId;
          });
          print(verificationId);
        },
        codeAutoRetrievalTimeout: (verificationId) {
          print("หมดเวลา");
        });
  }

  verifyPhone() async {
    final user = await FirebaseAuth.instance.currentUser;
    user!
        .updatePhoneNumber(PhoneAuthProvider.credential(
            verificationId: _verificationId!, smsCode: smsController.text))
        .then((value) => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => IndexPage(),
            )));
    // await _auth
    //     .signInWithCredential(PhoneAuthProvider.credential(
    //         verificationId: _verificationId!, smsCode: smsController.text))
    //     .then(
    //       (value) => print("สำเร็จ"),
    //     )
    //     .catchError(() => print("ผิดพลาด"));
    // print("สำเร็จ");
    // await Firebase.initializeApp().then((value) async {
    //   await FirebaseAuth.instance
    //       .createUserWithEmailAndPassword(email: email!, password: password!)
    //       .then((value) async {
    //     await value.user!.updatePhoneNumber(PhoneAuthProvider.credential(
    //         verificationId: _verificationId!, smsCode: smsController.text));
    //     await value.user!
    //         .updateDisplayName(name)
    //         .then((value) => Navigator.pushAndRemoveUntil(
    //             context,
    //             MaterialPageRoute(
    //               builder: (context) => IndexPage(),
    //             ),
    //             (route) => false))
    //         .catchError((value) {
    //       MyDialog().hardDialog(context, "แต่เบอร์โทรถูกใช้ไปแล้ว !!!", "สมัครสำเร็จ");
    //     });

    //     print("สมัครแล้ว $value");
    //   }).catchError((value) {
    //     MyDialog().normalDialog(context, value.message);
    //   });
    // });
  }
}
