import 'package:barber/Constant/contants.dart';
import 'package:barber/data/queuemodel3.dart';
import 'package:barber/main.dart';
import 'package:barber/pages/Barbermanager/drawerobject.dart';
import 'package:barber/pages/Barbermanager/reservation_detail_barber.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../data/chart_data_model.dart';

class StatisticeBarber extends StatefulWidget {
  const StatisticeBarber({Key? key}) : super(key: key);

  @override
  State<StatisticeBarber> createState() => _StatisticeBarberState();
}

class _StatisticeBarberState extends State<StatisticeBarber> {
  bool clickList = true;
  int clickListIndex = 1;
  String selectedMonth = "เดือน";
  String selectedyear = "2022";
  DateTime selectedDate = DateTime.now();
  bool loadingGetRes = true;
  List<String> year = [
    "2022",
    "2023",
    "2024",
    "2025",
    "2026",
  ];
  List<String> items = [
    "มกราคม ",
    "กุมภาพันธ์ ",
    "มีนาคม ",
    "เมษายน ",
    "พฤษภาคม ",
    "มิถุนายน ",
    "กรกฎาคม ",
    "สิงหาคม ",
    "กันยายน ",
    "ตุลาคม ",
    "พฤศจิกายน ",
    "ธันวาคม "
  ];
  List<ChartData> datas = [];
  List<double> listsum = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getReservation();
  }

  Future<Null> getReservationForChart() async {
    var filterstart = selectedyear;
    int v = int.parse(selectedyear) + 1;
    var filterend = "$v";
    await FirebaseFirestore.instance
        .collection('Queue')
        .where("barber.id", isEqualTo: barberModelformanager!.email)
        .where("status", isEqualTo: "succeed")
        .orderBy("time.timestart")
        .startAt([filterstart])
        .endAt([filterend])
        .get()
        .then((value) {
          List<ChartData> data = [];
          List<double> sumMount = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
          if (value.docs.isNotEmpty) {
            for (var i = 0; i < value.docs.length; i++) {
              double sumprice = 0;
              for (var n = 0; n < value.docs[i]["service"].length; n++) {
                sumprice += value.docs[i]["service"][n]["price"].toDouble();
                print("PP $sumprice");
              }
              sumMount[int.parse(
                      value.docs[i]["time"]["timestart"].substring(5, 7))] =
                  sumMount[int.parse(
                          value.docs[i]["time"]["timestart"].substring(5, 7))] +
                      sumprice;
            }
            for (var k = 0; k <= 11; k++) {
              String mon = "";
              switch (items[k]) {
                case "มกราคม ":
                  mon = "ม.ค.";

                  break;
                case "กุมภาพันธ์ ":
                  mon = "ก.พ.";

                  break;
                case "มีนาคม ":
                  mon = "มี.ค.";

                  break;
                case "เมษายน ":
                  mon = "เม.ย.";
                  break;
                case "พฤษภาคม ":
                  mon = "พ.ค.";

                  break;
                case "มิถุนายน ":
                  mon = "มิ.ย.";

                  break;
                case "กรกฎาคม ":
                  mon = "ก.ค.";
                  break;
                case "สิงหาคม ":
                  mon = "ส.ค.";

                  break;
                case "กันยายน ":
                  mon = "ก.ย.";

                  break;
                case "ตุลาคม ":
                  mon = "ต.ค.";

                  break;
                case "พฤศจิกายน ":
                  mon = "พ.ย.";

                  break;
                case "ธันวาคม ":
                  mon = "ธ.ค.";

                  break;

                default:
                  mon = "";
              }
              data.add(ChartData(mon, sumMount[k]));
            }
            setState(() {
              datas = data;
              listsum = sumMount;
            });
          } else {
            setState(() {
              datas.clear();
              listsum.clear();
            });
          }
        });
  }

  List<QueueModel3> reservation = [];
  Future<Null> getReservation() async {
    var filterstart = "2022";
    var filterend = "2023";
    if (clickListIndex == 1) {
      filterstart = selectedyear;
      int x = int.parse(selectedyear) + 1;
      filterend = x.toString();
    } else if (clickListIndex == 2) {
      String x;
      String? n;
      switch (selectedMonth) {
        case "มกราคม ":
          x = "01";
          n = "02";
          break;
        case "กุมภาพันธ์ ":
          x = "02";
          n = "03";
          break;
        case "มีนาคม ":
          x = "03";
          n = "04";

          break;
        case "เมษายน ":
          x = "04";
          n = "05";

          break;
        case "พฤษภาคม ":
          x = "05";
          n = "06";

          break;
        case "มิถุนายน ":
          x = "06";
          n = "07";

          break;
        case "กรกฎาคม ":
          x = "07";
          n = "08";

          break;
        case "สิงหาคม ":
          x = "08";
          n = "09";

          break;
        case "กันยายน ":
          x = "09";
          n = "10";

          break;
        case "ตุลาคม ":
          x = "10";
          n = "11";

          break;
        case "พฤศจิกายน ":
          x = "11";
          n = "12";

          break;
        case "ธันวาคม ":
          x = "12";
          n = "13";
          break;
        default:
          x = "13";
      }
      if (x == "13") {
        filterstart = "$selectedyear-01";
        filterend = "$selectedyear-12";
        print("fdwdq $selectedyear");
      } else {
        filterstart = "$selectedyear-$x";
        filterend = "$selectedyear-$n";
        print("fdwdqdqw");
        print("fdwdq ${selectedyear}PP");
      }
    } else {
      filterstart =
          "${selectedDate.year.toString()}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";

      DateTime dayEnd = selectedDate.add(const Duration(days: 1));
      filterend =
          "${dayEnd.year.toString()}-${dayEnd.month.toString().padLeft(2, '0')}-${dayEnd.day.toString().padLeft(2, '0')}";
    }
    print(filterstart);
    print(filterend);
    await FirebaseFirestore.instance
        .collection('Queue')
        .where("barber.id", isEqualTo: barberModelformanager!.email)
        .orderBy("time.timestart")
        .startAt([filterstart])
        .endAt([filterend])
        .get()
        .then((value) {
          List<QueueModel3> data = [];
          if (value.docs.isNotEmpty) {
            for (var i = 0; i < value.docs.length; i++) {
              double price = 0;
              for (var n = 0; n < value.docs[i]["service"].length; n++) {
                price += value.docs[i]["service"][n]["price"];
              }
              String time = dateTime(value.docs[i]["time"]["timestart"],
                  value.docs[i]["time"]["timeend"]);
              data.add(QueueModel3(
                  idQueue: value.docs[i].id,
                  nameHairdresser: value.docs[i]["barber"]["name"],
                  time: time,
                  status: value.docs[i]["status"],
                  price: price));
            }
            setState(() {
              reservation = data;
              loadingGetRes = false;
            });
          } else {
            setState(() {
              loadingGetRes = false;
            });
          }
        });
  }

  String dateTime(var timestart, var timeend) {
    DateTime start = DateTime.parse(timestart);
    DateTime end = DateTime.parse(timeend);
    return "${start.day}/${start.month}/${start.year} ${start.hour.toString().padLeft(2, "0")}.${start.minute.toString().padLeft(2, "0")} - ${end.hour.toString().padLeft(2, "0")}.${end.minute.toString().padLeft(2, "0")}";
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Contants.myBackgroundColordark,
        ),
        backgroundColor: Contants.myBackgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    child: TextButton(
                        onPressed: () {
                          setState(() {
                            clickList = true;
                          });
                        },
                        child: Text(
                          "ประวัติ",
                          style: clickList
                              ? Contants().h3yellow()
                              : Contants().h3Grey(),
                        )),
                    width: size * 0.5,
                  ),
                  SizedBox(
                    child: TextButton(
                        onPressed: () {
                          setState(() {
                            clickList = false;
                          });
                          getReservationForChart();
                        },
                        child: Text("กราฟ",
                            style: clickList == false
                                ? Contants().h3yellow()
                                : Contants().h3Grey())),
                    width: size * 0.5,
                  ),
                ],
              ),
              clickList ? buildListReseve() : buildCharts()
            ],
          ),
        ),
        drawer: DrawerObject());
  }

  Column buildCharts() {
    return Column(
      children: [
        datas == []
            ? const SizedBox()
            : SfCartesianChart(
                title: ChartTitle(
                    text: "รายได้ ในปี $selectedyear",
                    textStyle: Contants().h3white()),
                primaryXAxis: CategoryAxis(maximumLabelWidth: 30),
                series: <ColumnSeries<ChartData, String>>[
                  ColumnSeries<ChartData, String>(
                    color: Contants.colorSpringGreen,
                    // Binding the chartData to the dataSource of the column series.
                    dataSource: datas,
                    xValueMapper: (ChartData sales, _) => sales.x,
                    yValueMapper: (ChartData sales, _) => sales.y,
                  ),
                ],
              ),
        datas == [] || listsum == []
            ? const SizedBox()
            : ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  if (index == listsum.length) {
                    double sum = 0;
                    for (var i = 0; i < listsum.length; i++) {
                      sum += listsum[i];
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 20),
                          width: 100,
                          child: Text(
                            "รวม",
                            style: Contants().h3yellow(),
                          ),
                        ),
                        Container(
                          width: 100,
                          child: Text(
                            sum.toStringAsFixed(2),
                            style: Contants().h3SpringGreen(),
                            textAlign: TextAlign.right,
                          ),
                        )
                      ],
                    );
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 20),
                          width: 100,
                          child: Text(
                            items[index],
                            style: Contants().h3white(),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: Text(
                            listsum[index].toStringAsFixed(2),
                            style: Contants().h3SpringGreen(),
                            textAlign: TextAlign.right,
                          ),
                        )
                      ],
                    );
                  }
                },
                itemCount: listsum.length + 1,
              )
      ],
    );
  }

  Column buildListReseve() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  clickListIndex = 1;
                  loadingGetRes = true;
                  reservation.clear();
                });
                getReservation();
              },
              child: Text(
                "ปี",
                style: Contants().h3OxfordBlue(),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    clickListIndex == 1
                        ? Contants.colorSpringGreen
                        : Contants.colorGreySilver),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  clickListIndex = 2;
                  loadingGetRes = true;
                  reservation.clear();
                });
                getReservation();
              },
              child: Text(
                "เดือน",
                style: Contants().h3OxfordBlue(),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    clickListIndex == 2
                        ? Contants.colorSpringGreen
                        : Contants.colorGreySilver),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  clickListIndex = 3;
                  loadingGetRes = true;
                  reservation.clear();
                });
                getReservation();
              },
              child: Text(
                "วัน",
                style: Contants().h3OxfordBlue(),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    clickListIndex == 3
                        ? Contants.colorSpringGreen
                        : Contants.colorGreySilver),
              ),
            )
          ],
        ),
        clickListIndex != 1
            ? clickListIndex == 2
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 120,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            iconEnabledColor: Contants.colorWhite,
                            hint: Text(
                              selectedyear,
                              style: Contants().h4white(),
                            ),
                            items: year
                                .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(item,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Contants.colorOxfordBlue)),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              selectedyear = value as String;
                              setState(() {
                                loadingGetRes = true;
                                reservation.clear();
                              });
                              getReservation();
                            },
                          ),
                        ),
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          iconEnabledColor: Contants.colorWhite,
                          hint: Text(
                            selectedMonth,
                            style: Contants().h4white(),
                          ),
                          items: items
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(item,
                                        style: Contants().h4OxfordBlue()),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            selectedMonth = value as String;
                            setState(() {
                              loadingGetRes = true;
                              reservation.clear();
                            });
                            getReservation();
                          },
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: 30,
                        child: Text(
                          " ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                          style: Contants().h3SpringGreen(),
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Contants.colorSpringGreen),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Contants.colorSpringGreen),
                          ),
                          onPressed: () {
                            loadingGetRes = true;
                            _selectedDate(context);
                          },
                          child: Text(
                            "เปลี่ยนวันที่ ",
                            style: Contants().h3Red(),
                          ),
                        ),
                      )
                    ],
                  )
            : Center(
                child: SizedBox(
                  width: 60,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      iconEnabledColor: Contants.colorWhite,
                      hint: Text(
                        selectedyear,
                        style: Contants().h4white(),
                      ),
                      items: year
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(item,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Contants.colorOxfordBlue)),
                              ))
                          .toList(),
                      onChanged: (value) {
                        selectedyear = value as String;
                        setState(() {
                          loadingGetRes = true;
                          reservation.clear();
                        });
                        getReservation();
                      },
                    ),
                  ),
                ),
              ),
        loadingGetRes
            ? LoadingAnimationWidget.beat(
                color: Contants.colorSpringGreen, size: 30)
            : reservation.isEmpty
                ? Center(
                    child: Text(
                      "ไม่พบประวัติคิว",
                      style: Contants().h3Red(),
                    ),
                  )
                : ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        print(reservation[index].idQueue);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReservationDetailBarber(
                                id: reservation[index].idQueue,
                                time: reservation[index].time,
                              ),
                            ));
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(
                            reservation[index].nameHairdresser,
                            style: Contants().h4OxfordBlue(),
                          ),
                          subtitle: Text(
                            reservation[index].time,
                            style: Contants().h4Grey(),
                          ),
                          leading: reservation[index].status == "on"
                              ? Text(
                                  "รอ",
                                  style: Contants().h3yellow(),
                                )
                              : reservation[index].status == "succeed"
                                  ? Text(
                                      "สำเร็จ",
                                      style: Contants().h3SpringGreen(),
                                    )
                                  : Text("ยกเลิก", style: Contants().h3Red()),
                          trailing: Text(
                            "${reservation[index].price.toStringAsFixed(0)} บาท",
                            style: Contants().h3Red(),
                          ),
                        ),
                      ),
                    ),
                    itemCount: reservation.length,
                  )
      ],
    );
  }


  Future _selectedDate(BuildContext context) async {



    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2022),
        lastDate: DateTime(2023));
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      setState(() {
        reservation.clear();
      });
      getReservation();
    }
  }
}
