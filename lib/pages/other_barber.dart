import 'package:flutter/material.dart';

class OtherBarber extends StatefulWidget {
  const OtherBarber({ Key? key }) : super(key: key);

  @override
  State<OtherBarber> createState() => _OtherBarberState();
}

class _OtherBarberState extends State<OtherBarber> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Other"),
    );
  }
}