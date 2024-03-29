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
          subtitle: Text(string,style: Contants().h4OxfordBlue(),),
        ),
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:Text("OK",style: Contants().h2yellow(),),
          )
        ],
      ),
    );
  }

    Future<Null> authenWrongDialog(BuildContext context, String string) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: ListTile(
          title: Text(string, style:Contants().h3Red()),
    
        ),
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:Text("OK",style: Contants().h2yellow(),),
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
                "บันทึกเวลาพัก",
                style: Contants().h2OxfordBlue(),
              ),
              content: SingleChildScrollView(
                  child: Container(
                width: double.maxFinite,
                child: Column(
                  children: const [
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
          title: Text(title, style:  Contants().h3OxfordBlue()),
          subtitle: Text(string),
        ),
        children: [
          TextButton(
            onPressed: funcAction,
            child: Text("ตกลง",style: Contants().h2OxfordBlue(),),
          )
        ],
      ),
    );
  }

  Future<Null> confirmImage(
    BuildContext context,
    File file,
  ) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => SimpleDialog(
        title: const ListTile(
          title: Text("อัพโหลดรูปภาพ", style: TextStyle(color: Colors.black)),
        ),
        children: [
          Image.file(file),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                   style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Contants.colorSpringGreen),
    ),
                onPressed: funcAction,
                child: Text("ยืนยัน",style: Contants().h2OxfordBlue(),),
              ),
              ElevatedButton(
                 style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Contants.colorRed),
    ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("ยกเลิก",style: Contants().h2white(),),
              )
            ],
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
            child: Text("ยืนยัน",style: Contants().h2OxfordBlue(),),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: funcAction,
                child:  Text("ยืนยัน",style: Contants().h2OxfordBlue(),),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child:  Text("ยกเลิก",style: Contants().h2Red()),
              ),
            ],
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
            child: Text("เข้าสู่ระบบ",style: Contants().h2OxfordBlue(),),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text("ยกเลิก",style: Contants().h2Red(),),
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
            child: Text("ยืนยัน",style: Contants().h2OxfordBlue(),),
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
              child: Text("ยืนยัน",style: Contants().h2OxfordBlue(),))
        ],
      ),
    );
  }
}
