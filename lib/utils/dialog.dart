import 'dart:io';

import 'package:barber/Constant/contants.dart';
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

  Future<Null> confirmBreakTimeDialog(
      BuildContext context, List<String> list) async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                "ยืนยันเวลาพัก",
                style: Contants().h2OxfordBlue(),
              ),
              content: SingleChildScrollView(
                  child: Container(
                width: double.maxFinite,
                child: Column(
                  children: const [
                    // ConstrainedBox(
                    //   constraints: BoxConstraints(
                    //     maxHeight: MediaQuery.of(context).size.height * 0.5,
                    //   ),
                    //   child: ListView.builder(
                    //     shrinkWrap: true,
                    //     itemBuilder: (context, index) {
                    //       String day = list[index].substring(0, 2);
                    //       if (day == "mo") {
                    //         day = "จันทร์ ";
                    //       } else if (day == "tu") {
                    //         day = "อังคาร ";
                    //       } else if (day == "we") {
                    //         day = "พุธ ";
                    //       } else if (day == "th") {
                    //         day = "พฤหัสบดี ";
                    //       } else if (day == "fr") {
                    //         day = "ศุกร์ ";
                    //       } else if (day == "sa") {
                    //         day = "เสาร์ ";
                    //       } else if (day == "su") {
                    //         day = "อาทิตย์ ";
                    //       }
                    //       return Text("$day ${list[index].substring(3)}");
                    //     },
                    //     itemCount: list.length,
                    //   ),
                    // ),
                  ],
                ),
              )),
              actions: [
                TextButton(
                    onPressed: funcAction,
                    child: Text(
                      "ยืนยัน",
                      style: Contants().h3SpringGreen(),
                    )),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "ยกเลิก",
                      style: Contants().h3Red(),
                    ))
              ],
            ));
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

  Future<Null> hardDialogv2(
    BuildContext context,
    String string,
    String title,
  ) async {
    showDialog(
      barrierDismissible: false,
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

  Future<Null> superDialog(
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
            child: const Text("ยืนยัน"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("ยกเลิก"),
          ),
        ],
      ),
    );
  }

  Future<Null> addHairresserDialog(
    BuildContext context,
    String idCode,
    String fullname,
    String phone,
    String email,
  ) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: ListTile(
          title: Text(idCode, style: const TextStyle(color: Colors.black)),
          subtitle: Text(" $fullname \n $email \n $phone"),
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("ยกเลิก", style: Contants().h4Red()),
              ),
              TextButton(
                onPressed: funcAction,
                child: Text("ยืนยัน", style: Contants().h4OxfordBlue()),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<Null> checkLoginDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
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
