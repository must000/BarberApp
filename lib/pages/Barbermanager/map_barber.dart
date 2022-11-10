import 'package:barber/main.dart';
import 'package:barber/utils/dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_geohash/dart_geohash.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:longdo_maps_api3_flutter/longdo_maps_api3_flutter.dart';

import 'package:barber/Constant/contants.dart';

class MapBarber extends StatefulWidget {
  double lat;
  double lng;
  MapBarber({
    Key? key,
    required this.lat,
    required this.lng,
  }) : super(key: key);

  @override
  State<MapBarber> createState() => _MapBarberState(lat: lat, lng: lng);
}

class _MapBarberState extends State<MapBarber> {
  final map = GlobalKey<LongdoMapState>();
  double lat;
  double lng;
  _MapBarberState({required this.lat, required this.lng});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Contants.myBackgroundColordark,
        title: const Text('Longdo Map'),
      ),
      body: Stack(
        children: [
          LongdoMapWidget(
            apiKey: Contants.keyLongdomap,
            key: map,
            bundleId: Contants.bundleID,
          ),
          Center(
            child: Icon(
              Icons.add,
              color: Contants.colorRed,
              size: 30,
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 40,
          ),
          FloatingActionButton(
            onPressed: () {
              savePostion();
            },
            backgroundColor: Contants.colorYellow,
            child: Icon(
              Icons.save,
              color: Contants.colorOxfordBlue,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            onPressed: () {
              proceedMoveLongdoMap(lat, lng);
            },
            backgroundColor: Contants.colorSpringGreen,
            child: Icon(
              Icons.my_location,
              color: Contants.colorOxfordBlue,
            ),
          ),
        ],
      ),
    );
  }

  Future<Null> savePostion() async {
    MyDialog(funcAction: fc)
        .superDialog(context, "ยืนยันการเปลี่ยนตำแหน่งร้าน", "");
  }

  void fc() async {
    saveData();
  }

  Future<Null> saveData() async {
    var location = await map.currentState?.call("location");
    var latx = cutlat(location);
    var lonx = cutlon(location);
    String path =
        "https://api.longdo.com/map/services/address?lon=$lonx&lat=$latx&nopostcode=0&noroad=0&noaoi=0&noelevation=0&nowater=0&key=${Contants.keyLongdomap}";
    await Dio().get(path).then((value) async {
      if (value.data["province"] == "จ.นนทบุรี") {
        String dis = value.data['district'];
        String dissub = value.data['subdistrict'];
        var geoHasher = GeoHasher();
        String geohash =
            geoHasher.encode(double.parse(lonx), double.parse(latx));
        await FirebaseFirestore.instance
            .collection("Barber")
            .doc(barberModelformanager!.email)
            .update({
          "position": {
            "addressdetails": barberModelformanager!.addressdetails,
            "district": dis,
            "subdistrict": dissub,
            "lat": latx,
            "lng": lonx,
            "geohash": geohash
          }
        }).then((value) {
          Navigator.pop(context);
          setState(() {
            barberModelformanager!.districtl = dis;
            barberModelformanager!.subDistrict = dissub;
            barberModelformanager!.lat = latx;
            barberModelformanager!.lng = lonx;
            barberModelformanager!.geoHasher = geohash;

          });
          MyDialog(funcAction: fc2).hardDialog(context, "", "บันทึกตำแหน่งสำเร็จ");

        });
      } else {
        Navigator.pop(context);
        MyDialog().normalDialog(context, "ร้านไม่ได้อยู่ในจังหวัดนนทบุรี");
      }
    });
  }

  void fc2(){
    Navigator.pop(context);
    Navigator.pop(context);
  }

  cutlon(location) {
    String lon;
    var psLat = location.indexOf('lat');
    lon = location.substring(7, psLat - 2);
    return lon;
  }

  cutlat(location) {
    String lat;
    var psLat = location.indexOf('lat');
    lat = location.substring(psLat + 5, location.length - 1);
    return lat;
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
}
