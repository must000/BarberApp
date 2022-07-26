import 'package:flutter/material.dart';

import 'package:barber/data/servicemodel.dart';

class ConfirmQueueUser extends StatefulWidget {
  DateTime datetime;
  String nameUser, nameBarber;
  String emailBarber, idUser;
  List<ServiceModel> servicemodel;

  ConfirmQueueUser({
    Key? key,
    required this.datetime,
    required this.nameUser,
    required this.nameBarber,
    required this.emailBarber,
    required this.idUser,
    required this.servicemodel,
  }) : super(key: key);

  @override
  State<ConfirmQueueUser> createState() => _ConfirmQueueUserState(
      datetime: datetime,
      emailBarber: emailBarber,
      idUser: idUser,
      nameBarber: nameBarber,
      nameUser: nameUser,
      servicemodel: servicemodel);
}

class _ConfirmQueueUserState extends State<ConfirmQueueUser> {
  DateTime datetime;
  String nameUser, nameBarber;
  String emailBarber, idUser;
  List<ServiceModel> servicemodel;
  _ConfirmQueueUserState(
      {required this.datetime,
      required this.nameUser,
      required this.nameBarber,
      required this.emailBarber,
      required this.idUser,
      required this.servicemodel});

  String time = "";
  int timeint = 0, price = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    calculatorTimeandprice();
  }

  calculatorTimeandprice() {
    String timehours;
    int _time = 0, _price = 0;
    for (var i = 0; i < servicemodel.length; i++) {
      _time += servicemodel[i].time.toInt();
    }
    int hour = _time ~/ 60;
    int minutes = _time % 60;
    timehours = '${hour.toString()}:${minutes.toString().padLeft(2, "0")}';
    for (var i = 0; i < servicemodel.length; i++) {
      _price += servicemodel[i].price.toInt();
    }
    setState(() {
      time = timehours;
      timeint = _time;
      price = _price;
    });
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    double fontSize = 17;
    return Scaffold(
        appBar: AppBar(),
        body: Column(children: [
          const SizedBox(
            height: 20,
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: size * 0.16),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Text(
                      "วันที่ ${datetime.day.toString().padLeft(2, "0")} / ${datetime.month.toString().padLeft(2, "0")} / ${datetime.year}",
                      style: TextStyle(fontSize: fontSize),
                    ),
                    Text(
                      "ระยะเวลา $time ชม.    ${datetime.hour.toString().padLeft(2, "0")}.${datetime.minute.toString().padLeft(2, "0")} -  ${datetime.add(Duration(minutes: timeint)).hour.toString().padLeft(2, "0")}.${datetime.add(Duration(minutes: timeint)).minute.toString().padLeft(2, "0")}",
                      style: TextStyle(fontSize: fontSize),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      nameUser,
                      style: TextStyle(fontSize: fontSize),
                    ),
                    Text(
                      "ร้าน " + nameBarber,
                      style: TextStyle(fontSize: fontSize),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: size * 0.16),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        servicemodel[index].name,
                        style: TextStyle(fontSize: fontSize),
                      ),
                      Text(
                        servicemodel[index].price.toString(),
                        style: TextStyle(fontSize: fontSize),
                      )
                    ],
                  ),
                  itemCount: servicemodel.length,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: size * 0.16),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(""),
                      Text(
                        "$price",
                        style: TextStyle(fontSize: fontSize),
                      )
                    ]),
              )
            ],
          )
        ]),
        bottomNavigationBar: BottomAppBar(
          child: Container(
              height: 55,
              child: Row(
                children: [
                  Container(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 67, 165, 58),
                        ),
                        onPressed: () {},
                        child: const Text("ยืนยัน")),
                    width: size * 0.5,
                    height: 55,
                  ),
                  Container(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }, child: const Text("ยกเลิก")),
                    width: size * 0.5,
                    height: 55,
                  ),
                ],
              )),
        ));
  }
}
