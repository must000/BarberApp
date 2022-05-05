import 'package:barber/pages/haircut_user.dart';
import 'package:barber/pages/other_user.dart';
import 'package:barber/pages/reservation_user.dart';
import 'package:flutter/material.dart';

class BarberSerchUser extends StatefulWidget {
  const BarberSerchUser({Key? key}) : super(key: key);

  @override
  State<BarberSerchUser> createState() => _BarberSerchUserState();
}

class _BarberSerchUserState extends State<BarberSerchUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Text("ร้านทั้งหมด"),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.cut, color: Colors.black),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(
      //         Icons.format_list_bulleted,
      //         color: Colors.black,
      //       ),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(
      //         Icons.account_box,
      //         color: Colors.black,
      //       ),
      //       label: 'Home',
      //     ),
      //   ],
      // ),
    );
  }
}
