import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  double x = 0;
  final formKey = GlobalKey<FormState>();
  TextEditingController nameServiceController = TextEditingController();
  TextEditingController timeServiceController = TextEditingController();
  TextEditingController detailServiceController = TextEditingController();
  TextEditingController priceServiceController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Stack(children: [
      ListView(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Service')
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
                              onPressed: () {},
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
                      x = 0;
                      slid = true;
                    });
                  },
                )
              : Form(
                  key: formKey,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 158, 158, 158)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                "เพิ่มบริการของท่าน",
                                style: TextStyle(fontSize: 20),
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
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      setState(() {
                                        x = 40;
                                      });
                                      return "กรุณากรอกชื่อบริการ";
                                    } else {}
                                  },
                                  keyboardType: TextInputType.name,
                                  controller: nameServiceController,
                                  decoration: InputDecoration(
                                    labelText: "ชื่อบริการ",
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: TextFormField(
                                  controller: timeServiceController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      setState(() {
                                        x = 40;
                                      });
                                      return "กรุณากรอกเวลาที่จะใช้";
                                    } else if (double.parse(value) <= 0) {
                                      setState(() {
                                        x = 40;
                                      });
                                      return "ราคาต้องมากกว่า 0";
                                    } else {}
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: "เวลาที่ใช้",
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: TextFormField(
                                  controller: detailServiceController,
                                  maxLines: 4,
                                  decoration: InputDecoration(
                                    labelText: "รายละเอียดของกิจกรรม",
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: priceServiceController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          setState(() {
                                            x = 40;
                                          });
                                          return "กรุณากรอกข้อมูลราคา";
                                        } else if (double.parse(value) <= 0) {
                                          setState(() {
                                            x = 40;
                                          });
                                          return "ราคาต้องมากกว่า 0";
                                        } else {}
                                      },
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: "ราคา",
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                if (formKey.currentState!
                                                    .validate()) {
                                                  print(
                                                      "${nameServiceController.text} ${timeServiceController.text} ${detailServiceController.text} ${priceServiceController.text}");
                                                  insertData(
                                                    nameServiceController.text,
                                                    double.parse(
                                                        timeServiceController
                                                            .text),
                                                    detailServiceController
                                                        .text,
                                                    double.parse(
                                                        priceServiceController
                                                            .text),
                                                  ).then((value) {
                                                    setState(() {
                                                      nameServiceController
                                                          .text = "";
                                                      timeServiceController
                                                          .text = "";
                                                      detailServiceController
                                                          .text = "";
                                                      priceServiceController
                                                          .text = "";
                                                    });
                                                  });
                                                }
                                              },
                                              child: const Text("บันทึก"),
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color?>(Colors.red)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    height: 240 + x,
                    width: size,
                  ),
                ))
    ]));
  }

  Future<Null> insertData(
      String name, double time, String? detail, double price) async {
    await FirebaseFirestore.instance
        .collection('Service')
        .doc(email)
        .collection('service')
        .add({"name": name, "time": time, "detail": detail, "price": price});
    debugPrint("บันทึกสำเร็จ");
  }
}
