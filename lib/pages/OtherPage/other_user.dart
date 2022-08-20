import 'package:barber/Constant/contants.dart';
import 'package:barber/pages/OtherPage/setting_account_user.dart';
import 'package:barber/provider/myproviders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Constant/route_cn.dart';

class OtherUser extends StatefulWidget {
  const OtherUser({Key? key}) : super(key: key);

  @override
  State<OtherUser> createState() => _OtherUserState();
}

class _OtherUserState extends State<OtherUser> {
  @override
  Widget build(BuildContext context) {
    late final user = FirebaseAuth.instance.currentUser;
    bool login = false;
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
                  print("${snapshot.data} <<<<<<<<<");
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    return user?.displayName == null
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
                                  Text(
                                    user!.displayName!,
                                    style:Contants().h4white()
                                  ),
                                  logout(context)
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    child: Text("คะแนนสะสม",style: Contants().h4SpringGreen(),),
                                    margin: const EdgeInsets.only(
                                        top: 10, bottom: 70),
                                  ),
                                ],
                              ),
                              user.emailVerified == false
                                  ? TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SettingAccountUser(
                                                email: user.email!,
                                                username: user.displayName!,
                                                typebarber: false,
                                              ),
                                            ));
                                      },
                                      child:Text("ตั้งค่าข้อมูลผู้ใช้ ",style: Contants().h3white()),
                                    )
                                  : const SizedBox(
                                      child: Text(""),
                                    ),
                            ],
                          );
                  } else if (snapshot.hasError) {
                    return const Text("error");
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(""),
                        TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, Rount_CN.routeLogin);
                            },
                            child: Text("Login",style: Contants().h3SpringGreen(),)),
                      ],
                    );
                  }
                },
              ),
              TextButton(
                onPressed: () {},
                child: Text("เปล่ยนเบอร์มือถือ",style: Contants().h3white(),),
              ),
              const SizedBox(
                height: 70,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, Rount_CN.routeContactAdminUser);
                },
                child: Text("ขอความช่วยเหลือ",style: Contants().h3white()),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, Rount_CN.routeAboutDeveloper);
                },
                child: Text("เกี่ยวกับเรา",style: Contants().h3white()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  logout(BuildContext context) {
    return TextButton(
        onPressed: () {
          final provider = Provider.of<MyProviders>(context, listen: false);
          provider.logout();
        },
        child:Text("logout",style: Contants().h3Red(),));
  }
}
