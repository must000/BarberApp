import 'dart:io';
import 'dart:math';
import 'package:barber/Constant/contants.dart';
import 'package:barber/Constant/district_cn.dart';
import 'package:barber/pages/Authentication/insert_position_barber.dart';
import 'package:barber/pages/Authentication/register_phone_user.dart';
import 'package:barber/pages/index.dart';
import 'package:barber/utils/dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_geohash/dart_geohash.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:longdo_maps_api3_flutter/longdo_maps_api3_flutter.dart';
import 'package:provider/provider.dart';

class RegisterBarber extends StatefulWidget {
  const RegisterBarber({Key? key}) : super(key: key);

  @override
  State<RegisterBarber> createState() => _RegisterBarberState();
}

class _RegisterBarberState extends State<RegisterBarber> {
  TimeOfDay _timeopen = TimeOfDay(hour: 1, minute: 0);
  TimeOfDay _timeclose = TimeOfDay(hour: 23, minute: 0);
  String? groupTypeBarber;
  Map<String, bool> groupDayOpen = {};
  bool su = true,
      mo = true,
      tu = true,
      we = true,
      th = true,
      fr = true,
      sa = true;
  File? photoShopFront;
  List<String> listSubDistrict = District_CN.mueangNonthaburi;
  // String district = 'เมืองนนทบุรี';
  // String? subDistrict;

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
  double? lat, lng;
  var locations;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // proceedfinelatlng();
    chechpermission();
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

