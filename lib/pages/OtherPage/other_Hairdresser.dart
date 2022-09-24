import 'package:barber/pages/OtherPage/barber_hairdresser.dart';
import 'package:barber/pages/OtherPage/setting_account.dart';
import 'package:barber/utils/dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:barber/Constant/contants.dart';
import 'package:barber/Constant/route_cn.dart';
import 'package:barber/pages/Authentication/register_phone_user.dart';
import 'package:barber/pages/OtherPage/setting_password.dart';
import 'package:barber/provider/myproviders.dart';

class OtherHairdresser extends StatefulWidget {
  String email;
  String name,lastname;
  String barberState;
  String idHairdresser;
  OtherHairdresser(
      {Key? key,
      required this.email,
      required this.name,
      required this.barberState,
      required this.idHairdresser,required this.lastname})
      : super(key: key);

  @override
  State<OtherHairdresser> createState() => _OtherHairdresserState(
      email: this.email,
      name: this.name,
      barberState: this.barberState,
      idHairdresser: idHairdresser,lastname:lastname);
}

class _OtherHairdresserState extends State<OtherHairdresser> {
  String? email;
  String? name,lastname;
  String? barberState;
  String? idHairdresser;
  _OtherHairdresserState(
      {required this.email,
      required this.name,
      required this.barberState,
      required this.idHairdresser,required this.lastname});

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
                name==null||lastname == null
                    ? const Text("")
                    : Text(
                        "ชื่อ $name $lastname",
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
                            builder: (context) => SettingAccount(
                                email: email!, typebarber: true, name: name!,lastname: lastname,)));
                  },
                  child: Text(
                    "ตั้งค่าโปรไฟล์",
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
                            builder: (context) => SettingPassword(
                                  email: email!,
                                  typebarber: true,
                                )));
                  },
                  child: Text(
                    "เปลี่ยนรหัสผ่าน ",
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
                          builder: (context) => RegisterPhoneUser(
                            emailhairresser: email,
                          ),
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
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BarberHairdresser(
                              barberState: barberState!,
                              idHairdresser: idHairdresser!,
                            ),
                          ));
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
