import 'package:barber/Constant/contants.dart';
import 'package:barber/pages/Authentication/register_phone_user.dart';
import 'package:barber/provider/myproviders.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class HaveNoPhoneNumbar extends StatefulWidget {
  const HaveNoPhoneNumbar({Key? key}) : super(key: key);

  @override
  State<HaveNoPhoneNumbar> createState() => _HaveNoPhoneNumbarState();
}

class _HaveNoPhoneNumbarState extends State<HaveNoPhoneNumbar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Contants.myBackgroundColor,
      appBar: AppBar(
        actions: [logout(context)],
        backgroundColor: Contants.myBackgroundColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "ยังไม่ได้ลงทะเบียนเบอร์โทรศัพท์",
              style: Contants().h3white(),
            ),
            Text(
              "กรุณาลงทะเบียนเบอร์โทรศัพท์",
              style: Contants().h4white(),
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterPhoneUser(),
                      ));
                },
                child: Text(
                  "ไปที่หน้าลงทะเบียนเบอร์โทรศัพท์ ",
                  style: Contants().h2SpringGreen(),
                ))
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
