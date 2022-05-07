import 'package:flutter/material.dart';

class DetailBarberUser extends StatefulWidget {
  final String nameBarber;
  const DetailBarberUser({
    Key? key,
    required this.nameBarber,
  }) : super(key: key);

  @override
  State<DetailBarberUser> createState() =>
      _DetailBarberUserState(nameBarber: nameBarber);
}

class _DetailBarberUserState extends State<DetailBarberUser> {
  String nameBarber;
  _DetailBarberUserState({required this.nameBarber});
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
          contentDetail('หมู่ 5 ซอย18 อยู่หน้าซอย ร้านสีแดง ๆ'),
          headingDetail("เวลาเปิดปิด"),
          contentDetail("08.00-22.00"),
          headingDetail("วันหยุด"),
          contentDetail("พุทธ"),
          headingDetail("เบอร์ติดต่อ"),
          contentDetail("0845525886"),
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