  Container title(double size, String title) {
    return Container(
      margin: EdgeInsets.only(left: size * 0.08, right: size * 0.08),
      child: Row(
        children: [
          Text(
            title,
            style: Contants().h3white(),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Contants.myBackgroundColordark,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => IndexPage(),
                ),
                (route) => false);
          },
        ),
      ),
      backgroundColor: Contants.myBackgroundColor,
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
                  title(size, "ชื่อ"),
                  inputname(size),
                  title(size, "นามสกุล"),
                  inputlastname(size),
                  title(size, "อีเมล"),
                  inputEmail(size),
                  title(size, "รหัสผ่าน"),
                  inputPassword(size),
                  title(size, "ยืนยันรหัสผ่าน"),
                  inputRePassword(size),
                  radiobuttonTypeBarber(),
                  title(size, "ชื่อร้าน"),
                  inputNameShop(size),
                  title(size, "คำแนะนำร้าน"),
                  inputRecommentShop(size),
                  buildtimeOpen(),
                  buildtimeClose(),
                  Text(
                    "วันที่เปิด",
                    style: Contants().h3white(),
                  ),
                  checkboxDayOpen(),
                  // mapLocation(size),
                  buttonMovePosition(size),
                  SizedBox(
                    height: 20,
                  ),
                  title(size, "รายละเอียดที่อยู่ร้าน"),
                  inputDetailLocation(size),
                  imgPhotoShop(size, context),
                  buttonChangeImgPhotoShop(context),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "เพิ่มอัลบั้มรูปภาพ",
                        style: Contants().h3white(),
                      ),
                      inputAlbum(),
                    ],
                  ),
                  albumShop(),
                  const SizedBox(
                    height: 20,
                  ),
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

  Widget buttonMovePosition(double size) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: InkWell(
        child: ListTile(
          tileColor: Contants.colorWhite,
          title: const Text("ระบุตำแหน่งของร้านทำผม"),
          leading: Icon(
            Icons.wrong_location,
            color: Contants.colorOxfordBlue,
          ),
        ),
        onTap: () {
          dia(size);
        },
      ),
    );
  }

  Future<Null> dia(double size) async {
    await showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          SizedBox(
            height: size,
            width: size,
            child: Stack(
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
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () {
                          print(lat);
                          proceedMoveLongdoMap(lat!, lng!);
                        },
                        icon: Icon(Icons.my_location)),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Center(
                        child: ElevatedButton(
                            onPressed: () async {
                              var lo = await map.currentState?.call("location");
                              setState(() {
                                locations = lo;
                              });
                              Navigator.pop(context);
                            },
                            child: Text("บันทึกตำแหน่ง"))),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget mapLocation(double size) {
  //   return Stack(
  //     children: [
  //       Container(
  //         child: LongdoMapWidget(
  //           apiKey: Contants.keyLongdomap,
  //           key: map,
  //           bundleId: Contants.bundleID,
  //         ),
  //         width: size * 0.9,
  //         height: 400,
  //       ),
  //       Container(
  //         height: 400,
  //         child: const Center(
  //           child: Icon(Icons.pin_drop_outlined),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget buttonRegister() {
    return Container(
      height: 50,
      child: ElevatedButton(
        onPressed: () async {
          groupDayOpen = {
            'su': su,
            'mo': mo,
            'tu': tu,
            'we': we,
            'th': th,
            'fr': fr,
            'sa': sa
          };
          if (locations == null) {
            MyDialog().normalDialog(context, "กรุณาระบุตำแหน่งของร้าน");
          } else {
            print("location =>> $locations");
            var latx = cutlat(locations);
            var lonx = cutlon(locations);
            if (formKey.currentState!.validate()) {
              if (groupTypeBarber == null) {
                MyDialog().normalDialog(context, "กรุณาเลือกประเภทของร้าน");
              } else if (photoShopFront == null) {
                MyDialog().normalDialog(context, "กรุณาเพิ่มรูปหน้าร้าน");
              } else {
                apigetDataDistrict(latx, lonx);
              }
            }
          }
        },
        child: Text(
          'ลงทะเบียนร้าน',
          style: Contants().h2OxfordBlue(),
        ),
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(Contants.colorSpringGreen),
        ),
      ),
    );
  }

  Future<Null> apigetDataDistrict(String lat, String lon) async {
    String path =
        "https://api.longdo.com/map/services/address?lon=$lon&lat=$lat&nopostcode=0&noroad=0&noaoi=0&noelevation=0&nowater=0&key=${Contants.keyLongdomap}";
    await Dio().get(path).then((value) {
      if (value.data["province"] == "จ.นนทบุรี") {
        String dis = value.data['district'];
        String dissub = value.data['subdistrict'];
        return registerData(
          nameController.text.trim(),
          lastnameController.text.trim(),
          emailController.text.trim().toLowerCase(),
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
      } else {
        MyDialog().normalDialog(context, "ร้านไม่ได้อยู่ในจังหวัดนนทบุรี");
      }
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
          .createUserWithEmailAndPassword(
              email: email.toLowerCase(), password: password)
          .then((value) {
        print("สมัครสำเร็จ");
        proceedSaveDataBarber(
          email.toLowerCase(),
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
        ).then((value) {
          return uploadphoto(email.toLowerCase()).then((value) async {
            print("qwdq");
            await MyDialog(funcAction: fc).hardDialog(
                context, "นำทางไปที่หน้าลงทะเบียนเบอร์โทรศัพท์", "สมัครสำเร็จ");
          }).catchError((value) {
            MyDialog().authenWrongDialog(context, "เกิดข้อผิดพลาด");
          });
        });
      }).catchError((value) {
        MyDialog().authenWrongDialog(context, "อีเมลนี้เคยสมัครไปแล้ว");
      });
    });
  }

  void fc() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => RegisterPhoneUser(
            emailBarber: emailController.text.toLowerCase(),
          ),
        ),
        (route) => false);
  }

  Future<Null> uploadphoto(String email) async {
    final path = 'imgfront/${email.toLowerCase()}';
    final file = File(photoShopFront!.path);
    final ref = FirebaseStorage.instance.ref().child(path);
    print("อัพโหลด");
    await ref.putFile(file).then((p0) async {
      await ref.getDownloadURL().then((value) async {
        print("url หน้าร้าน คือ $value");
        await FirebaseFirestore.instance
            .collection('Barber')
            .doc(email.toLowerCase())
            .update({"url": value});
      });
    });

    if (imagefiles != null) {
      for (var i = 0; i < imagefiles!.length; i++) {
        int x = Random().nextInt(1000000);
        final path2 = 'album/${email.toLowerCase()}/$x';
        final file2 = File(imagefiles![i].path);
        final ref = FirebaseStorage.instance.ref().child(path2);
        await ref.putFile(file2);
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
    var geoHasher = GeoHasher();
    String geohashstart =
        geoHasher.encode(double.parse(lon), double.parse(lat));
    await FirebaseFirestore.instance.collection('Barber').doc(email).set({
      "email": email.toLowerCase(),
      "name": name,
      "lastname": lastname,
      "typeBarber": typeBarber,
      "shopname": shopName,
      "shoprecommend": shopRecommend,
      "dayopen": dayopen,
      "timeopen":
          "${timeopen.hour.toString().padLeft(2, "0")} : ${_timeopen.minute.toString().padLeft(2, "0")}",
      "timeclose":
          "${timeclose.hour.toString().padLeft(2, "0")} : ${_timeclose.minute.toString().padLeft(2, "0")}",
      "position": {
        "addressdetails": addressdetails,
        "district": destrict,
        "subdistrict": subDestrict,
        "lat": lat,
        "lng": lon,
        "geohash": geohashstart
      },
      "score": {
        "count": 0,
        "num": 0,
      },
      "phone": "",
      "url": "",
      // "countservice": 1,
    });
    debugPrint("บันทึกสำเร็จ");
  }

  IconButton inputAlbum() {
    return IconButton(
      onPressed: () {
        openImages();
      },
      icon: Icon(
        Icons.add_to_photos,
        color: Contants.colorSpringGreen,
        size: 30,
      ),
    );
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
      margin: EdgeInsets.only(left: size * 0.08, right: size * 0.08),
      child: TextFormField(
        controller: detailLocationController,
        validator: (value) {
          if (value!.isEmpty) {
            return "กรุณากรอกรายละเอียดที่อยู่ของร้าน";
          }
        },
        maxLines: 4,
        style: Contants().h4white(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

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
                primary:
                    su == false ? Contants.colorRed : Contants.colorSpringGreen,
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
                primary:
                    mo == false ? Contants.colorRed : Contants.colorSpringGreen,
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
                primary:
                    tu == false ? Contants.colorRed : Contants.colorSpringGreen,
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
                primary:
                    we == false ? Contants.colorRed : Contants.colorSpringGreen,
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
                primary:
                    th == false ? Contants.colorRed : Contants.colorSpringGreen,
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
                primary:
                    fr == false ? Contants.colorRed : Contants.colorSpringGreen,
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
                primary:
                    sa == false ? Contants.colorRed : Contants.colorSpringGreen,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildtimeClose() {
    return ListTile(
      title: Text(
        "${_timeclose.hour.toString().padLeft(2, "0")} : ${_timeclose.minute.toString().padLeft(2, "0")}",
        style: Contants().h3white(),
      ),
      subtitle: Text(
        "เวลาปิดร้าน",
        style: Contants().h4Grey(),
      ),
      leading: Icon(
        Icons.timer_off,
        color: Contants.colorRed,
      ),
      trailing: TextButton(
          onPressed: () {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => SimpleDialog(
                children: [
                  TimePickerSpinner(
                    minutesInterval: 30,
                    is24HourMode: true,
                    onTimeChange: (time) {
                      setState(() {
                        _timeclose =
                            TimeOfDay(hour: time.hour, minute: time.minute);
                      });
                    },
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Contants.colorSpringGreen),
                    ),
                    onPressed: () {
                      Navigator.pop(context);

                      if (DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day,
                              _timeclose.hour,
                              _timeclose.minute)
                          .isAfter(DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day,
                              23,
                              0))) {
                        print("ไม่อยู่");
                        Fluttertoast.showToast(
                          msg:
                              "ขออภัย เราไม่อนุญาตให้ปิดร้านหลัง 5 ทุ่ม", // message
                          toastLength: Toast.LENGTH_SHORT, // length
                          gravity: ToastGravity.CENTER, // location
                        );
                        setState(() {
                          _timeclose = TimeOfDay(hour: 23, minute: 0);
                        });
                      } else if (DateTime(
                                  DateTime.now().year,
                                  DateTime.now().month,
                                  DateTime.now().day,
                                  _timeclose.hour,
                                  _timeclose.minute)
                              .isBefore(DateTime(
                                  DateTime.now().year,
                                  DateTime.now().month,
                                  DateTime.now().day,
                                  _timeopen.hour,
                                  _timeopen.minute)) ||
                          DateTime(
                                  DateTime.now().year,
                                  DateTime.now().month,
                                  DateTime.now().day,
                                  _timeclose.hour,
                                  _timeclose.minute) ==
                              DateTime(
                                  DateTime.now().year,
                                  DateTime.now().month,
                                  DateTime.now().day,
                                  _timeopen.hour,
                                  _timeopen.minute)) {
                        Fluttertoast.showToast(
                          msg: "ต้องปิดร้านหลังเวลาเปิดเท่านั้น", // message
                          toastLength: Toast.LENGTH_SHORT, // length
                          gravity: ToastGravity.CENTER, // location
                        );
                        setState(() {
                          _timeclose =
                              TimeOfDay(hour: _timeopen.hour + 1, minute: 0);
                        });
                      } else {}
                    },
                    child: Text(
                      "ตกลง",
                      style: Contants().h3OxfordBlue(),
                    ),
                  ),
                ],
              ),
            );
          },
          child: Text(
            "เปลี่ยน",
            style: Contants().h4yellow(),
          )),
    );
  }

  Widget buildtimeOpen() {
    return ListTile(
      title: Text(
        "${_timeopen.hour.toString().padLeft(2, "0")} : ${_timeopen.minute.toString().padLeft(2, "0")}",
        style: Contants().h3white(),
      ),
      subtitle: Text(
        "เวลาเปิดร้าน",
        style: Contants().h4Grey(),
      ),
      leading: Icon(
        Icons.timer,
        color: Contants.colorSpringGreen,
      ),
      trailing: TextButton(
          onPressed: () {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => SimpleDialog(
                children: [
                  TimePickerSpinner(
                    minutesInterval: 30,
                    is24HourMode: true,
                    onTimeChange: (time) {
                      setState(() {
                        _timeopen =
                            TimeOfDay(hour: time.hour, minute: time.minute);
                      });
                    },
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Contants.colorSpringGreen),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      if (DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day,
                              _timeopen.hour,
                              _timeopen.minute)
                          .isBefore(DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day,
                              1,
                              0))) {
                        print("ไม่อยู่");
                        Fluttertoast.showToast(
                          msg:
                              "ขออภัย เราไม่อนุญาตให้เปิดร้านก่อนตี 1", // message
                          toastLength: Toast.LENGTH_SHORT, // length
                          gravity: ToastGravity.CENTER, // location
                        );
                        setState(() {
                          _timeopen = const TimeOfDay(hour: 1, minute: 0);
                        });
                      } else if (DateTime(
                                  DateTime.now().year,
                                  DateTime.now().month,
                                  DateTime.now().day,
                                  _timeopen.hour,
                                  _timeopen.minute)
                              .isAfter(DateTime(
                                  DateTime.now().year,
                                  DateTime.now().month,
                                  DateTime.now().day,
                                  _timeclose.hour,
                                  _timeclose.minute)) ||
                          DateTime(
                                  DateTime.now().year,
                                  DateTime.now().month,
                                  DateTime.now().day,
                                  _timeopen.hour,
                                  _timeopen.minute) ==
                              DateTime(
                                  DateTime.now().year,
                                  DateTime.now().month,
                                  DateTime.now().day,
                                  _timeclose.hour,
                                  _timeclose.minute)) {
                        Fluttertoast.showToast(
                          msg: "ต้องเปิดร้านก่อนเวลาปิดเท่านั้น", // message
                          toastLength: Toast.LENGTH_SHORT, // length
                          gravity: ToastGravity.CENTER, // location
                        );
                        setState(() {
                          _timeopen =
                              TimeOfDay(hour: _timeclose.hour - 1, minute: 0);
                        });
                      }
                    },
                    child: Text(
                      "ตกลง",
                      style: Contants().h3OxfordBlue(),
                    ),
                  ),
                ],
              ),
            );
          },
          child: Text(
            "เปลี่ยน",
            style: Contants().h4yellow(),
          )),
    );
  }

  Container inputRecommentShop(double size) {
    return Container(
      width: size * 0.75,
      margin: EdgeInsets.only(left: size * 0.08, right: size * 0.08),
      child: TextFormField(
        controller: recommentShopController,
        style: Contants().h4white(),
        validator: (value) {
          if (value!.isEmpty) {
            return "กรุณาคำแนะนำร้าน";
          }
        },
        maxLines: 4,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
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
      margin: EdgeInsets.only(left: size * 0.08, right: size * 0.08),
      child: TextFormField(
        controller: nameShopController,
        style: Contants().h4white(),
        validator: (value) {
          if (value!.isEmpty) {
            return "กรุณากรอกชื่อร้าน";
          }
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
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
          child: Text("ร้านตัดผมชาย", style: Contants().h3OxfordBlue()),
          style: ElevatedButton.styleFrom(
              primary: groupTypeBarber == "man"
                  ? Contants.colorSpringGreen
                  : Colors.grey,
              onPrimary: Colors.black),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              groupTypeBarber = "woman";
            });
          },
          child: Text(
            "ร้านเสริมสวย",
            style: Contants().h3OxfordBlue(),
          ),
          style: ElevatedButton.styleFrom(
              primary: groupTypeBarber == "woman"
                  ? Contants.colorSpringGreen
                  : Colors.grey,
              onPrimary: Colors.black),
        ),
      ],
    );
  }

  Container inputRePassword(double size) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size * 0.08),
      child: TextFormField(
        keyboardType: TextInputType.visiblePassword,
        validator: (value) {
          if (value!.isEmpty) {
            return "กรุณากรอกรหัสผ่าน";
          } else if (value != passwordController.text) {
            return "กรุณากรอกรหัสผ่านให้ตรงกัน";
          }
        },
        style: Contants().h4white(),
        obscureText: true,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
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
      margin: EdgeInsets.only(left: size * 0.08, right: size * 0.08),
      child: TextFormField(
        keyboardType: TextInputType.visiblePassword,
        controller: passwordController,
        validator: (value) {
          if (value!.isEmpty) {
            return "กรุณากรอกรหัสผ่าน";
          } else {}
        },
        style: Contants().h4white(),
        obscureText: true,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
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
      margin: EdgeInsets.only(left: size * 0.08, right: size * 0.08),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return "กรุณากรอกEmail";
          } else {}
        },
        controller: emailController,
        style: Contants().h4white(),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
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
      margin: EdgeInsets.only(left: size * 0.08, right: size * 0.08),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return "กรุณากรอกชื่อ";
          } else {}
        },
        controller: nameController,
        keyboardType: TextInputType.name,
        style: Contants().h4OxfordBlue(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
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
      margin: EdgeInsets.only(left: size * 0.08, right: size * 0.08),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return "กรุณากรอกนามสกุล";
          } else {}
        },
        controller: lastnameController,
        keyboardType: TextInputType.name,
        style: Contants().h4OxfordBlue(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
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
        initialEntryMode: TimePickerEntryMode.dial);
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
        initialEntryMode: TimePickerEntryMode.dial);
    if (newTime != null) {
      setState(() {
        _timeclose = newTime;
      });
    }
  }
}
