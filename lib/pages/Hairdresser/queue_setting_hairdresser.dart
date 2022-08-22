import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:barber/Constant/contants.dart';
import 'package:barber/pages/test.dart';

class QueueSettingHairdresser extends StatefulWidget {
  String emailBarber;
  String idHairdresser;
  QueueSettingHairdresser({
    Key? key,
    required this.emailBarber,
    required this.idHairdresser,
  }) : super(key: key);

  @override
  State<QueueSettingHairdresser> createState() => _QueueSettingHairdresserState(
      emailBarber: emailBarber, idHairdresser: idHairdresser);
}

class _QueueSettingHairdresserState extends State<QueueSettingHairdresser> {
  String emailBarber;
  String idHairdresser;
  _QueueSettingHairdresserState(
      {required this.emailBarber, required this.idHairdresser});
  bool loading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataDayopenandTimeopen().then((value) => getbreakTime());
  }

  Future<Null> getbreakTime() async {
    var data = await FirebaseFirestore.instance
        .collection('Hairdresser')
        .doc(idHairdresser)
        .collection("breakTime")
        .get();
    List<Map<String, dynamic>> alldata;
    alldata = data.docs.map((e) => e.data()).toList();
    for (int n = 0; n < alldata.length; n++) {
      bleaktimemockup.add(alldata[n]["break"]);
    }
    setState(() {
      loading = false;
    });
  }

  List<Widget> dayOpen = [
    Container(
      child: const Text("เวลา"),
      width: 100,
      height: 56,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    ),
  ];

  List<String> listdayOpen = [];
  int? timediff;
  DateTime? timeOpen;
  List<Widget> listdata = [];
  List<String> bleaktimemockup = [];
  Future<Null> getDataDayopenandTimeopen() async {
    print("dwdwrwr");
    final data =
        FirebaseFirestore.instance.collection('Barber').doc(emailBarber);
    final snapshot = await data.get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      print(data['timeclose']);
      print(data['timeopen']);
      print(data["dayopen"]);
      if (data["dayopen"]["mo"] == true) {
        dayOpen.add(
          Container(
            // decoration: BoxDecoration(border: Border.all()),
            child: const Text("จันทร์ "),
            width: 100,
            height: 56,
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.centerLeft,
          ),
        );
        listdayOpen.add("mo");
      }
      if (data["dayopen"]["tu"] == true) {
        dayOpen.add(Container(
          // decoration: BoxDecoration(border: Border.all()),
          child: const Text("อังคาร "),
          width: 100,
          height: 56,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ));
        listdayOpen.add("tu");
      }
      if (data["dayopen"]["we"] == true) {
        dayOpen.add(Container(
          // decoration: BoxDecoration(border: Border.all()),
          child: const Text("พุธ "),
          width: 100,
          height: 56,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ));
        listdayOpen.add("we");
      }
      if (data["dayopen"]["th"] == true) {
        dayOpen.add(Container(
          // decoration: BoxDecoration(border: Border.all()),
          child: const Text("พฤหัสบดี "),
          width: 100,
          height: 56,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ));
        listdayOpen.add("th");
      }
      if (data["dayopen"]["fr"] == true) {
        dayOpen.add(Container(
          // decoration: BoxDecoration(border: Border.all()),
          child: const Text("ศุกร์ "),
          width: 100,
          height: 56,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ));
        listdayOpen.add("fr");
      }
      if (data["dayopen"]["sa"] == true) {
        dayOpen.add(Container(
          // decoration: BoxDecoration(border: Border.all()),
          child: const Text("เสาร์ "),
          width: 100,
          height: 56,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ));
        listdayOpen.add("sa");
      }
      if (data["dayopen"]["su"] == true) {
        dayOpen.add(Container(
          // decoration: BoxDecoration(border: Border.all()),
          child: const Text("อาทิตย์ "),
          width: 100,
          height: 56,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ));
        listdayOpen.add("su");
      }
      DateTime t1 = DateFormat('yyyyy-MM-dd HH:mm:ss')
          .parse('2020-04-03 ${data["timeopen"].replaceAll(' ', '')}:00');
      DateTime t2 = DateFormat('yyyyy-MM-dd HH:mm:ss')
          .parse('2020-04-03 ${data["timeclose"].replaceAll(' ', '')}:00');
      Duration diff = t2.difference(t1);
      timeOpen = DateFormat('yyyyy-MM-dd HH:mm:ss')
          .parse('2020-04-03 ${data["timeopen"].replaceAll(' ', '')}:00');
      setState(() {
        timediff = diff.inHours;
        listdayOpen;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Contants.myBackgroundColordark,
        ),
        backgroundColor: Contants.myBackgroundColor,
        body: timediff == null
            ? LoadingAnimationWidget.inkDrop(color: Colors.black, size: 30)
            : HorizontalDataTable(
                leftHandSideColumnWidth: 100,
                rightHandSideColumnWidth: 600,
                itemCount: timediff! * 2,
                isFixedHeader: true,
                headerWidgets: dayOpen,
                leftSideItemBuilder: _generateFirstColumnRow,
                rightSideItemBuilder: _generateRightHandSideColumnRow));
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      child: Text(
          "${timeOpen!.add(Duration(minutes: index * 30)).hour.toString().padLeft(2, "0")} : ${timeOpen!.add(Duration(minutes: index * 30)).minute.toString().padLeft(2, "0")}"),
      width: 100,
      height: 52,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    listdata.clear();
    for (var i = 0; i < listdayOpen.length; i++) {
      bool value = false;
      if (bleaktimemockup.contains(
          "${listdayOpen[i]} ${timeOpen!.add(Duration(minutes: index * 30)).hour.toString().padLeft(2, "0")}.${timeOpen!.add(Duration(minutes: index * 30)).minute.toString().padLeft(2, "0")}")) {
        value = true;
      }
      listdata.add(SizedBox(
        child: Checkbox(
            value: value,
            onChanged: (newvalue) {
              print(
                  "${timeOpen!.add(Duration(minutes: index * 30)).hour.toString().padLeft(2, "0")}.${timeOpen!.add(Duration(minutes: index * 30)).minute.toString().padLeft(2, "0")}");
              print(listdayOpen[i]);
              if (newvalue == true) {
                setState(() {
                  bleaktimemockup.add(
                      "${listdayOpen[i]} ${timeOpen!.add(Duration(minutes: index * 30)).hour.toString().padLeft(2, "0")}.${timeOpen!.add(Duration(minutes: index * 30)).minute.toString().padLeft(2, "0")}");
                  // value = true;
                });
              }
            }),
            width: 100,height: 52,
      ));
    }
    return Row(children: listdata);
  }
}
