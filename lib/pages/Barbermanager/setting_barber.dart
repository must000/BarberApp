import 'package:barber/Constant/contants.dart';
import 'package:barber/pages/Barbermanager/drawerobject.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class SettingBarber extends StatefulWidget {
  const SettingBarber({Key? key}) : super(key: key);

  @override
  State<SettingBarber> createState() => _SettingBarberState();
}

class _SettingBarberState extends State<SettingBarber> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(  appBar: AppBar(
          backgroundColor: Contants.myBackgroundColordark,
        ),
        backgroundColor: Contants.myBackgroundColor,
      body: Text("ตั้งค่าข้อมูลร้าน"), drawer: DrawerObject()
    );
  }
}