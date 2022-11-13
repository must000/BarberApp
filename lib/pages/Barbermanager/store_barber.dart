import 'dart:io';

import 'package:barber/Constant/contants.dart';
import 'package:barber/main.dart';
import 'package:barber/pages/Barbermanager/drawerobject.dart';
import 'package:barber/pages/Barbermanager/map_barber.dart';
import 'package:barber/utils/dialog.dart';
import 'package:barber/widgets/textfieldmodeil1.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:longdo_maps_api3_flutter/view.dart';

class StoreBarber extends StatefulWidget {
  const StoreBarber({
    Key? key,
  }) : super(key: key);

  @override
  State<StoreBarber> createState() => _StoreBarberState();
}

class _StoreBarberState extends State<StoreBarber> {
  TextEditingController recommendController = TextEditingController();
  TextEditingController shopNameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController addressDetailController = TextEditingController();

  TimeOfDay _timeopen = TimeOfDay(hour: 1, minute: 0);
  TimeOfDay _timeclose = TimeOfDay(hour: 23, minute: 0);
  bool change = false;
  CollectionReference users = FirebaseFirestore.instance.collection('Barber');
  File? photoShopFront;
  final ImagePicker imgpicker = ImagePicker();
  String? groupTypeBarber;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setdata();
  }

  setdata() {
    recommendController.text = barberModelformanager!.shoprecommend;
    shopNameController.text = barberModelformanager!.shopname;
    groupTypeBarber = barberModelformanager!.typebarber;
    nameController.text = barberModelformanager!.name;
    lastNameController.text = barberModelformanager!.lasiName;
    addressDetailController.text = barberModelformanager!.addressdetails;
    _timeopen = TimeOfDay(
      hour: int.parse(barberModelformanager!.timeopen.split(" ")[0]),
      minute: int.parse(barberModelformanager!.timeopen.split(" ")[2]),
    );
    _timeclose = TimeOfDay(
      hour: int.parse(barberModelformanager!.timeclose.split(" ")[0]),
      minute: int.parse(barberModelformanager!.timeclose.split(" ")[2]),
    );
  }

  Future<Null> deleteImg() async {
    final storageRef = FirebaseStorage.instance.ref();
    final desertRef =
        storageRef.child("imgfront/${barberModelformanager!.email}");
    await desertRef.delete().then((value) => debugPrint("delete succeed"));
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

  Future<Null> uploadphoto(String email) async {
    final path = 'imgfront/$email';
    final file = File(photoShopFront!.path);
    final ref = FirebaseStorage.instance.ref().child(path);
    await ref.putFile(file).then((p0) async {
      await ref.getDownloadURL().then((value) async {
        print("url หน้าร้าน คือ $value");
        await FirebaseFirestore.instance
            .collection('Barber')
            .doc(email)
            .update({"url": value}).then((values) {
          setState(() {
            barberModelformanager!.url = value;
            photoShopFront = null;
          });
        });
      });
    });
  }

  final map = GlobalKey<LongdoMapState>();
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: DrawerObject(),
      appBar: AppBar(
        backgroundColor: Contants.myBackgroundColordark,
      ),
      backgroundColor: Contants.myBackgroundColor,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: SingleChildScrollView(
          child: Column(
            children: [
              topicTitle("ผู้จัดการร้าน"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextFieldModel1(
                      size: size * 0.4,
                      controller: nameController,
                      title: "ชื่อ"),
                  TextFieldModel1(
                      size: size * 0.4,
                      controller: lastNameController,
                      title: "นามสกุล"),
                ],
              ),
              topicTitle("ข้อมูลร้าน"),
              TextFieldModel1(
                  size: size * 0.9,
                  controller: shopNameController,
                  title: "ชื่อร้าน"),
              showRecommend(size),
              radiobuttonTypeBarber(),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text == "" ||
                      lastNameController.text == "" ||
                      shopNameController.text == "" ||
                      recommendController.text == "") {
                    MyDialog().normalDialog(context, "กรุณาใส่ข้อมูลให้ครบ");
                  } else {
                    MyDialog(funcAction: fc)
                        .superDialog(context, "", "บันทึกข้อมูล");
                  }
                },
                child: Text(
                  "บันทึก",
                  style: Contants().h3OxfordBlue(),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Contants.colorYellow),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "รูปหน้าร้าน",
                style: Contants().h2white(),
              ),
              showimageFront(size),
              buttonChangeImgFront(context),
              photoShopFront == null
                  ? const SizedBox()
                  : buttonDeleteAndUpdateImgFront(),
              const SizedBox(
                height: 10,
              ),
              topicTitle("วันที่เปิด - ปิดร้าน"),
              Text(
                "*หากต้องการปิดร้าน ต้องปิดร้านล่วงหน้า 2 วันเท่านั้น",
                style: Contants().h4Red(),
              ),
              buildSelectDaycloseButton(),
              const SizedBox(
                height: 10,
              ),
              topicTitle("เวลาเปิด - ปิดร้าน"),
              Text(
                "*การเปลี่ยนเวลาจะเกิดขึ้นทันที ทางร้านต้องให้บริการคิวที่จองเข้ามาในเวลาเดิมด้วย",
                style: Contants().h4Red(),
              ),
              buildTimeOpen(),
              buildTimeClose(),
              ElevatedButton(
                onPressed: () {
                  saveDateTime();
                },
                child: Text(
                  "บันทึก",
                  style: Contants().h3OxfordBlue(),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Contants.colorYellow),
                ),
              ),
              topicTitle("ที่อยู่ร้าน"),
              Card(
                color: Contants.colorOxfordBlueLight,
                child: ListTile(
                  title: Text(
                    "${barberModelformanager!.subDistrict} ${barberModelformanager!.districtl}",
                    style: Contants().h3white(),
                  ),
                  subtitle: Wrap(
                    children: [
                      Container(
                        width: size * 0.5,
                        child: Expanded(
                          child: TextFormField(
                            controller: addressDetailController,
                            style: Contants().h4yellow(),
                            decoration: InputDecoration(
                                labelText: "รายละเอียดที่อยู่ร้าน",
                                labelStyle: Contants().h4Grey()),
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            saveAddressDetail();
                          },
                          icon: Icon(
                            Icons.save,
                            color: Contants.colorYellow,
                          ))
                    ],
                  ),
                  trailing: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            width: 1.0,
                            color: Contants.colorYellowdark,
                            style: BorderStyle.solid,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0))),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapBarber(
                                lat: double.parse(barberModelformanager!.lat),
                                lng: double.parse(barberModelformanager!.lng),
                              ),
                            ));
                      },
                      child: Text(
                        "เปิดแผนที่",
                        style: Contants().h4yellow(),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox buildInput(
      double size, String title, TextEditingController controller) {
    return SizedBox(
      width: size,
      child: TextFormField(
        style: Contants().h3white(),
        controller: controller,
        decoration: InputDecoration(
          labelText: title,
          fillColor: Contants.colorOxfordBlue,
          labelStyle: Contants().floatingLabelStyle(),
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Contants.colorGreySilver),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Contants.colorSpringGreen),
          ),
        ),
      ),
    );
  }

  Future saveAddressDetail() async {
    FirebaseFirestore.instance
        .collection("Barber")
        .doc(barberModelformanager!.email)
        .update({
      "position": {
        "addressdetails": addressDetailController.text,
        "district": barberModelformanager!.districtl,
        "subdistrict": barberModelformanager!.subDistrict,
        "lat": barberModelformanager!.lat,
        "lng": barberModelformanager!.lng,
        "geohash": barberModelformanager!.geoHasher
      }
    }).then((value) {
      setState(() {
        barberModelformanager!.addressdetails = addressDetailController.text;
      });
    });
  }

  Future saveDateTime() async {
    String open =
        "${_timeopen.hour.toString().padLeft(2, "0")} : ${_timeopen.minute.toString().padLeft(2, "0")}";
    String close =
        "${_timeclose.hour.toString().padLeft(2, "0")} : ${_timeclose.minute.toString().padLeft(2, "0")}";
    FirebaseFirestore.instance
        .collection("Barber")
        .doc(barberModelformanager!.email)
        .update({
      "timeopen":
          "${_timeopen.hour.toString().padLeft(2, "0")} : ${_timeopen.minute.toString().padLeft(2, "0")}",
      "timeclose":
          "${_timeclose.hour.toString().padLeft(2, "0")} : ${_timeclose.minute.toString().padLeft(2, "0")}",
    }).then((value) {
      debugPrint("succeed");
      setState(() {
        barberModelformanager!.timeopen = open;
        barberModelformanager!.timeclose = close;
      });
    });
  }

  Widget buildTimeClose() {
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

  Widget buildTimeOpen() {
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

  Widget buildSelectDaycloseButton() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              checkDay(barberModelformanager!.dayopen["mo"], "mo");
            },
            child: const Text("จ"),
            style: ElevatedButton.styleFrom(
              primary: barberModelformanager!.dayopen["mo"]
                  ? Contants.colorSpringGreen
                  : Contants.colorRed,
              shape: const CircleBorder(),
            ),
          ),
        ),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              checkDay(barberModelformanager!.dayopen["tu"], "tu");
            },
            child: const Text("อ"),
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              primary: barberModelformanager!.dayopen["tu"]
                  ? Contants.colorSpringGreen
                  : Contants.colorRed,
            ),
          ),
        ),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              checkDay(barberModelformanager!.dayopen["we"], "we");
            },
            child: const Text("พ"),
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              primary: barberModelformanager!.dayopen["we"]
                  ? Contants.colorSpringGreen
                  : Contants.colorRed,
            ),
          ),
        ),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              checkDay(barberModelformanager!.dayopen["th"], "th");
            },
            child: const Text("พฤ"),
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              primary: barberModelformanager!.dayopen["th"]
                  ? Contants.colorSpringGreen
                  : Contants.colorRed,
            ),
          ),
        ),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              checkDay(barberModelformanager!.dayopen["fr"], "fr");
            },
            child: const Text("ศ"),
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              primary: barberModelformanager!.dayopen["fr"]
                  ? Contants.colorSpringGreen
                  : Contants.colorRed,
            ),
          ),
        ),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              checkDay(barberModelformanager!.dayopen["sa"], "sa");
            },
            child: const Text("ส"),
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              primary: barberModelformanager!.dayopen["sa"]
                  ? Contants.colorSpringGreen
                  : Contants.colorRed,
            ),
          ),
        ),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              checkDay(barberModelformanager!.dayopen["su"], "su");
            },
            child: const Text("อา"),
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              primary: barberModelformanager!.dayopen["su"]
                  ? Contants.colorSpringGreen
                  : Contants.colorRed,
            ),
          ),
        ),
      ],
    );
  }

  void checkDay(bool status, String day) {
    if (status) {
      //ต้องการปิดร้าน
      showDialog(
          context: context,
          builder: (conttext) => SimpleDialog(
                title: Text(
                  "ยืนยันการปิดร้าน",
                  style: Contants().h3OxfordBlue(),
                ),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "ยกเลิก",
                            style: Contants().h3Red(),
                          )),
                      TextButton(
                          onPressed: () async {
                            checkDayClose(day);
                          },
                          child: Text(
                            "ปิดร้าน",
                            style: Contants().h3SpringGreen(),
                          ))
                    ],
                  ),
                ],
              ));
    } else {
      //ต้องการเปิดร้าน
      showDialog(
          context: context,
          builder: (conttext) => SimpleDialog(
                title: Text(
                  "ยืนยันการเปิดร้าน",
                  style: Contants().h3OxfordBlue(),
                ),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "ยกเลิก",
                            style: Contants().h3Red(),
                          )),
                      TextButton(
                          onPressed: () async {
                            openBarber(day);
                          },
                          child: Text(
                            "เปิดร้าน",
                            style: Contants().h3SpringGreen(),
                          ))
                    ],
                  ),
                ],
              ));
    }
  }

  Future checkDayClose(String day) async {
    const Map<int, String> weekdayName = {
      1: "mo",
      2: "tu",
      3: "we",
      4: "th",
      5: "fr",
      6: "sa",
      7: "su"
    };
    int day1 = DateTime.now().weekday;
    int day2 = DateTime.now().add(const Duration(days: 1)).weekday;
    if (weekdayName[day1] == day || weekdayName[day2] == day) {
      //ปิดไม่ได้
      MyDialog(funcAction: fc4).hardDialog(
          context, "ต้องปิดร้านล่วงหน้า 2 วัน", "ไม่สามารถปิดร้านได้");
    } else {
      // ปิดได้
      closeBarber(day);
    }
  }

  Future<Null> closeBarber(String day) async {
    Map<String, dynamic> dataDay = barberModelformanager!.dayopen;
    dataDay[day] = false;
    await FirebaseFirestore.instance
        .collection("Barber")
        .doc(barberModelformanager!.email)
        .update({"dayopen": dataDay}).then((value) {
      Navigator.pop(context);
      MyDialog().normalDialog(context, "ปิดร้านเรียบร้อย");
      setState(() {
        barberModelformanager!.dayopen = dataDay;
      });
    });
  }

  void fc4() {
    Navigator.pop(context);
    Navigator.pop(context);
  }

  Future openBarber(String day) async {
    Map<String, dynamic> dataDay = barberModelformanager!.dayopen;
    dataDay[day] = true;
    await FirebaseFirestore.instance
        .collection("Barber")
        .doc(barberModelformanager!.email)
        .update({"dayopen": dataDay}).then((value) {
      Navigator.pop(context);
      MyDialog().normalDialog(context, "เปิดร้านเรียบร้อย");
      setState(() {
        barberModelformanager!.dayopen = dataDay;
      });
    });
  }

  void fc() {
    FocusScope.of(context).requestFocus(FocusNode());
    insertdata();
  }

  Future<Null> insertdata() async {
    await FirebaseFirestore.instance
        .collection("Barber")
        .doc(barberModelformanager!.email)
        .update({
      "name": nameController.text,
      "lastname": lastNameController.text,
      "shopname": shopNameController.text,
      "shoprecommend": recommendController.text,
      "typeBarber": groupTypeBarber
    }).then((value) {
      Navigator.pop(context);
      MyDialog().normalDialog(context, "บันทึกสำเร็จ");
      setState(() {
        barberModelformanager!.name = nameController.text;
        barberModelformanager!.lasiName = lastNameController.text;
        barberModelformanager!.shopname = shopNameController.text;
        barberModelformanager!.shoprecommend = recommendController.text;
        barberModelformanager!.typebarber = recommendController.text;
      });
    });
  }

  Container topicTitle(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Row(
        children: [
          Text(
            title,
            style: Contants().h3white(),
          ),
        ],
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

  Row buttonDeleteAndUpdateImgFront() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
          ),
          onPressed: () {
            setState(() {
              photoShopFront = null;
            });
          },
          child: Text(
            "ลบรูปภาพ",
            style: Contants().h4white(),
          ),
        ),
        ElevatedButton(
            onPressed: () {
              deleteImg()
                  .then((value) => uploadphoto(barberModelformanager!.email));
            },
            child: Text(
              "อัพเดตรูปภาพ",
              style: Contants().h4white(),
            ))
      ],
    );
  }

  ElevatedButton buttonChangeImgFront(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          normalDialog(context);
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Contants.colorYellow),
        ),
        child: Text(
          "เปลี่ยนรูปภาพ",
          style: Contants().h3OxfordBlue(),
        ));
  }

  Container showimageFront(double size) {
    return Container(
      width: size * 0.7,
      margin: const EdgeInsets.only(top: 10),
      height: 180,
      decoration: BoxDecoration(border: Border.all()),
      child: photoShopFront != null
          ? Image.file(photoShopFront!)
          : CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: barberModelformanager!.url,
              placeholder: (context, url) => SizedBox(
                child: LoadingAnimationWidget.waveDots(
                    color: Contants.colorSpringGreen, size: 15),
                width: size * 0.3,
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
    );
  }

  Widget showRecommend(double size) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: size * 0.9,
      child: TextFormField(
        controller: recommendController,
        style: Contants().h4white(),
        maxLines: 3,
        onChanged: (value) {
          setState(() {
            change = true;
          });
        },
        decoration: InputDecoration(
            labelText: "คำแนะนำร้าน",
            labelStyle: Contants().floatingLabelStyle(),
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Contants.colorGreySilver),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Contants.colorSpringGreen),
            )),
      ),
    );
  }

  Container showShopName() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: TextFormField(
        controller: shopNameController,
        decoration: InputDecoration(
            labelText: "ชื่อร้าน",
            fillColor: Contants.colorOxfordBlue,
            labelStyle: Contants().floatingLabelStyle(),
            filled: true,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Contants.colorYellow)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Contants.colorSpringGreen))),
      ),
    );
  }
}
