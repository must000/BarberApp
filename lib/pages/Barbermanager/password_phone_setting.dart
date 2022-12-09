import 'package:barber/Constant/contants.dart';
import 'package:barber/Constant/route_cn.dart';
import 'package:barber/main.dart';
import 'package:barber/pages/Authentication/register_phone_user.dart';
import 'package:barber/pages/Barbermanager/drawerobject.dart';
import 'package:barber/pages/OtherPage/setting_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Password_Phone_Setting extends StatefulWidget {
  const Password_Phone_Setting({Key? key}) : super(key: key);

  @override
  State<Password_Phone_Setting> createState() => _Password_Phone_SettingState();
}

class _Password_Phone_SettingState extends State<Password_Phone_Setting> {
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Contants.myBackgroundColor,
      appBar: AppBar(backgroundColor: Contants.myBackgroundColordark),
      drawer: DrawerObject(),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: size * 0.08),
        child: ListView(
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SettingPassword(
                              email: barberModelformanager!.email,
                              typebarber: true,
                            )));
              },
              child: Row(
                children: [
                  Icon(
                    Icons.lock,
                    color: Contants.colorSpringGreen,
                  ),
                  Text(
                    "เปลี่ยนรหัสผ่าน ",
                    style: Contants().h3white(),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterPhoneUser(
                        emailBarber: barberModelformanager!.email,
                      ),
                    ));
              },
              child: Row(
                children: [
                  Icon(
                    Icons.phone_android,
                    color: Contants.colorSpringGreen,
                  ),
                  Text(
                    "เปลี่ยนเบอร์มือถือ ******${barberModelformanager!.phone.substring(barberModelformanager!.phone.length - 4)}",
                    style: Contants().h3white(),
                  ),
                ],
              ),
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
          ],
        ),
      ),
    );
  }
}
