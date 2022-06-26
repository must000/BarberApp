import 'dart:io';
import 'dart:math';

import 'package:barber/Constant/contants.dart';
import 'package:barber/Constant/district_cn.dart';
import 'package:barber/pages/index.dart';
import 'package:barber/pages/locationpage.dart';
import 'package:barber/pages/test.dart';
import 'package:barber/utils/dialog.dart';
import 'package:barber/utils/show_progress.dart';
import 'package:barber/widgets/barbermodel1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:longdo_maps_api3_flutter/longdo_maps_api3_flutter.dart';

class RegisterBarber extends StatefulWidget {
  const RegisterBarber({Key? key}) : super(key: key);

  @override
  State<RegisterBarber> createState() => _RegisterBarberState();
}

class _RegisterBarberState extends State<RegisterBarber> {
  TimeOfDay _timeopen = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay _timeclose = TimeOfDay(hour: 0, minute: 0);
  String? groupTypeBarber;
  Map<String, bool> groupDayOpen = {};
  bool su = false,
      mo = false,
      tu = false,
      we = false,
      th = false,
      fr = false,
      sa = false;
  File? photoShopFront;
  List<String> listSubDistrict = District_CN.mueangNonthaburi;
  // String district = 'เมืองนนทบุรี';
  // String? subDistrict;
  double? lat, lng;
  final ImagePicker imgpicker = ImagePicker();
  List<XFile>? imagefiles;
  bool _animation = true;
  Position? userLocation;
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameShopController = TextEditingController();
  TextEditingController recommentShopController = TextEditingController();
  TextEditingController detailLocationController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chechpermission();
    // proceedfinelatlng();
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
          MyDialog().alertLocation(
              context, "ไม่อนุญาตแชร์ Locationn", "โปรดแชร์ location");
        } else {
          findLatLng();
        }
      } else {
        if (locationPermission == LocationPermission.deniedForever) {
          MyDialog().alertLocation(
              context, "ไม่อนุญาตแชร์ Locationn", "โปรดแชร์ location");
        } else {
          findLatLng();
        }
      }
    } else {
      MyDialog().alertLocation(
          context, "Location service close", "please open locaation service");
    }
  }

  // Future<Null> proceedfinelatlng() async {
  //   LocationPermission permission = await Geolocator.checkPermission();

  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       print('Location permissions are denied');
  //     } else if (permission == LocationPermission.deniedForever) {
  //       print("'Location permissions are permanently denied");
  //     } else {
  //       print("GPS Location service is granted");
  //     }
  //   } else {
  //     findLatLng();
  //   }
  // }

  Future<Null> findLatLng() async {
    print("findLatlan ==> Work");
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print("${position.longitude}is a position");
    print(position.latitude);
    setState(() {
      lat = position.latitude;
      lng = position.longitude;
      print("lat = $lat" + "lng = $lng");
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
        _animation
      ],
    );
  }

  final map = GlobalKey<LongdoMapState>();
  final GlobalKey<ScaffoldMessengerState> messenger =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    Future<Null> proceedZoomLongdoMap() async {
      await map.currentState?.call("zoom", [
        double.parse("13"),
        _animation,
      ]);
    }

    double size = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // ElevatedButton(
                  //     onPressed: () async {
                  //       String path =
                  //           "https://api.longdo.com/map/services/address?lon=100.6&lat=13.7130&nopostcode=0&noroad=0&noaoi=0&noelevation=0&nowater=0&key=f347b56e94df23bde1dd8d0fc4bfa954";
                  //       await Dio()
                  //           .get(path)
                  //           .then((value) => print(value.data['district']));
                  //     },
                  //     child: const Text("test api")),
                  inputname(size),
                  inputlastname(size),
                  inputEmail(size),
                  inputPassword(size),
                  inputRePassword(size),
                  inputPhoneNumber(size),
                  radiobuttonTypeBarber(),
                  inputNameShop(size),
                  inputRecommentShop(size),
                  const Text("เวลาเปิด-ปิด"),
                  showTimeOpenAndTimeClose(),
                  inputTimeOpenAndTimeClose(),
                  const Text("วันที่เปิด"),
                  checkboxDayOpen(),
                  mapLocation(size),
                  buttonMovePosition(),
                  // inputDistrict(),
                  // inputSubDistrict(),
                  inputDetailLocation(size),
                  imgPhotoShop(size, context),
                  buttonChangeImgPhotoShop(context),
                  const Text("อัลบั้มของร้าน"),
                  inputAlbum(),
                  albumShop(),
                  buttonRegister(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container albumShop() {
    return Container(
      child: imagefiles != null
          ? Wrap(
              children: imagefiles!.map((imageone) {
                return Card(
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: Image.file(File(imageone.path)),
                  ),
                );
              }).toList(),
            )
          : Container(),
    );
  }

  Container buttonChangeImgPhotoShop(BuildContext context) {
    return Container(
      child: photoShopFront == null
          ? const Text('')
          : TextButton(
              onPressed: () {
                normalDialog(context);
              },
              child: const Text('เปลี่ยนรูปภาพ')),
    );
  }

  InkWell buttonMovePosition() {
    return InkWell(
      child: const ListTile(
        title: Text("My position"),
        leading: Icon(Icons.wrong_location),
      ),
      onTap: () {
        proceedMoveLongdoMap(lat!, lng!);
      },
    );
  }

  Widget mapLocation(double size) {
    return Stack(
      children: [
        Container(
          child: LongdoMapWidget(
            apiKey: Contants.keyLongdomap,
            key: map,
            bundleId: Contants.bundleID,
          ),
          width: size * 0.9,
          height: 400,
        ),
        Container(
          height: 400,
          child: const Center(
            child: Icon(Icons.pin_drop_outlined),
          ),
        ),
      ],
    );
  }

  ElevatedButton buttonRegister() {
    return ElevatedButton(
      onPressed: () async {
        var location = await map.currentState?.call("location");
        groupDayOpen = {
          'su': su,
          'mo': mo,
          'tu': tu,
          'we': we,
          'th': th,
          'fr': fr,
          'sa': sa
        };
        print("location =>> $location");
        var latx = cutlat(location);
        var lonx = cutlon(location);
        if (formKey.currentState!.validate()) {
          if (groupTypeBarber == null) {
            MyDialog().normalDialog(context, "กรุณาเลือกประเภทของร้าน");
          }
          // else if (subDistrict == null) {
          //   MyDialog().normalDialog(context, "กรุณาเลือกตำบลที่ร้านอยู่");
          // }
          else if (photoShopFront == null) {
            MyDialog().normalDialog(context, "กรุณาเพิ่มรูปหน้าร้าน");
          } else {
            apigetDataDistrict(latx, lonx);
          }
        }
      },
      child: const Text('ลงทะเบียนร้าน'),
    );
  }

  Future<Null> apigetDataDistrict(String lat, String lon) async {
    String path =
        "https://api.longdo.com/map/services/address?lon=$lon&lat=$lat&nopostcode=0&noroad=0&noaoi=0&noelevation=0&nowater=0&key=${Contants.keyLongdomap}";
    await Dio().get(path).then((value) {
      String dis = value.data['district'];
      String dissub = value.data['subdistrict'];
      return registerData(
        nameController.text.trim(),
        lastnameController.text.trim(),
        emailController.text.trim(),
        passwordController.text,
        phoneController.text,
        groupTypeBarber!,
        nameShopController.text,
        recommentShopController.text,
        _timeopen,
        _timeclose,
        groupDayOpen,
        lat,
        lon,
        dissub.toString(),
        dis.toString(),
        detailLocationController.text,
      );
    });
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

  Future<Null> registerData(
    String name,
    String lastname,
    String email,
    String password,
    String phone,
    String typeBarber,
    String nameShop,
    String recommentShop,
    TimeOfDay timeopen,
    TimeOfDay timeclose,
    Map dayopen,
    lat,
    lon,
    String subDestrict,
    String destrict,
    String detaillocation,
  ) async {
    print(
      "$name $lastname $email $password $phone $typeBarber $nameShop $recommentShop $timeopen $timeclose $dayopen ${lat.toString()} ${lon.toString()} $subDestrict $destrict $detaillocation",
    );
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        print("สมัครสำเร็จ");
        proceedSaveDataBarber(
          email,
          name,
          lastname,
          phone,
          typeBarber,
          nameShop,
          recommentShop,
          dayopen,
          timeopen,
          timeclose,
          lat,
          lon,
          destrict,
          subDestrict,
          detaillocation,
        ).then((value) => uploadphoto(email).then((value) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IndexPage(),
                  ),
                  (route) => false);
            }).catchError((value) {
              MyDialog().stDialog(context, value.message);
            }));
      }).catchError((value) {
        MyDialog().normalDialog(context, value.message);
      });
    });
  }

  Future<Null> uploadphoto(String email) async {
    final path = 'imgfront/$email';
    final file = File(photoShopFront!.path);
    final ref = FirebaseStorage.instance.ref().child(path);
    ref.putFile(file);
    if (imagefiles != null) {
      for (var i = 0; i < imagefiles!.length; i++) {
        int x = Random().nextInt(1000000);
        final path2 = 'album/$email/$x';
        final file2 = File(imagefiles![i].path);
        final ref = FirebaseStorage.instance.ref().child(path2);
        ref.putFile(file2);
      }
    }
  }

  Future<Null> proceedSaveDataBarber(
    String email,
    String name,
    String lastname,
    String phone,
    String typeBarber,
    String shopName,
    String shopRecommend,
    Map dayopen,
    timeopen,
    timeclose,
    lat,
    lon,
    String destrict,
    String subDestrict,
    String addressdetails,
  ) async {
    await FirebaseFirestore.instance.collection('Barber').doc(email).set({
      "email": email,
      "name": name,
      "lastname": lastname,
      "phone": phone,
      "typeBarber": typeBarber,
      "shopname": shopName,
      "shoprecommend": shopRecommend,
      "dayopen": dayopen,
      "timeopen":
          "${timeopen.hour.toString().padLeft(2, "0")} : ${_timeopen.minute.toString().padLeft(2, "0")}",
      "timeclose":
          "${timeclose.hour.toString().padLeft(2, "0")} : ${_timeclose.minute.toString().padLeft(2, "0")}",
      "lat": lat,
      "lon": lon,
      "district": destrict,
      "subdistrict": subDestrict,
      "addressdetails": addressdetails,
    });
    debugPrint("บันทึกสำเร็จ");
  }

  ElevatedButton inputAlbum() {
    return ElevatedButton(
        onPressed: () {
          openImages();
        },
        child: const Text("เพิ่มอัลบั้มรูปภาพ"));
  }

  Container imgPhotoShop(double size, BuildContext context) {
    return Container(
      width: size * 0.7,
      margin: const EdgeInsets.only(top: 10),
      height: 180,
      child: photoShopFront == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("รูปหน้าร้าน"),
                  IconButton(
                      onPressed: () {
                        normalDialog(context);
                      },
                      icon: const Icon(Icons.add))
                ],
              ),
            )
          : Image.file(
              photoShopFront!,
              fit: BoxFit.fill,
            ),
      color: const Color.fromARGB(255, 95, 95, 95),
    );
  }

  Container inputDetailLocation(double size) {
    return Container(
      width: size * 0.75,
      margin: EdgeInsets.only(top: 15, left: size * 0.08, right: size * 0.08),
      child: TextFormField(
        controller: detailLocationController,
        validator: (value) {
          if (value!.isEmpty) {
            return "กรุณากรอกรายละเอียดที่อยู่ของร้าน";
          }
        },
        maxLines: 4,
        decoration: InputDecoration(
          labelText: "รายละเอียดที่อยู่ของร้าน",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  // Row inputSubDistrict() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     children: [
  //       const Text("ตำบล"),
  //       DropdownButton<String>(
  //         value: subDistrict,
  //         icon: const Icon(Icons.arrow_downward),
  //         elevation: 16,
  //         style: const TextStyle(color: Colors.deepPurple),
  //         underline: Container(
  //           height: 2,
  //           color: Colors.deepPurpleAccent,
  //         ),
  //         onChanged: (String? newValue) {
  //           setState(() {
  //             subDistrict = newValue!;
  //           });
  //           print(subDistrict);
  //         },
  //         items: listSubDistrict.map<DropdownMenuItem<String>>((String value) {
  //           return DropdownMenuItem<String>(
  //             value: value,
  //             child: Text(value),
  //           );
  //         }).toList(),
  //       ),
  //     ],
  //   );
  // }

  // Row inputDistrict() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     children: [
  //       const Text("อำเภอ"),
  //       DropdownButton<String>(
  //         value: district,
  //         icon: const Icon(Icons.arrow_downward),
  //         elevation: 16,
  //         style: const TextStyle(color: Colors.deepPurple),
  //         underline: Container(
  //           height: 2,
  //           color: Colors.deepPurpleAccent,
  //         ),
  //         onChanged: (String? newValue) {
  //           setState(() {
  //             subDistrict = null;
  //             district = newValue!;
  //           });
  //           switch (district) {
  //             case 'เมืองนนทบุรี':
  //               listSubDistrict = District_CN.mueangNonthaburi;
  //               break;
  //             case 'บางกรวย':
  //               listSubDistrict = District_CN.bangKruai;
  //               break;
  //             case 'บางใหญ่':
  //               listSubDistrict = District_CN.bangYai;
  //               break;
  //             case 'บางบัวทอง':
  //               listSubDistrict = District_CN.bangBuaThong;
  //               break;
  //             case 'ไทรน้อย':
  //               listSubDistrict = District_CN.sainoi;
  //               break;
  //             case 'ปากเกร็ด':
  //               listSubDistrict = District_CN.pakKret;
  //               break;
  //             default:
  //           }
  //           print(district);
  //         },
  //         items: District_CN.district
  //             .map<DropdownMenuItem<String>>((String value) {
  //           return DropdownMenuItem<String>(
  //             value: value,
  //             child: Text(value),
  //           );
  //         }).toList(),
  //       ),
  //     ],
  //   );
  // }

  Row checkboxDayOpen() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Container(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  su = !su;
                });
              },
              child: const Text("จ"),
              style: ElevatedButton.styleFrom(
                primary: su == false ? Colors.blue : Colors.red,
                shape: const CircleBorder(),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  mo = !mo;
                });
              },
              child: const Text("อ"),
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                primary: mo == false ? Colors.blue : Colors.red,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  tu = !tu;
                });
              },
              child: const Text("พ"),
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                primary: tu == false ? Colors.blue : Colors.red,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  we = !we;
                });
              },
              child: const Text("พฤ"),
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                primary: we == false ? Colors.blue : Colors.red,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  th = !th;
                });
              },
              child: const Text("ศ"),
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                primary: th == false ? Colors.blue : Colors.red,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  fr = !fr;
                });
              },
              child: const Text("ส"),
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                primary: fr == false ? Colors.blue : Colors.red,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  sa = !sa;
                });
              },
              child: const Text("อา"),
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                primary: sa == false ? Colors.blue : Colors.red,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row inputTimeOpenAndTimeClose() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            _selectTime();
          },
          child: const Text("เวลาเปิด"),
        ),
        ElevatedButton(
          onPressed: () {
            _selectTime2();
          },
          child: const Text("เวลาปิด"),
        ),
      ],
    );
  }

  Row showTimeOpenAndTimeClose() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
            "${_timeopen.hour.toString().padLeft(2, "0")} : ${_timeopen.minute.toString().padLeft(2, "0")}"),
        Text(
            "${_timeclose.hour.toString().padLeft(2, "0")} : ${_timeclose.minute.toString().padLeft(2, "0")}")
      ],
    );
  }

  Container inputRecommentShop(double size) {
    return Container(
      width: size * 0.75,
      margin: EdgeInsets.only(top: 15, left: size * 0.08, right: size * 0.08),
      child: TextFormField(
        controller: recommentShopController,
        validator: (value) {
          if (value!.isEmpty) {
            return "กรุณาคำแนะนำร้าน";
          }
        },
        maxLines: 4,
        decoration: InputDecoration(
          labelText: "คำแนะนำร้าน",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Container inputNameShop(double size) {
    return Container(
      margin: EdgeInsets.only(top: 15, left: size * 0.08, right: size * 0.08),
      child: TextFormField(
        controller: nameShopController,
        validator: (value) {
          if (value!.isEmpty) {
            return "กรุณากรอกชื่อร้าน";
          }
        },
        decoration: InputDecoration(
          labelText: "ชื่อร้าน",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Row radiobuttonTypeBarber() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              groupTypeBarber = "man";
            });
          },
          child: const Text("ร้านตัดผมชาย"),
          style: ElevatedButton.styleFrom(
              primary: groupTypeBarber == "man" ? Colors.red : Colors.grey,
              onPrimary: Colors.black),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              groupTypeBarber = "woman";
            });
          },
          child: const Text("ร้านเสริมสวย"),
          style: ElevatedButton.styleFrom(
              primary: groupTypeBarber == "woman" ? Colors.red : Colors.grey,
              onPrimary: Colors.black),
        ),
      ],
    );
  }

  Container inputPhoneNumber(double size) {
    return Container(
      margin: EdgeInsets.only(top: 15, left: size * 0.08, right: size * 0.08),
      child: TextFormField(
        keyboardType: TextInputType.phone,
        controller: phoneController,
        validator: (value) {
          if (value!.isEmpty) {
            return "กรุณากรอกเบอร์โทร";
          }
        },
        decoration: InputDecoration(
          labelText: "phone",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Container inputRePassword(double size) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: size * 0.08),
      child: TextFormField(
        keyboardType: TextInputType.visiblePassword,
        validator: (value) {
          if (value!.isEmpty) {
            return "กรุณากรอกรหัสผ่าน";
          } else if (value != passwordController.text) {
            return "กรุณากรอกรหัสผ่านให้ตรงกัน";
          }
        },
        obscureText: true,
        decoration: InputDecoration(
          labelText: "Confirm Password",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Container inputPassword(double size) {
    return Container(
      margin: EdgeInsets.only(top: 15, left: size * 0.08, right: size * 0.08),
      child: TextFormField(
        keyboardType: TextInputType.visiblePassword,
        controller: passwordController,
        validator: (value) {
          if (value!.isEmpty) {
            return "กรุณากรอกรหัสผ่าน";
          } else {}
        },
        obscureText: true,
        decoration: InputDecoration(
          labelText: "Password",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Container inputEmail(double size) {
    return Container(
      margin: EdgeInsets.only(top: 15, left: size * 0.08, right: size * 0.08),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return "กรุณากรอกEmail";
          } else {}
        },
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: "Email",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Container inputname(double size) {
    return Container(
      margin: EdgeInsets.only(top: 15, left: size * 0.08, right: size * 0.08),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return "กรุณากรอกชื่อ";
          } else {}
        },
        controller: nameController,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          labelText: "Name",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Container inputlastname(double size) {
    return Container(
      margin: EdgeInsets.only(top: 15, left: size * 0.08, right: size * 0.08),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return "กรุณากรอกนามสกุล";
          } else {}
        },
        controller: lastnameController,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          labelText: "Lastname",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  openImages() async {
    try {
      var pickedfiles = await imgpicker.pickMultiImage();
      //you can use ImageCourse.camera for Camera capture
      if (pickedfiles != null) {
        for (var i = 0; i <= pickedfiles.length; i++) {
          imagefiles = pickedfiles;
        }
        setState(() {});
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("error while picking file.");
    }
  }

  Future<Null> normalDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  chooseImage(ImageSource.camera);
                  Navigator.pop(context);
                },
                child: const Icon(Icons.camera_alt),
              ),
              ElevatedButton(
                onPressed: () {
                  chooseImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.collections_outlined,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<Null> chooseImage(ImageSource source) async {
    try {
      // ignore: deprecated_member_use
      var result = await ImagePicker().getImage(
        source: source,
      );
      setState(() {
        photoShopFront = File(result!.path);
      });
    } catch (e) {}
  }

  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
        context: context,
        initialTime: _timeopen,
        initialEntryMode: TimePickerEntryMode.input);
    if (newTime != null) {
      setState(() {
        _timeopen = newTime;
      });
    }
  }

  void _selectTime2() async {
    final TimeOfDay? newTime = await showTimePicker(
        context: context,
        initialTime: _timeclose,
        initialEntryMode: TimePickerEntryMode.input);
    if (newTime != null) {
      setState(() {
        _timeclose = newTime;
      });
    }
  }
}
