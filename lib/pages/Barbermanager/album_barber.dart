import 'package:barber/Constant/contants.dart';
import 'package:barber/pages/Barbermanager/drawerobject.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class AlbumBarber extends StatefulWidget {
  const AlbumBarber({Key? key}) : super(key: key);

  @override
  State<AlbumBarber> createState() => _AlbumBarberState();
}

class _AlbumBarberState extends State<AlbumBarber> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Contants.myBackgroundColordark,),
      backgroundColor: Contants.myBackgroundColor,
      body: Text("555555555"),
        drawer: DrawerObject()
    );
  }
}
