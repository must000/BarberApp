import 'package:barber/pages/OtherPage/barber_hairdresser.dart';
import 'package:barber/utils/dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:barber/Constant/contants.dart';
import 'package:barber/Constant/route_cn.dart';
import 'package:barber/pages/Authentication/register_phone_user.dart';
import 'package:barber/pages/OtherPage/setting_account_user.dart';
import 'package:barber/provider/myproviders.dart';

class OtherHairdresser extends StatefulWidget {
  String email;
  String fullname;
  String barberState;
  OtherHairdresser({
    Key? key,
    required this.email,
    required this.fullname,
    required this.barberState,
  }) : super(key: key);

  @override
  State<OtherHairdresser> createState() =>
      _OtherHairdresserState(email: this.email, fullname: this.fullname,barberState: this.barberState);
}

class _OtherHairdresserState extends State<OtherHairdresser> {
  String? email;
  String? fullname;
  String? barberState;
  _OtherHairdresserState({required this.email, required this.fullname,required this.barberState});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Contants.myBackgroundColor,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: size * 0.08),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                fullname == null
                    ? const Text("")
                    : Text(
                        "ชื่อ $fullname",
                        style: Contants().h2white(),
                      ),
                logout(context),
              ],
            ),
            const SizedBox(
              height: 70,
            ),
            Row(
              children: [
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
                  child: Text(
                    "ตั้งค่าข้อมูลผู้ใช้ ",
                    style: Contants().h3white(),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterPhoneUser(),
                        ));
                  },
                  child: Text(
                    "เปลี่ยนเบอร์มือถือ",
                    style: Contants().h3white(),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    print(barberState);
                    if (barberState == "no") {
                      MyDialog().normalDialog(context, "ยังไม่มีร้านทำผม");
                    }
                    else{
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const BarberHairdresser(),));
                    }
                  },
                  child: Text(
                    "ร้านทำผมที่สังกัด",
                    style: Contants().h3white(),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                        context, Rount_CN.routeContactAdminUser);
                  },
                  child: Text(
                    "ขอความช่วยเหลือ",
                    style: Contants().h3white(),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Rount_CN.routeAboutDeveloper);
                  },
                  child: Text(
                    "เกี่ยวกับเรา",
                    style: Contants().h3white(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  logout(BuildContext context) {
    return TextButton(
        onPressed: () {
          final provider = Provider.of<MyProviders>(context, listen: false);
          provider.logoutBB(context);
        },
        child: Text(
          "ออกจากระบบ",
          style: Contants().h4Red(),
        ));
  }
}
