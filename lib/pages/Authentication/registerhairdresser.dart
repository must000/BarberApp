import 'dart:io';
import 'package:barber/Constant/contants.dart';
import 'package:barber/pages/Authentication/register_phone_user.dart';
import 'package:barber/utils/dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class RegisterHairdresser extends StatefulWidget {
  const RegisterHairdresser({Key? key}) : super(key: key);

  @override
  State<RegisterHairdresser> createState() => _RegisterHairdresserState();
}

class _RegisterHairdresserState extends State<RegisterHairdresser> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  File? avertarIng;
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Contants.myBackgroundColor,
      appBar: AppBar(
        backgroundColor: Contants.myBackgroundColordark,
        title: const Text("สมัครเป็นช่างทำผม"),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10
                ),
                inputAvartar(size, context),
                title(size, "ชื่อ"),
                Container(
                  margin:
                      EdgeInsets.only(left: size * 0.08, right: size * 0.08),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "กรุณากรอกชื่อ";
                      } else {}
                    },
                    style: Contants().h4OxfordBlue(),
                    controller: nameController,
                    keyboardType: TextInputType.name,
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
                title(size, "นามสกุล"),
                Container(
                  margin:
                      EdgeInsets.only(left: size * 0.08, right: size * 0.08),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "กรุณากรอกนามสกุล";
                      } else {}
                    },
                    style: Contants().h4OxfordBlue(),
                    controller: lastnameController,
                    keyboardType: TextInputType.name,
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
                title(size, "อีเมล"),
                Container(
                  margin:
                      EdgeInsets.only(left: size * 0.08, right: size * 0.08),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "กรุณากรอกEmail";
                      } else {}
                    },
                    style: Contants().h4OxfordBlue(),
                    controller: emailController,
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
                title(size, "รหัสผ่าน"),

                Container(
                  margin: EdgeInsets.only(
                 left: size * 0.08, right: size * 0.08),
                  child: TextFormField(
                    controller: passwordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "กรุณากรอกรหัสผ่าน";
                      } else {}
                    },
                    style: Contants().h4OxfordBlue(),
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
                title(size, "ยืนยันรหัสผ่าน"),
                Container(
                  margin: EdgeInsets.symmetric( horizontal: size * 0.08),
                  child: TextFormField(
                    style: Contants().h4OxfordBlue(),
                    obscureText: true,
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
                        if (avertarIng == null) {
                          MyDialog().hardDialog(context,
                              "กรุณาเพิ่มรูปโปรไฟล์ของคุณ", "ยังไม่มีรูปโปรไฟล์");
                        } else {
                          registerFirebase();
                        }
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
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
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
        avertarIng = File(result!.path);
      });
    } catch (e) {}
  }

  Container title(double size, String title) {
    return Container(
      margin: EdgeInsets.only(left: size * 0.08, right: size * 0.08,top: 10),
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

  Stack inputAvartar(double size, BuildContext context) {
    return Stack(children: [
      Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white),
        ),
        child: avertarIng == null
            ? const Icon(
                Icons.account_circle,
                color: Colors.white,
                size: 200,
              )
            : Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white),
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
            icon: Icon(
              Icons.add_circle,
              color: Contants.colorYellow,
              size: 50,
            )),
        height: 190,
        width: 190,
      )
    ]);
  }

  Future<Null> registerFirebase() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text.toLowerCase(),
              password: passwordController.text)
          .then((value) async {
        proceedsaveData().then((value) => uploadAvarter().then((value) {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RegisterPhoneUser(
                    emailhairresser: emailController.text.toLowerCase(),
                  ),
                ),
              );
            }));
        print("สมัครแล้ว $value");
      }).catchError((value) {
        MyDialog().authenWrongDialog(context, "อีเมลนี้เคยสมัครไปแล้ว");
      });
    });
  }

  Future<Null> uploadAvarter() async {
    final path = 'avatar/${emailController.text.toLowerCase()}';
    final file = File(avertarIng!.path);
    final ref = FirebaseStorage.instance.ref().child(path);
    ref.putFile(file).then((p0) {});
  }

  proceedsaveData() async {
    await FirebaseFirestore.instance.collection('Hairdresser').add({
      "email": emailController.text.toLowerCase(),
      "name": nameController.text,
      "lastname": lastnameController.text,
      "barberState": "no",
      "idCode": randomNumeric(7),
      "phone": ""
    }).then((newvalue) async {
      await FirebaseFirestore.instance.collection('Service').add({}).then(
        (value) async {
          print(value.id);
          await FirebaseFirestore.instance
              .collection('Hairdresser')
              .doc(newvalue.id)
              .update({"serviceID": value.id});
          debugPrint("อัพเดตเซอร์วิสไอดี สำเร็จ");
        },
      );
      debugPrint("บันทึกสำเร็จ");
    });
  }

  void fc() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => RegisterPhoneUser(),
        ),
        (route) => false);
  }
}
