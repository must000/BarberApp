// import 'package:barber/pages/Authentication/register_phone_user.dart';
// import 'package:barber/utils/dialog.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dart_geohash/dart_geohash.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:longdo_maps_api3_flutter/longdo_maps_api3_flutter.dart';
// import 'package:barber/Constant/contants.dart';



// class InsertPositionBarber extends StatefulWidget {
//   InsertPositionBarber({
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<InsertPositionBarber> createState() => _InsertPositionBarberState();
// }

// class _InsertPositionBarberState extends State<InsertPositionBarber> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     print("dddsd");
//     chechpermission();
//   }

//   Future<Null> chechpermission() async {
//     bool locationService;
//     LocationPermission locationPermission;
//     locationService = await Geolocator.isLocationServiceEnabled();
//     if (locationService) {
//       print("location open");
//       locationPermission = await Geolocator.checkPermission();
//       if (locationPermission == LocationPermission.denied) {
//         locationPermission = await Geolocator.requestPermission();
//         if (locationPermission == LocationPermission.deniedForever) {
//           MyDialog().alertLocation(
//               context, "ไม่อนุญาตแชร์ Locationn", "โปรดแชร์ location");
//         } else {
//           findLatLng();
//         }
//       } else {
//         if (locationPermission == LocationPermission.deniedForever) {
//           MyDialog().alertLocation(
//               context, "ไม่อนุญาตแชร์ Locationn", "โปรดแชร์ location");
//         } else {
//           findLatLng();
//         }
//       }
//     } else {
//       MyDialog().alertLocation(
//           context, "Location service close", "please open locaation service");
//     }
//   }

//   Future<Null> findLatLng() async {
//     print("findLatlan ==> Work");
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     print("${position.longitude}is a position");
//     print(position.latitude);
//     setState(() {
//       lat = position.latitude;
//       lng = position.longitude;
//       print("lat = $lat" + "lng = $lng");
//     });
//   }

//   bool _animation = false;
//   double? lat;
//   double? lng;
//   TextEditingController detailController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {

//     Object? marker = mapbarber.currentState?.object(
//       "Marker",
//       "1",
//       [
//         {
//           "lon": double.parse(cutlon(mapbarber.currentState?.call("location"))),
//           "lat": double.parse(cutlat(mapbarber.currentState?.call("location")))
//         },
//         {"detail": "Home"}
//       ],
//     );
//     return MaterialApp(
//       // scaffoldMessengerKey: messenger,
//        home:  Scaffold(
//         appBar: AppBar(
//           backgroundColor: Contants.myBackgroundColordark,
//           title: const Text('Longdo Map'),
//           actions: [
//             IconButton(
//                 onPressed: () {
//                   inputpostion();
//                 },
//                 icon: Icon(
//                   Icons.next_plan,
//                   color: Contants.colorSpringGreen,
//                 ))
//           ],
//         ),
//         body: Stack(
//           children: [
//             LongdoMapWidget(
//               apiKey: Contants.keyLongdomap,
//               key: mapbarber,
//               bundleId: Contants.bundleID,
//             ),
//             Center(
//               child: Icon(
//                 Icons.add,
//                 color: Contants.colorRed,
//                 size: 30,
//               ),
//             )
//           ],
//         ),
//         floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
//         floatingActionButton: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             FloatingActionButton(
//               onPressed: () {
//                 proceedMoveLongdoMap(lat!, lng!);
//               },
//               backgroundColor: Contants.colorSpringGreen,
//               child: Icon(
//                 Icons.my_location,
//                 color: Contants.colorOxfordBlue,
//               ),
//             ),
//             FloatingActionButton(
//               onPressed: () async {
//                 // processMarker();
//                 // print(marker);
//                 if (marker != null) {
//                   await mapbarber.currentState?.call("Overlays.add", [
//                     marker,
//                   ]);
//                 }
//                 else{
//                   print("dqwdq");
//                 }
//               },
//               backgroundColor: Contants.colorSpringGreen,
//               child: Icon(
//                 Icons.pin_drop,
//                 color: Contants.colorOxfordBlue,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   processMarker() async {
//     var location = await mapbarber.currentState?.call("location");
//     var latx = cutlat(location);
//     var lonx = cutlon(location);
//     print(lonx);
//     print(latx);
//     Object? marker = mapbarber.currentState?.object(
//       "Marker",
//       "1",
//       [
//         {"lon": 13.860634, "lat": 100.512460},
//         {"detail": "Home"}
//       ],
//     );
//     if (marker != null) {
//       await mapbarber.currentState?.call("Overlays.add", [
//         marker,
//       ]);
//     }
//   }

