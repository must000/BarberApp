import 'package:barber/Constant/contants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class BarberHairdresser extends StatefulWidget {
  const BarberHairdresser({Key? key}) : super(key: key);

  @override
  State<BarberHairdresser> createState() => _BarberHairdresserState();
}

class _BarberHairdresserState extends State<BarberHairdresser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Contants.myBackgroundColordark,
      ),
      backgroundColor: Contants.myBackgroundColor,
    );
  }
}
