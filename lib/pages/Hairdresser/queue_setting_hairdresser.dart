import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class QueueSettingHairdresser extends StatefulWidget {
  const QueueSettingHairdresser({Key? key}) : super(key: key);

  @override
  State<QueueSettingHairdresser> createState() => _QueueSettingHairdresserState();
}

class _QueueSettingHairdresserState extends State<QueueSettingHairdresser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(child: 
        Text("เซตคิว")),
    );
  }
}