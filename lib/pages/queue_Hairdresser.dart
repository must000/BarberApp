import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

class QueueHairdresser extends StatefulWidget {
  String email;
  QueueHairdresser({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<QueueHairdresser> createState() => _QueueHairdresserState(email: email);
}

class _QueueHairdresserState extends State<QueueHairdresser> {
  String email;
  _QueueHairdresserState({required this.email});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HorizontalDataTable(
        leftHandSideColumnWidth: 100,
        rightHandSideColumnWidth: 600,
        itemCount: 10,
        isFixedHeader: true,
        headerWidgets: [
          Container(
            child: const Text("เวลา"),
            width: 100,
            height: 56,
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.centerLeft,
          ),
          Container(
            child: const Text("ช่อง 1"),
            width: 100,
            height: 56,
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.centerLeft,
          ),
        Container(
            child: const Text("ช่อง 2"),
            width: 100,
            height: 56,
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.centerLeft,
          ),
         Container(
            child: const Text("ช่อง 3"),
            width: 100,
            height: 56,
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.centerLeft,
          ),
        ],
        leftSideItemBuilder: _generateFirstColumnRow,
        rightSideItemBuilder: (BuildContext context, int index) => Row(
          children: [
            Container(
              child: Text("จิตติ "),
              width: 100,
              height: 52,
              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
              alignment: Alignment.centerLeft,
            ),
            Container(
              child: Text("เทิดสัส "),
              width: 100,
              height: 52,
              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
              alignment: Alignment.centerLeft,
            ),
            Container(
              child: Text("แบล็คไลน์ "),
              width: 100,
              height: 52,
              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
              alignment: Alignment.centerLeft,
            )
          ],
        ),
      ),
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      child: Text("dw"),
      width: 100,
      height: 52,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }
}
