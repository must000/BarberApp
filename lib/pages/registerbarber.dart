import 'dart:io';

import 'package:barber/Constant/district_cn.dart';
import 'package:barber/pages/locationpage.dart';
import 'package:barber/utils/dialog.dart';
import 'package:barber/utils/show_progress.dart';
import 'package:barber/widgets/barbermodel1.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class RegisterBarber extends StatefulWidget {
  const RegisterBarber({Key? key}) : super(key: key);

  @override
  State<RegisterBarber> createState() => _RegisterBarberState();
}

class _RegisterBarberState extends State<RegisterBarber> {
  TimeOfDay _timeopen = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay _timeclose = TimeOfDay(hour: 0, minute: 0);
  String? groupTypeBarber;
  bool su = false,
      mo = false,
      tu = false,
      we = false,
      th = false,
      fr = false,
      sa = false;
  File? photoShopFront;
  List<String> listSubDistrict = District_CN.mueangNonthaburi;
  String district = 'เมืองนนทบุรี';
  String? subDistrict;
  double? lat, lng;
  final ImagePicker imgpicker = ImagePicker();
  List<XFile>? imagefiles;

  @override
  void initState() {
    super.initState();
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

  Future<Null> findLatLng() async {
    print("findLatlan ==> Work");
    Position? position = await findPosition();
    setState(() {
      lat = position!.latitude;
      lng = position.longitude;
      print("lat = $lat" + "lng = $lng");
    });
  }

  Future<Position?> findPosition() async {
    Position position;
    try {
      position = await Geolocator.getCurrentPosition();
      return position;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Form(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  inputname(size),
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
                  inputLocation(size),
                  inputDistrict(),
                  inputSubDistrict(),
                  inputDetailLocation(size),
                  TextButton(
                      onPressed: (() => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LocationPage(),
                          ))),
                      child: Text("location")),
                  imgPhotoShop(size, context),
                  photoShopFront == null
                      ? const Text('')
                      : TextButton(
                          onPressed: () {
                            normalDialog(context);
                          },
                          child: const Text('เปลี่ยนรูปภาพ')),
                  const Text("อัลบั้มของร้าน"),
                  inputAlbum(),
                  imagefiles != null
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
                  buttonRegister(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton buttonRegister() {
    return ElevatedButton(
      onPressed: () {
        print(groupTypeBarber);
        print("$_timeopen and $_timeclose");
        print("lat = $lat lng = $lng");
      },
      child: const Text('ลงทะเบียนร้าน'),
    );
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

  Row inputSubDistrict() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Text("ตำบล"),
        DropdownButton<String>(
          value: subDistrict,
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String? newValue) {
            setState(() {
              subDistrict = newValue!;
            });
            print(subDistrict);
          },
          items: listSubDistrict.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }

  Row inputDistrict() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Text("อำเภอ"),
        DropdownButton<String>(
          value: district,
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String? newValue) {
            setState(() {
              subDistrict = null;
              district = newValue!;
            });
            switch (district) {
              case 'เมืองนนทบุรี':
                listSubDistrict = District_CN.mueangNonthaburi;
                break;
              case 'บางกรวย':
                listSubDistrict = District_CN.bangKruai;
                break;
              case 'บางใหญ่':
                listSubDistrict = District_CN.bangYai;
                break;
              case 'บางบัวทอง':
                listSubDistrict = District_CN.bangBuaThong;
                break;
              case 'ไทรน้อย':
                listSubDistrict = District_CN.sainoi;
                break;
              case 'ปากเกร็ด':
                listSubDistrict = District_CN.pakKret;
                break;
              default:
            }
            print(district);
          },
          items: District_CN.district
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }

  Container inputLocation(double size) {
    return Container(
      color: Colors.grey,
      width: double.infinity,
      height: 200,
      child: lat == null
          ? ShowProgress()
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(lat!, lng!),
                zoom: 16,
              ),
              onMapCreated: (controller) {},
              markers: setMarker(),
            ),
    );
  }

  //มาร์ค สีแดงๆที่อยู่บนแมพ
  Set<Marker> setMarker() => <Marker>[
        Marker(
          markerId: MarkerId("id"),
          position: LatLng(lat!, lng!),
          infoWindow: InfoWindow(
              title: "คุณอยู่ที่นี่",
              snippet:
                  "Lat = $lat, lng = $lng"), //เมื่อคลิกที่มาร์ค จะแสดงtitle
        ),
      ].toSet();

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
        // validator: (value) {
        //   if (value!.isEmpty) {
        //     return "กรุณากรอกรหัสผ่าน";
        //   } else if (value != passwordController.text) {
        //     return "กรุณากรอกรหัสผ่านให้ตรงกัน";
        //   }
        // },
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
        // controller: passwordController,
        validator: (value) {
          if (value!.isEmpty) {
            return "กรุณากรอกรหัสผ่าน";
          } else {}
        },
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
        // controller: userController,
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
        // controller: nameController,
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
