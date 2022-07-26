import 'dart:developer';

import 'package:barber/utils/dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class ServiceBarber extends StatefulWidget {
  String email;
  ServiceBarber({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<ServiceBarber> createState() => _ServiceBarberState(email: this.email);
}

class _ServiceBarberState extends State<ServiceBarber> {
  String? email;
  _ServiceBarberState({required this.email});
  bool slid = false;
  double x = 0, y = 0, z = 0;
  double time = 0;
  final formKey = GlobalKey<FormState>();
  TextEditingController nameServiceController = TextEditingController();
  TextEditingController detailServiceController = TextEditingController();
  TextEditingController priceServiceController = TextEditingController();
  List<String> items = ["30 นาที ", "1 ชั่วโมง", "1.30 ชั่วโมง", "2 ชั่วโมง"];
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Stack(children: [
      ListView(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Barber')
                .doc(email)
                .collection("service")
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data.docs;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (_, index) {
                    var userData = data[index];
                    return Card(
                      child: ListTile(
                        title: Text(userData['name']),
                        subtitle: Text(userData['detail']),
                        trailing: Wrap(children: [
                          Text(
                              "${userData['time'].toString()} นาที / ${userData["price"].toString()} บาท"),
                          IconButton(
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection("Barber")
                                    .doc(email)
                                    .collection("service")
                                    .doc(userData.id)
                                    .delete()
                                    .then((value) => print("ลบสำเร็จ"));
                                userData!.id!;
                              },
                              icon: const Icon(
                                Icons.close_sharp,
                                color: Colors.red,
                              ))
                        ]),
                      ),
                    );
                  },
                  itemCount: data.length,
                );
              }
              return const CircularProgressIndicator();
            },
          ),
          SizedBox(
            height: slid == false ? 40 : 300,
          )
        ],
      ),
      Positioned(
          bottom: 5,
          child: slid == false
              ? InkWell(
                  child: Container(
                    decoration: BoxDecoration(color: Colors.grey),
                    width: size,
                    child: const Center(
                      child: Text(
                        "เพิ่มบริการ",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      slid = true;
                    });
                  },
                )
              : Form(
                  key: formKey,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 158, 158, 158)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  dropdownOverButton: true,
                                  hint: Text(
                                    'เวลา ${time.toInt()} นาที ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                  items: items
                                      .map((item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    if (value == "30 นาที ") {
                                      setState(() {
                                        time = 30;
                                      });
                                    } else if (value == "1 ชั่วโมง") {
                                      setState(() {
                                        time = 60;
                                      });
                                    }
                                    else if (value == "1.30 ชั่วโมง") {
                                    setState(() {
                                      time = 90;
                                    });
                                    }
                                    else if(value =="2 ชั่วโมง") {
                                    setState(() {
                                      time = 120;
                                    });
                                    }
                                  },
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      slid = false;
                                    });
                                  },
                                  icon: const Icon(Icons.close))
                            ],
                          ),
                          Row(
                            children: [
                              const Text("ราคา"),
                              const SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                height: 25,
                                width: size * 0.3,
                                child: TextFormField(
                                  controller: priceServiceController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      setState(() {});
                                      return "กรุณากรอกข้อมูลราคา";
                                    } else if (double.parse(value) <= 0) {
                                      setState(() {});
                                      return "ราคาต้องมากกว่า 0";
                                    } else {}
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 1)),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 1),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10 + x,
                          ),
                          Row(
                            children: [
                              const Text("ชื่อบริการ"),
                              const SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                height: 25,
                                width: size * 0.65,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      setState(() {});
                                      return "กรุณากรอกชื่อบริการ";
                                    } else {}
                                  },
                                  controller: nameServiceController,
                                  decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 1)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: const [
                              Text("รายละเอียด"),
                            ],
                          ),
                          Container(
                            height: 60,
                            child: TextFormField(
                              controller: detailServiceController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: size * 0.25,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()&&time!=0) {
                                  print(
                                      "${nameServiceController.text} ${time.toString()} ${detailServiceController.text} ${priceServiceController.text}");
                                  insertData(
                                    nameServiceController.text,
                                    time,
                                    detailServiceController.text,
                                    double.parse(priceServiceController.text),
                                  ).then((value) {
                                    setState(() {
                                      nameServiceController.text = "";
                                      time = 0;
                                      detailServiceController.text = "";
                                      priceServiceController.text = "";
                                    });
                                  });
                                }
                                else{
                                  MyDialog().normalDialog(context, "กรุณาใส่เวลาที่จะใช้ให้บริการ");
                                }
                              },
                              child: const Text(
                                "เพิ่ม",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color?>(
                                          Colors.white)),
                            ),
                          )
                        ],
                      ),
                    ),
                    height: 270,
                    width: size,
                  ),
                ))
    ]));
  }

  Future<Null> insertData(
      String name, double time, String? detail, double price) async {
    await FirebaseFirestore.instance
        .collection('Barber')
        .doc(email)
        .collection('service')
        .add({"name": name, "time": time, "detail": detail, "price": price});
    debugPrint("บันทึกสำเร็จ");
  }
}
