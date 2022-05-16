import 'package:flutter/material.dart';

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