//   Future<Null> inputpostion() async {
//     showDialog(
//       context: context,
//       builder: (context) => SimpleDialog(
//         title: ListTile(
//           title: Text("รายละเอียดที่อยู่", style: Contants().h3OxfordBlue()),
//           subtitle: Wrap(
//             children: [
//               Text(
//                 "เพิ่มรายละเอียดที่อยู่",
//                 style: Contants().h3OxfordBlue(),
//               ),
//               TextFormField(
//                 decoration:
//                     const InputDecoration(hintText: "99/99 ซอย 11 ถนนพระราม 4"),
//               ),
//             ],
//           ),
//         ),
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: Text(
//                   "ยกเลิก",
//                   style: Contants().h2Red(),
//                 ),
//               ),
//               TextButton(
//                 onPressed: () {
//                   // saveData();
//                 },
//                 child: Text(
//                   "ยืนยัน",
//                   style: Contants().h2OxfordBlue(),
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   // Future<Null> saveData() async {
//   //   var location = await map.currentState?.call("location");
//   //   var latx = cutlat(location);
//   //   var lonx = cutlon(location);
//   //   String path =
//   //       "https://api.longdo.com/map/services/address?lon=$lonx&lat=$latx&nopostcode=0&noroad=0&noaoi=0&noelevation=0&nowater=0&key=${Contants.keyLongdomap}";
//   //   await Dio().get(path).then((value) async {
//   //     if (value.data["province"] == "จ.นนทบุรี") {
//   //       String dis = value.data['district'];
//   //       String dissub = value.data['subdistrict'];
//   //       var geoHasher = GeoHasher();
//   //       String geohash =
//   //           geoHasher.encode(double.parse(lonx), double.parse(latx));
//   //       await FirebaseFirestore.instance
//   //           .collection("Barber")
//   //           .doc(email)
//   //           .update({
//   //         "position": {
//   //           "addressdetails": detailController.text,
//   //           "district": dis,
//   //           "subdistrict": dissub,
//   //           "lat": latx,
//   //           "lng": lonx,
//   //           "geohash": geohash
//   //         }
//   //       }).then((value) {
//   //         Navigator.pushAndRemoveUntil(
//   //             context,
//   //             MaterialPageRoute(
//   //               builder: (context) => RegisterPhoneUser(
//   //                 emailBarber: email,
//   //               ),
//   //             ),
//   //             (route) => false);
//   //       });
//   //     } else {
//   //       Navigator.pop(context);
//   //       MyDialog().normalDialog(context, "ร้านไม่ได้อยู่ในจังหวัดนนทบุรี");
//   //     }
//   //   });
//   // }

//   void fc2() {
//     Navigator.pop(context);
//     Navigator.pop(context);
//   }

//   cutlon(location) {
//     String lon;
//     var psLat = location.indexOf('lat');
//     lon = location.substring(7, psLat - 2);
//     return lon;
//   }

//   cutlat(location) {
//     String lat;
//     var psLat = location.indexOf('lat');
//     lat = location.substring(psLat + 5, location.length - 1);
//     return lat;
//   }

//   proceedMoveLongdoMap(double lat, double lng) async {
//     await mapbarber.currentState?.call(
//       "location",
//       [
//         {
//           "lon": lng,
//           "lat": lat,
//         },
//       ],
//     );
//   }
// }
