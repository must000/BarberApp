import 'dart:io';

import 'package:barber/pages/index.dart';
import 'package:barber/pages/Authentication/login.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:geolocator/geolocator.dart';

class MyDialog {
  final Function()? funcAction;

  MyDialog({this.funcAction});
  Future<Null> normalDialog(BuildContext context, String string) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: ListTile(
          title: const Text("", style: TextStyle(color: Colors.black)),
          subtitle: Text(string),
        ),
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  Future<Null> hardDialog(
    BuildContext context,
    String string,
    String title,
  ) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: ListTile(
          title: Text(title, style: const TextStyle(color: Colors.black)),
          subtitle: Text(string),
        ),
        children: [
          TextButton(
            onPressed: funcAction,
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  Future<Null> checkLoginDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const ListTile(
          title: Text("กรุณาเข้าสู่ระบบก่อนทำรายการจอง",
              style: TextStyle(color: Colors.black)),
          subtitle: Text("ไปที่หน้าล็อคอิน"),
        ),
        children: [
          TextButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return const Login();
              },
            )),
            child: const Text("login"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("ยกเลิก"),
          )
        ],
      ),
    );
  }

  Future<Null> stDialog(BuildContext context, String string) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: ListTile(
          title: const Text("สมัครสำเร็จแต่ไม่สามารถอัพโหลดรูปได้ สาเหตุ",
              style: TextStyle(color: Colors.black)),
          subtitle: Text(string),
        ),
        children: [
          TextButton(
            onPressed: () {
              MaterialPageRoute(
                builder: (context) => IndexPage(),
              );
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  Future<Null> alertLocation(
      BuildContext context, String title, String masage) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          title: Text(title),
        ),
        actions: [
          TextButton(
              onPressed: () async {
                //Navigator.pop(context);
                await Geolocator
                    .openLocationSettings(); // ไปที่location setting
                exit(0); //ปิดแอพ
              },
              child: const Text("OK"))
        ],
      ),
    );
  }
}
