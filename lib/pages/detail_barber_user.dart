import 'package:flutter/material.dart';

class DetailBarberUser extends StatefulWidget {
  final String nameBarber;
  const DetailBarberUser({
    Key? key,
    required this.nameBarber,
  }) : super(key: key);

  @override
  State<DetailBarberUser> createState() =>
      _DetailBarberUserState(nameBarber: nameBarber);
}

class _DetailBarberUserState extends State<DetailBarberUser> {
  String nameBarber;
  _DetailBarberUserState({required this.nameBarber});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(nameBarber),),
      body: ListView(children: [

      ]),
    );
  }
}
