import 'package:flutter/material.dart';

class DetailBarberUser extends StatefulWidget {
  final String nameShop,
      lat,
      lon,
      addressdetails,
      phoneNumber,
      timeopen,
      timeclose;
  Map<String, dynamic> dayopen;
  DetailBarberUser({
    Key? key,
    required this.nameShop,
    required this.lat,
    required this.lon,
    required this.addressdetails,
    required this.phoneNumber,
    required this.timeopen,
    required this.timeclose,
    required this.dayopen,
  }) : super(key: key);

  @override
  State<DetailBarberUser> createState() =>
      _DetailBarberUserState(nameBarber: nameShop,lat: lat,lon: lon,addressdetails: addressdetails,phoneNumber: phoneNumber,timeopen: timeopen,timeclose: timeclose,dayopen: dayopen);
}

class _DetailBarberUserState extends State<DetailBarberUser> {
  String nameBarber;
  String lat, lon;
  String addressdetails, phoneNumber;
  Map<String, dynamic> dayopen;
  String timeopen, timeclose;
  _DetailBarberUserState(
      {required this.nameBarber,
      required this.addressdetails,
      required this.phoneNumber,
      required this.dayopen,
      required this.timeopen,
      required this.timeclose,
      required this.lat,
      required this.lon});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nameBarber),
      ),
      body: ListView(
        children: [
          Container(
            height: 200,
            child: const Text(""),
            decoration: const BoxDecoration(color: Colors.green),
            margin: const EdgeInsets.all(10),
          ),
          headingDetail("รายละเอียดที่อยู่ : "),
          contentDetail('$addressdetails'),
          headingDetail("เวลาเปิดปิด"),
          contentDetail("$timeopen - $timeclose"),
          headingDetail("วันหยุด"),
          contentDetail("----"),
          headingDetail("เบอร์ติดต่อ"),
          contentDetail("$phoneNumber"),
        ],
      ),
    );
  }

  Container contentDetail(String text) {
    return Container(
      child: Text(text),
      margin: const EdgeInsets.symmetric(horizontal: 22),
    );
  }

  Container headingDetail(String text) {
    return Container(
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
        ),
      ),
      margin: const EdgeInsets.all(10),
    );
  }
}
