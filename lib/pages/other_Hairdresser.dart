import 'package:barber/pages/setting_account_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:barber/Constant/route_cn.dart';
import 'package:barber/pages/index.dart';
import 'package:barber/provider/myproviders.dart';

class OtherHairdresser extends StatefulWidget {
  String email;
  OtherHairdresser({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<OtherHairdresser> createState() =>
      _OtherHairdresserState(email: this.email);
}

class _OtherHairdresserState extends State<OtherHairdresser> {
  String? email;
  _OtherHairdresserState({required this.email});
  String? fullname;

  @override
  void initState() {
    super.initState();
    findFullname();
  }

  Future<Null> findFullname() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        setState(() {
          email = event!.email;
        });
        final data =
            FirebaseFirestore.instance.collection('Hairdresser').doc(event!.email);
        final snapshot = await data.get();
        if (snapshot.exists) {
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          setState(() {
            fullname = "${data["name"]} ${data["lastname"]}";
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: size * 0.08),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                fullname == null ? const Text("") : Text("ชื่อ $fullname"),
                logout(context),
              ],
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SettingAccountUser(
                              email: email!,
                              typebarber: true,
                            )));
              },
              child: const Text("ตั้งค่าข้อมูลผู้ใช้ "),
            ),
            TextButton(
              onPressed: () {},
              child: const Text("ตั้งค่าข้อมูลร้าน"),
            ),
            const SizedBox(
              height: 70,
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, Rount_CN.routeContactAdminUser);
              },
              child: const Text("ขอความช่วยเหลือ"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, Rount_CN.routeAboutDeveloper);
              },
              child: const Text("เกี่ยวกับเรา"),
            ),
          ],
        ),
      ),
    );
  }

  logout(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          final provider = Provider.of<MyProviders>(context, listen: false);
          provider.logoutBB(context);
        },
        child: const Text("logout"));
  }
}
