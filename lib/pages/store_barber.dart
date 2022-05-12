import 'package:flutter/material.dart';

class StoreBarber extends StatefulWidget {
  const StoreBarber({ Key? key }) : super(key: key);

  @override
  State<StoreBarber> createState() => _StoreBarberState();
}

class _StoreBarberState extends State<StoreBarber> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Text("store"),
    );
  }
}