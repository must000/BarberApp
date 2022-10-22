import 'package:barber/Constant/contants.dart';
import 'package:barber/pages/Barbermanager/drawerobject.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class StatisticeBarber extends StatefulWidget {
  const StatisticeBarber({Key? key}) : super(key: key);

  @override
  State<StatisticeBarber> createState() => _StatisticeBarberState();
}

class _StatisticeBarberState extends State<StatisticeBarber> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Contants.myBackgroundColordark,
      ),
      backgroundColor: Contants.myBackgroundColor,
      body: Text("ข้อมูลผู้ใช้"), drawer: DrawerObject()
    );
  }
}
