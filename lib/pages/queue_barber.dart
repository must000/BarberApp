import 'package:flutter/material.dart';

class QueueBarber extends StatefulWidget {
  const QueueBarber({Key? key}) : super(key: key);

  @override
  State<QueueBarber> createState() => _QueueBarberState();
}

class _QueueBarberState extends State<QueueBarber> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("queue"),
    );
  }
}
