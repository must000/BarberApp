import 'package:barber/Constant/contants.dart';
import 'package:barber/main.dart';
import 'package:barber/pages/Barbermanager/drawerobject.dart';
import 'package:barber/utils/dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DatePickerBarber extends StatefulWidget {
  DatePickerBarber({
    Key? key,
  }) : super(key: key);

  @override
  State<DatePickerBarber> createState() => _DatePickerBarberState();
}

class _DatePickerBarberState extends State<DatePickerBarber> {
  DateRangePickerController datePickerController = DateRangePickerController();

  List<DateTime>? dateData;
  List<String>? idDate;
  Map? dayss;
  List<int> dayClose = [];
  var alldata;
  Future<Null> getData() async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection("Barber")
        .doc(barberModelformanager!.email)
        .collection("dayclose")
        .get();
    alldata = querySnapshot.docs.map((e) => e.data()).toList();
    List<DateTime> dataEx = [];
    List<String> iddataEx = [];
    for (int n = 0; n < alldata.length; n++) {
      dataEx.add(alldata[n]["dayclosed"].toDate());
      var a = querySnapshot.docs[n];
      iddataEx.add(a.id);
      // print(idDate[n]);
    }
    // print(alldata);
    setState(() {
      dateData = dataEx;
      idDate = iddataEx;
    });
  }

  Future<Null> getDayOpen() async {
    final data = FirebaseFirestore.instance
        .collection('Barber')
        .doc(barberModelformanager!.email);
    final snapshot = await data.get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      dayss = data['dayopen'];
    }
    // print(dayss);
    if (dayss!["su"] == false) {
      dayClose.add(7);
    }
    if (dayss!["mo"] == false) {
      dayClose.add(1);
    }
    if (dayss!["tu"] == false) {
      dayClose.add(2);
    }
    if (dayss!["we"] == false) {
      dayClose.add(3);
    }
    if (dayss!["th"] == false) {
      dayClose.add(4);
    }
    if (dayss!["fr"] == false) {
      dayClose.add(5);
    }
    if (dayss!["sa"] == false) {
      dayClose.add(6);
    }
    setState(() {
      print(dayClose);
    });
  }

  @override
  initState() {
    getData().then((value) {
      print('$dateData $idDate');
      setState(() {});
    });
    getDayOpen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: DrawerObject(),
        appBar: AppBar(
          backgroundColor: Contants.myBackgroundColordark,
        ),
        body: SfDateRangePicker(
          selectionColor: Contants.colorYellow,
          cancelText: "",
          confirmText: "ปิดร้าน",
          onCancel: null,
          backgroundColor: Contants.colorWhite,
          selectionMode: DateRangePickerSelectionMode.single,
          showActionButtons: true,
          controller: datePickerController,
          view: DateRangePickerView.month,
          toggleDaySelection: true,
          onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
            final index = dateData?.indexOf(args.value);
            if (index != -1) {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const ListTile(
                          title: Text("ยกเลิกปิดร้าน"),
                          subtitle: Text("ต้องการเปิดร้านหรือไม่ ? "),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("ยกเลิก")),
                          TextButton(
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection('Barber')
                                    .doc(barberModelformanager!.email)
                                    .collection('dayclose')
                                    .doc(idDate![index!])
                                    .delete()
                                    .then((value) {
                                  Navigator.pop(context);
                                  return getData();
                                });
                              },
                              child: const Text("เปิดร้าน"))
                        ],
                      ));
            }
          },
          minDate: DateTime.now(),
          monthViewSettings: DateRangePickerMonthViewSettings(
            specialDates: dateData,
            weekendDays: dayClose,
          ),
          monthCellStyle: DateRangePickerMonthCellStyle(
            textStyle: Contants().h4OxfordBlue(),
            todayTextStyle: Contants().h4yellow(),
            specialDatesTextStyle: Contants().h4white(),
            weekendTextStyle: Contants().h4white(),
            cellDecoration: BoxDecoration(
                color: Contants.colorWhite,
                border: Border.all(color: Contants.colorBlack, width: 1),
                shape: BoxShape.circle),
            specialDatesDecoration:
                BoxDecoration(color: Contants.colorRed, shape: BoxShape.circle),
         
            weekendDatesDecoration: BoxDecoration(
                color: Contants.colorBlack,
                border: Border.all(color: const Color(0xFFB6B6B6), width: 1),
                shape: BoxShape.circle),
          ),
          enablePastDates: true,
          onSubmit: (value) {
            if (datePickerController.selectedDate == null) {
            } else {
              final index =
                  dateData!.indexOf(datePickerController.selectedDate!);
              if (index != -1) {
                print("ซ้ำ");
              } else {
                DateTime now = new DateTime.now();
                if (datePickerController.selectedDate ==
                        DateTime(now.year, now.month, now.day) ||
                    datePickerController.selectedDate ==
                        DateTime(now.year, now.month, now.day)
                            .add(const Duration(days: 1))) {
                  print("ไม่เกิน 2 วัน");
                  MyDialog().normalDialog(
                      context, "ต้องแจ้งปิดร้านก่อนอย่างน้อย 1 วัน");
                } else {
                  proceedSaveData();
                }
              }
            }
          },
        ));
  }

  Future<Null> proceedSaveData() async {
    await FirebaseFirestore.instance
        .collection('Barber')
        .doc(barberModelformanager!.email)
        .collection('dayclose')
        .add({"dayclosed": datePickerController.selectedDate!}).then(
            (value) => getData());
  }
}
