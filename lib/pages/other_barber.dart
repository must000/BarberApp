import 'package:barber/Constant/route_cn.dart';
import 'package:barber/pages/index.dart';
import 'package:barber/provider/myproviders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OtherBarber extends StatefulWidget {
  const OtherBarber({Key? key}) : super(key: key);

  @override
  State<OtherBarber> createState() => _OtherBarberState();
}

class _OtherBarberState extends State<OtherBarber> {
  @override
  Widget build(BuildContext context) {
    late final user = FirebaseAuth.instance.currentUser;
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: size * 0.08),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: const Text("ชื่อ"),
                ),
                logout(context),
              ],
            ),
            TextButton(
              onPressed: () {},
              child: const Text("ตั้งค่าข้อมูลผู้ใช้"),
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
              onPressed: () {},
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
          provider.logout();

          Navigator.popAndPushNamed(context, Rount_CN.routeIndex);
        },
        child: const Text("logout"));
  }
}
