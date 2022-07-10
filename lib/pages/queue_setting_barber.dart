import 'package:barber/data/breaktimemodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class QueueSettingBarber extends StatefulWidget {
  String email;
  QueueSettingBarber({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<QueueSettingBarber> createState() =>
      _QueueSettingBarberState(email: email);
}

class _QueueSettingBarberState extends State<QueueSettingBarber> {
  String email;
  _QueueSettingBarberState({required this.email});
  int x = 0;
  int? timediff;
  DateTime? timeOpen;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataDayopenandTimeopen();
    getbreaktime();
  }

  Future<Null> getbreaktime() async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection("Barber")
        .doc(email)
        .collection("breaktime")
        .get();
    var alldata = querySnapshot.docs.map((e) => e.data()).toList();
    if (alldata.isNotEmpty) {
      print("มีค่า $alldata");
      for ( var n = 0 ; n < alldata.length ; n++ ){
        listBreakTimeModel.add(BreakTimeModel(day: alldata[n]["day"], time: alldata[n]["time"]));
      }
      print(listBreakTimeModel);

    } else {
      setListdata();
      print("ไม่มีค่า $alldata");
    }
  }

  Future<Null> getDataDayopenandTimeopen() async {
    final data = FirebaseFirestore.instance.collection('Barber').doc(email);
    final snapshot = await data.get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // print(data['timeclose']);
      // print(data['timeopen']);
      print(data["dayopen"]);
      if (data["dayopen"]["mo"] == true) {
        dayOpen.add(
          Container(
            decoration: BoxDecoration(border: Border.all()),
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
          decoration: BoxDecoration(border: Border.all()),
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
          decoration: BoxDecoration(border: Border.all()),
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
          decoration: BoxDecoration(border: Border.all()),
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
          decoration: BoxDecoration(border: Border.all()),
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
          decoration: BoxDecoration(border: Border.all()),
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
          decoration: BoxDecoration(border: Border.all()),
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
      });
    }
  }

  Map? dayss;
  List<Widget> dayOpen = [
    Container(
      decoration: BoxDecoration(border: Border.all()),
      child: const Text("เวลา"),
      width: 100,
      height: 56,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    ),
  ];
  List<String> listdayOpen = [];
  List<Widget> listdata = [];
  List<BreakTimeModel> listBreakTimeModel = [];
  List<List<Widget>> testlistwidget = [
    [
      Container(
        decoration: BoxDecoration(border: Border.all()),
        child: const Text("test1"),
        width: 100,
        height: 56,
        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.centerLeft,
      ),
      Container(
        decoration: BoxDecoration(border: Border.all()),
        child: const Text("test2"),
        width: 100,
        height: 56,
        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.centerLeft,
      ),
    ],
    [
      Container(
        decoration: BoxDecoration(border: Border.all()),
        child: const Text("test1"),
        width: 100,
        height: 56,
        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.centerLeft,
      ),
    ],
    [
      Container(
        decoration: BoxDecoration(border: Border.all()),
        child: const Text("test5"),
        width: 100,
        height: 56,
        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.centerLeft,
      ),
    ],
  ];

  setListdata() {
    for (var n = 1; n < dayOpen.length; n++) {
      listdata.add(
        Container(
          decoration: BoxDecoration(border: Border.all()),
          child: Checkbox(
            onChanged: ((newvalue) {
              setState(() {
                // value = newvalue!;
              });
            }),
            value: listdayOpen.indexOf("")==1 ? true: false
          ),
          width: 100,
          height: 52,
          alignment: Alignment.centerLeft,
        ),
      );
    }
  }

  // bool checking(<Map<String, bool>> ){

  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.save))],
        ),
        body: timediff == null
            ? LoadingAnimationWidget.inkDrop(color: Colors.black, size: 30)
            : HorizontalDataTable(
                leftHandSideColumnWidth: 100,
                rightHandSideColumnWidth: 600,
                itemCount: timediff! * 2,
                isFixedHeader: true,
                headerWidgets: dayOpen,
                leftSideItemBuilder: _generateFirstColumnRow,
                rightSideItemBuilder: (BuildContext context, int index) =>
                    Row(children: listdata),
              ));
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
}
