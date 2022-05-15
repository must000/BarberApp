import 'package:flutter/material.dart';

class RegisterBarber extends StatefulWidget {
  const RegisterBarber({Key? key}) : super(key: key);

  @override
  State<RegisterBarber> createState() => _RegisterBarberState();
}

class _RegisterBarberState extends State<RegisterBarber> {
  TimeOfDay _timeopen = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay _timeclose = TimeOfDay(hour: 0, minute: 0);
  String? groupTypeBarber;
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
                  Container(
                    margin: EdgeInsets.only(
                        top: 15, left: size * 0.08, right: size * 0.08),
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
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 15, left: size * 0.08, right: size * 0.08),
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
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 15, left: size * 0.08, right: size * 0.08),
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
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: 8, horizontal: size * 0.08),
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
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 15, left: size * 0.08, right: size * 0.08),
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "phone",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  Row(
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
                            primary: groupTypeBarber == "man"
                                ? Colors.red
                                : Colors.grey,
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
                            primary: groupTypeBarber == "woman"
                                ? Colors.red
                                : Colors.grey,
                            onPrimary: Colors.black),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 15, left: size * 0.08, right: size * 0.08),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "ชื่อร้าน",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  Container(
                    width: size * 0.75,
                    margin: EdgeInsets.only(
                        top: 15, left: size * 0.08, right: size * 0.08),
                    child: TextFormField(
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: "คำแนะนำร้าน",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const Text("เวลาเปิด-ปิด"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(_timeopen.toString()),
                      Text(_timeclose.toString())
                    ],
                  ),
                  Row(
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
                  ),
                  ElevatedButton(
                    onPressed: () {
                      print(groupTypeBarber);
                      print("$_timeopen and $_timeclose");
                    },
                    child: const Text('ลงทะเบียนร้าน'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
