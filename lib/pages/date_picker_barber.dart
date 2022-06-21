import 'package:barber/utils/show_progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DatePickerBarber extends StatefulWidget {
  String email;
  DatePickerBarber({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<DatePickerBarber> createState() =>
      _DatePickerBarberState(email: this.email);
}

class _DatePickerBarberState extends State<DatePickerBarber> {
  String? email;
  _DatePickerBarberState({required this.email});
  DateRangePickerController datePickerController = DateRangePickerController();

  List<DateTime>? dateData;
  Map? dayss;
  List<int> dayClose = [];

  Future<Null> getData() async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection("Barber")
        .doc(email)
        .collection("dayclose")
        .get();
    var alldata = querySnapshot.docs.map((e) => e.data()).toList();
    List<DateTime> dataEx = [];
    for (int n = 0; n < alldata.length; n++) {
      dataEx.add(alldata[n]["dayclosed"].toDate());
    }
    setState(() {
      dateData = dataEx;
    });
    print("dwrwerw");
  }

  Future<Null> getDayOpen() async {
    final data = FirebaseFirestore.instance.collection('Barber').doc(email);
    final snapshot = await data.get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      dayss = data['dayopen'];
    }
    // print(dayss);
    if (dayss!["tu"]==false) {
      dayClose.add(1);
    }
    if (dayss!["su"]==false) {
      dayClose.add(2);
    }
    if (dayss!["mo"]==false) {
      dayClose.add(3);
    }
    if (dayss!["th"]==false) {
      dayClose.add(4);
    }
    if (dayss!["fr"]==false) {
      dayClose.add(5);
    }
    if (dayss!["sa"]==false) {
      dayClose.add(6);
    }
    if (dayss!["we"]==false) {
      dayClose.add(7);
    }
    setState(() {
      print(dayClose);
    });
  }

  @override
  initState() {
    getData().then((value) {
      print('dddd');
      setState(() {});
    });
    getDayOpen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SfDateRangePicker(
          selectionMode: DateRangePickerSelectionMode.multiple,
          showActionButtons: true,
          controller: datePickerController,
          view: DateRangePickerView.month,
          onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
            // print(args.value);
          },
          // ร้านทำผม ต้องแจ้งปิดร้านก่อน 2 วัน
          minDate: DateTime.now().add(const Duration(days: 2)),
          monthViewSettings: DateRangePickerMonthViewSettings(
            specialDates: dateData,
            weekendDays: dayClose,
          ),
          monthCellStyle: DateRangePickerMonthCellStyle(
            specialDatesDecoration: BoxDecoration(
                color: const Color.fromARGB(255, 182, 28, 17),
                border: Border.all(color: const Color(0xFFF44436), width: 1),
                shape: BoxShape.circle),
            weekendDatesDecoration: BoxDecoration(
                color: const Color.fromARGB(255, 95, 96, 99),
                border: Border.all(color: const Color(0xFFB6B6B6), width: 1),
                shape: BoxShape.circle),
          ),
          onSubmit: (value) {
            if (value == null) {
              print("null");
            } else {
              proceedSaveData();
            }
          },
          onCancel: () {},
        ));
  }

  Future<Null> proceedSaveData() async {
    for (var n = 0; n < datePickerController.selectedDates!.length; n++) {
      await FirebaseFirestore.instance
          .collection('Barber')
          .doc(email)
          .collection('dayclose')
          .add({"dayclosed": datePickerController.selectedDates![n]}).then(
              (value) => getData());
    }
  }
}
