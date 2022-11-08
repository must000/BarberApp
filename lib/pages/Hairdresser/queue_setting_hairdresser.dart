import 'package:barber/utils/dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:barber/Constant/contants.dart';

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
    print(listdayOpen);
    setState(() {
      loading = false;
    });
  }

  List<Widget> dayOpen = [
    Container(
      decoration: BoxDecoration(border: Border.all()),
      child: Text("เวลา" ,style: Contants().h3white()),
      width: 85,
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
  List<String> prepareInsert = [];
  List<String> preparedelete = [];
  double widthSize = 85;
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
            decoration: BoxDecoration(border: Border.all()),
            child:Text("จันทร์ ",style: Contants().h3white()),
            width: widthSize,
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
          child:  Text("อังคาร ",style: Contants().h3white()),
          width: widthSize,
          height: 56,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ));
        listdayOpen.add("tu");
      }
      if (data["dayopen"]["we"] == true) {
        dayOpen.add(Container(
          decoration: BoxDecoration(border: Border.all()),
          child:  Text("พุธ ",style: Contants().h3white()),
          width: widthSize,
          height: 56,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ));
        listdayOpen.add("we");
      }
      if (data["dayopen"]["th"] == true) {
        dayOpen.add(Container(
          decoration: BoxDecoration(border: Border.all()),
          child: Text("พฤหัสบดี ",style: Contants().h3white()),
          width: widthSize,
          height: 56,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ));
        listdayOpen.add("th");
      }
      if (data["dayopen"]["fr"] == true) {
        dayOpen.add(Container(
          decoration: BoxDecoration(border: Border.all()),
          child: Text("ศุกร์ ",style: Contants().h3white()),
          width: widthSize,
          height: 56,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ));
        listdayOpen.add("fr");
      }
      if (data["dayopen"]["sa"] == true) {
        dayOpen.add(Container(
          decoration: BoxDecoration(border: Border.all()),
          child: Text("เสาร์ ",style: Contants().h3white()),
          width: widthSize,
          height: 56,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ));
        listdayOpen.add("sa");
      }
      if (data["dayopen"]["su"] == true) {
        dayOpen.add(Container(
          decoration: BoxDecoration(border: Border.all()),
          child: Text("อาทิตย์ ",style: Contants().h3white()),
          width: widthSize,
          height: 56,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ));
        listdayOpen.add("su");
      }
      DateTime t1 = DateFormat('yyyyy-MM-dd HH:mm:ss')
          .parse('2022-04-03 ${data["timeopen"].replaceAll(' ', '')}:00');
      DateTime t2 = DateFormat('yyyyy-MM-dd HH:mm:ss')
          .parse('2022-04-03 ${data["timeclose"].replaceAll(' ', '')}:00');
      Duration diff = t2.difference(t1);
      timeOpen = DateFormat('yyyyy-MM-dd HH:mm:ss')
          .parse('2022-04-03 ${data["timeopen"].replaceAll(' ', '')}:00');
      setState(() {
        timediff = diff.inHours;
        listdayOpen;
      });
    }
  }

  Future<Null> process() async {
    for (var n = 0; n < preparedelete.length; n++) {
      try {
        await FirebaseFirestore.instance
            .collection('Hairdresser')
            .doc(idHairdresser)
            .collection('breakTime')
            .where("break", isEqualTo: preparedelete[n])
            .get()
            .then((value) {
          value.docs[0].reference.delete();
          print("ลบสำเร็จ");
        });
      } catch (e) {
        print("is an error $e");
      }
    }
    for (var i = 0; i < prepareInsert.length; i++) {
      await FirebaseFirestore.instance
          .collection('Hairdresser')
          .doc(idHairdresser)
          .collection('breakTime')
          .add({"break": prepareInsert[i]});
    }
  }

  void fc() {
    process().then((value) {
      bleaktimemockup.clear();
      prepareInsert.clear();
      Navigator.pop(context);
      getbreakTime();
      MyDialog().normalDialog(context, "บันทึกเวลาพักสำเร็จ");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("เลือกเวลาพัก",style: Contants().h3white(),),
          backgroundColor: Contants.myBackgroundColordark,
          actions: [
            IconButton(
                onPressed: () {
                  if (prepareInsert.isNotEmpty && preparedelete.isEmpty) {
                    // เพิ่มข้อมูล อย่างเดียว
                    MyDialog(funcAction: fc)
                        .confirmBreakTimeDialog(context, prepareInsert);
                  } else if (prepareInsert.isEmpty &&
                      preparedelete.isNotEmpty) {
                    MyDialog(funcAction: fc)
                        .confirmBreakTimeDialog(context, prepareInsert);
                    // ลบอย่างเดียว
                  } else if (prepareInsert.isNotEmpty &&
                      preparedelete.isNotEmpty) {
                    MyDialog(funcAction: fc)
                        .confirmBreakTimeDialog(context, prepareInsert);
                  } else {
                    print("ไม่มีข้อมูล ที่จะinsert");
                  }
                },
                icon: const Icon(Icons.save))
          ],
        ),
        backgroundColor: Contants.myBackgroundColor,
        body: timediff == null
            ? LoadingAnimationWidget.inkDrop(color: Colors.black, size: 30)
            : HorizontalDataTable(
                leftHandSideColumnWidth: widthSize,
                rightHandSideColumnWidth: listdayOpen.length * widthSize,
                rightHandSideColBackgroundColor: Contants.colorOxfordBlue,
                leftHandSideColBackgroundColor: Contants.colorOxfordBlue,
                itemCount: timediff! * 2,
                isFixedHeader: true,
                headerWidgets: dayOpen,
                leftSideItemBuilder: _generateFirstColumnRow,
                rightSideItemBuilder: _generateRightHandSideColumnRow));
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      child: Text(
          "${timeOpen!.add(Duration(minutes: index * 30)).hour.toString().padLeft(2, "0")} : ${timeOpen!.add(Duration(minutes: index * 30)).minute.toString().padLeft(2, "0")}",style: Contants().h3white(),),
      width: widthSize,
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
      listdata.add(Container(
        decoration: BoxDecoration(border: Border.all()),
        width: widthSize,
        height: 52,
        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.centerLeft,
        child: Checkbox(
            checkColor: Contants.colorBlack,
            activeColor: Colors.red,
            // tristate: ,
            value: value,
            onChanged: (newvalue) {
              if (newvalue == true) {
                setState(() {
                  bleaktimemockup.add(
                      "${listdayOpen[i]} ${timeOpen!.add(Duration(minutes: index * 30)).hour.toString().padLeft(2, "0")}.${timeOpen!.add(Duration(minutes: index * 30)).minute.toString().padLeft(2, "0")}");
                  prepareInsert.add(
                      "${listdayOpen[i]} ${timeOpen!.add(Duration(minutes: index * 30)).hour.toString().padLeft(2, "0")}.${timeOpen!.add(Duration(minutes: index * 30)).minute.toString().padLeft(2, "0")}");
                  preparedelete.remove(
                      "${listdayOpen[i]} ${timeOpen!.add(Duration(minutes: index * 30)).hour.toString().padLeft(2, "0")}.${timeOpen!.add(Duration(minutes: index * 30)).minute.toString().padLeft(2, "0")}");
                });
                print(bleaktimemockup);
                print(prepareInsert);
                print(preparedelete);
              } else {
                setState(() {
                  bleaktimemockup.remove(
                      "${listdayOpen[i]} ${timeOpen!.add(Duration(minutes: index * 30)).hour.toString().padLeft(2, "0")}.${timeOpen!.add(Duration(minutes: index * 30)).minute.toString().padLeft(2, "0")}");
                  prepareInsert.remove(
                      "${listdayOpen[i]} ${timeOpen!.add(Duration(minutes: index * 30)).hour.toString().padLeft(2, "0")}.${timeOpen!.add(Duration(minutes: index * 30)).minute.toString().padLeft(2, "0")}");

                  preparedelete.add(
                      "${listdayOpen[i]} ${timeOpen!.add(Duration(minutes: index * 30)).hour.toString().padLeft(2, "0")}.${timeOpen!.add(Duration(minutes: index * 30)).minute.toString().padLeft(2, "0")}");
                });
                print(bleaktimemockup);
                print(prepareInsert);
                print(preparedelete);
              }
            }),
      ));
    }
    return Row(children: listdata);
  }
}
