import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:geolocator/geolocator.dart';

class MyDialog {
  Future<Null> normalDialog(BuildContext context, String string) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: ListTile(
          title: const Text("Normal Dialog",
              style: TextStyle(color: Colors.black)),
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
  // Future<Null> chooseImgDialog(BuildContext context) async {
  //   showDialog(
  //     context: context,
  //     builder: (context) => SimpleDialog(
  //       title: const ListTile(
  //         title: Text("เลือกวิธีเพิ่มรูปภาพ",
  //             style: TextStyle(color: Colors.black)),
  //       ),
  //       children: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text("ShowImage"),
  //         )
  //       ],
  //     ),
  //   );
  // }
}
