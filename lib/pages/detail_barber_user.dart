import 'package:barber/Constant/contants.dart';
import 'package:flutter/material.dart';
import 'package:longdo_maps_api3_flutter/view.dart';

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
  State<DetailBarberUser> createState() => _DetailBarberUserState(
      nameBarber: nameShop,
      lat: lat,
      lon: lon,
      addressdetails: addressdetails,
      phoneNumber: phoneNumber,
      timeopen: timeopen,
      timeclose: timeclose,
      dayopen: dayopen);
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

  final map = GlobalKey<LongdoMapState>();
  String? dayC;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dayclose();
    print(dayopen);
    // proceedMoveLongdoMap(double.parse(lat), double.parse(lon));
  }

  dayclose() {
    String dayclose = "";

    if (dayopen['su'] == false) {
      dayclose = "$dayclose อาทิตย์";
    }
    if (dayopen['mo'] == false) {
      dayclose = "$dayclose จันทร์";
    }
    if (dayopen['tu'] == false) {
      dayclose = "$dayclose อังคาร";
    }
    if (dayopen['we'] == false) {
      dayclose = "$dayclose พุธ";
    }
    if (dayopen['th'] == false) {
      dayclose = "$dayclose พฤหัสบดี";
    }
    if (dayopen['fr'] == false) {
      dayclose = "$dayclose ศุกร์";
    }
    if (dayopen['sa'] == false) {
      dayclose = "$dayclose เสาร์";
    }

    setState(() {
      dayC = dayclose;
    });
  }

  proceedMoveLongdoMap(double lat, double lng) async {
    await map.currentState?.call(
      "location",
      [
        {
          "lon": lng,
          "lat": lat,
        },
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(nameBarber),
      ),
      body: ListView(
        children: [
          // Container(
          //   child: LongdoMapWidget(
          //     apiKey: Contants.keyLongdomap,
          //     key: map,
          //     bundleId: Contants.bundleID,
          //   ),
          //   width: size * 0.9,
          //   height: 250,
          // ),
          headingDetail("รายละเอียดที่อยู่ : "),
          contentDetail('$addressdetails'),
          headingDetail("เวลาเปิดปิด"),
          contentDetail("$timeopen - $timeclose"),
          headingDetail("วันหยุด"),
          contentDetail("$dayC"),
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
