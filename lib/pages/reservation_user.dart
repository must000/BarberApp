import 'package:flutter/material.dart';

class ReservationUser extends StatefulWidget {
  const ReservationUser({Key? key}) : super(key: key);

  @override
  State<ReservationUser> createState() => _ReservationUserState();
}

class _ReservationUserState extends State<ReservationUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("reservation")),
    );
  }
}
