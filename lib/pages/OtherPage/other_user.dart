import 'package:barber/Constant/contants.dart';
import 'package:barber/pages/OtherPage/setting_account.dart';
import 'package:barber/pages/OtherPage/setting_password.dart';
import 'package:barber/provider/myproviders.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Constant/route_cn.dart';
import '../Authentication/register_phone_user.dart';

class OtherUser extends StatefulWidget {
  const OtherUser({Key? key}) : super(key: key);

  @override
  State<OtherUser> createState() => _OtherUserState();
}

class _OtherUserState extends State<OtherUser> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdataAuthen();
  }

  bool login = false;
  int score = 0;
  String name = "";
  String email = "";
  late final user = FirebaseAuth.instance.currentUser;
  Future getdataAuthen() async {
    // late final user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection("user")
        .doc(user!.uid)
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          score = value.data()!["score"];
        });
      } else {
        print("ไม่มีคะแนน");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Contants.myBackgroundColor,
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: size * 0.08),
          child: ListView(
            children: [
              StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    print(user!.phoneNumber);
                    return user!.displayName == null
                        ? const Text(
                            "",
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 15),
                          )
                        : Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(user!.displayName!,
                                      style: Contants().h4white()),
                                  logout(context)
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    child: Text(
                                      "คะแนนสะสม $score",
                                      style: Contants().h4SpringGreen(),
                                    ),
                                    margin: const EdgeInsets.only(
                                        top: 10, bottom: 70),
                                  ),
                                ],
                              ),
                              user!.emailVerified == false
                                  ? TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SettingAccount(
                                                      email: user!.email!,
                                                      typebarber: false,
                                                      name: user!.displayName!,
                                                    )));
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.account_circle,
                                            color: Contants.colorSpringGreen,
                                          ),
                                          Text("ตั้งค่าข้อมูลผู้ใช้ ",
                                              style: Contants().h3white()),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                              user!.emailVerified == false
                                  ? Divider(
                                      height: 5,
                                      indent: 1,
                                      color: Contants.colorWhite,
                                    )
                                  : const SizedBox(),
                              user!.emailVerified == false
                                  ? TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SettingPassword(
                                                email: user!.email!,
                                                typebarber: false,
                                              ),
                                            ));
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.lock,
                                            color: Contants.colorSpringGreen,
                                          ),
                                          Text("เปลี่ยนรหัสผ่าน ",
                                              style: Contants().h3white()),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                              user!.emailVerified == false
                                  ? Divider(
                                      height: 5,
                                      indent: 1,
                                      color: Contants.colorWhite,
                                    )
                                  : const SizedBox(),
                              user!.emailVerified == false
                                  ?  TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  RegisterPhoneUser(),
                                            ));
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.phone_android,
                                            color: Contants.colorSpringGreen,
                                          ),
                                        user!.phoneNumber != null ?  Text(
                                            "เปลี่ยนเบอร์มือถือ ******${user!.phoneNumber!.substring(user!.phoneNumber!.length-4)}",
                                            style: Contants().h3white(),
                                          ): Text(
                                            "เปลี่ยนเบอร์มือถือ",
                                            style: Contants().h3white(),
                                          )
                                        ],
                                      ),
                                    ):const SizedBox()
                                  
                            ],
                          );
                  } else if (snapshot.hasError) {
                    return const Text("error");
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(""),
                        Row(
                          children: [
                            Icon(
                              Icons.login_rounded,
                              color: Contants.colorSpringGreen,
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, Rount_CN.routeLogin);
                                },
                                child: Text(
                                  "เข้าสู่ระบบ",
                                  style: Contants().h3SpringGreen(),
                                )),
                          ],
                        ),
                      ],
                    );
                  }
                },
              ),
              Divider(
                height: 5,
                indent: 1,
                color: Contants.colorWhite,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, Rount_CN.routeContactAdminUser);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.contact_support,
                      color: Contants.colorSpringGreen,
                    ),
                    Text("ขอความช่วยเหลือ", style: Contants().h3white()),
                  ],
                ),
              ),
              Divider(
                height: 5,
                indent: 1,
                color: Contants.colorWhite,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, Rount_CN.routeAboutDeveloper);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.code,
                      color: Contants.colorSpringGreen,
                    ),
                    Text("เกี่ยวกับเรา", style: Contants().h3white()),
                  ],
                ),
              ),
              Divider(
                indent: 1,
                height: 5,
                color: Contants.colorWhite,
              )
            ],
          ),
        ),
      ),
    );
  }

  logout(BuildContext context) {
    return Row(
      children: [
        TextButton(
            onPressed: () {
              final provider = Provider.of<MyProviders>(context, listen: false);
              provider.logout(context);
            },
            child: Text(
              "ออกจากระบบ",
              style: Contants().h3Red(),
            )),
        Icon(
          Icons.logout,
          color: Contants.colorRed,
        ),
      ],
    );
  }
}
