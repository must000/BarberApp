import 'package:barber/Constant/contants.dart';
import 'package:barber/utils/dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:longdo_maps_api3_flutter/view.dart';
import 'package:url_launcher/url_launcher.dart';

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
  String? mylat, mylon;

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

  late double latX = double.parse(lat);
  late double lonX = double.parse(lon);

  final map = GlobalKey<LongdoMapState>();

  String? dayC;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dayclose();
    print(dayopen);
    chechpermission();
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

  Future<Null> chechpermission() async {
    bool locationService;
    LocationPermission locationPermission;
    locationService = await Geolocator.isLocationServiceEnabled();
    if (locationService) {
      print("location open");
      locationPermission = await Geolocator.checkPermission();
      if (locationPermission == LocationPermission.denied) {
        locationPermission = await Geolocator.requestPermission();
        if (locationPermission == LocationPermission.deniedForever) {
          // print("LocationPermission.deniedForever");
        } else {
          findposition();
        }
      } else {
        if (locationPermission == LocationPermission.deniedForever) {
        } else {
          findposition();
        }
      }
    } else {}
  }

  Future<Null> findposition() async {
    print("findLatlan ==> Work");
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      mylat = position.latitude.toString();
      mylon = position.longitude.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Contants.myBackgroundColor,
      appBar: AppBar(
        backgroundColor: Contants.myBackgroundColordark,
        title: Text(nameBarber),
      ),
      body: ListView(
        children: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(Contants.colorGreySilver),
            ),
            onPressed: () async {
              if (mylat == "" || mylat == null) {
                MyDialog().normalDialog(
                    context, "กรุณาอนุญาตให้แอปเข้าถึงตำแหน่งของคุณ");
              } else {
                final Uri _url = Uri.parse(
                    "https://www.google.com/maps/dir/'$mylat,$mylon'/$lat,$lon/");
                launchUrl(_url);
              }
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: size * 0.04),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.pin_drop,
                    size: 50,
                  ),
                  Text(
                    "นำทางไปยังร้านทำผม",
                    style: Contants().h3OxfordBlue(),
                  )
                ],
              ),
              color: Contants.colorGreySilver,
              width: size * 0.9,
              height: 100,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          headingDetail(
              "รายละเอียดที่อยู่ : ",
              Icon(
                Icons.pin_drop_outlined,
                color: Contants.colorSpringGreen,
              )),
          contentDetail(addressdetails),
          headingDetail(
              "เวลาเปิด - เวลาปิด",
              Icon(
                Icons.schedule,
                color: Contants.colorSpringGreen,
              )),
          contentDetail("$timeopen - $timeclose น."),
          headingDetail(
              "วันหยุด",
              Icon(
                Icons.calendar_month,
                color: Contants.colorSpringGreen,
              )),
          contentDetail("$dayC"),
          headingDetail(
              "เบอร์ติดต่อ",
              Icon(
                Icons.smartphone,
                color: Contants.colorSpringGreen,
              )),
          contentDetail(phoneNumber),
        ],
      ),
    );
  }

  Container contentDetail(String text) {
    return Container(
      child: Text(
        text,
        style: Contants().h4Grey(),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 45),
    );
  }

  Container headingDetail(String text, Icon icon) {
    return Container(
      child: Row(
        children: [
          icon,
          Text("  $text", style: Contants().h3white()),
        ],
      ),
      margin: const EdgeInsets.all(10),
    );
  }
}
