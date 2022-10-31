import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:barber/Constant/contants.dart';

class ReservationDetailBarber extends StatefulWidget {
  String id;
  ReservationDetailBarber({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<ReservationDetailBarber> createState() => _ReservationDetailBarberState(id:id);
}

class _ReservationDetailBarberState extends State<ReservationDetailBarber> {
  String id;
  _ReservationDetailBarberState({required this.id});
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDatawhereID();
  }
  Future<Null> getDatawhereID()async{
    await FirebaseFirestore.instance
        .collection('Queue').doc(id).snapshots()
        .listen((event) { });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Contants.myBackgroundColor,
      appBar: AppBar(backgroundColor: Contants.myBackgroundColordark),
      body: Text("$id"),
    );
  }
}