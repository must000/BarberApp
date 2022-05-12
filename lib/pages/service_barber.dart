import 'package:flutter/material.dart';

class ServiceBarber extends StatefulWidget {
  const ServiceBarber({ Key? key }) : super(key: key);

  @override
  State<ServiceBarber> createState() => _ServiceBarberState();
}

class _ServiceBarberState extends State<ServiceBarber> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
    );
  }
}
