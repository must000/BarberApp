import 'package:barber/pages/search_result_user.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:barber/Constant/district_cn.dart';
import 'package:barber/data/barbermodel.dart';

class SearchUser extends StatefulWidget {
  List<BarberModel> barberModel;
  String nameUser;
  SearchUser({
    Key? key,
    required this.barberModel,
    required this.nameUser,
  }) : super(key: key);

  @override
  State<SearchUser> createState() => _SearchUserState(barberModel: barberModel,nameUser:nameUser);
}

class _SearchUserState extends State<SearchUser> {
  List<BarberModel> barberModel;
  String nameUser;
  _SearchUserState({required this.barberModel,required this.nameUser});

  List<String> itemsDistrict = ["อำเภอทั้งหมด "] + District_CN.district;
  TextEditingController searchController = TextEditingController();
  List<String> itemSubDistricts = [];
  bool valueman = false, valuewoman = false;
  String? selectedValueDis = "อำเภอทั้งหมด ",
      selectedValueSubDis = "ตำบลทั้งหมด ";
  List searchresult = [];
  List<dynamic>? _list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    values();
  }

  void values() {
    for (var i = 0; i < barberModel.length; i++) {
      _list!.add(barberModel[i].shopname);
    }
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          searchresult.clear();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                    top: 15, left: size * 0.08, right: size * 0.08),
                child: TextFormField(
                  controller: searchController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Search Engine",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onChanged: searchOperation,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    setState(() {
                      searchresult.clear();
                    });
                  },
                ),
              ),
              searchresult.length != 0
                  ? Container(
                      width: size * 0.6,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: searchresult.length,
                        itemBuilder: (BuildContext context, int index) {
                          String listData = searchresult[index];
                          return InkWell(
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              setState(() {
                                searchController.text = listData.toString();
                                searchresult.clear();
                              });
                            },
                            child: Container(
                              height: 40,
                              child: Text(listData.toString()),
                            ),
                          );
                        },
                      ),
                    )
                  : const SizedBox(
                      child: Text(""),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      hint: Text(
                        '$selectedValueDis',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      items: itemsDistrict
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
                        if (value == 'เมืองนนทบุรี ') {
                          itemSubDistricts =
                              ["ตำบลทั้งหมด "] + District_CN.mueangNonthaburi;
                        } else if (value == 'อ.บางกรวย') {
                          itemSubDistricts =
                              ["ตำบลทั้งหมด "] + District_CN.bangKruai;
                        } else if (value == 'อ.บางใหญ่ ') {
                          itemSubDistricts =
                              ["ตำบลทั้งหมด "] + District_CN.bangYai;
                        } else if (value == 'อ.บางบัวทอง') {
                          itemSubDistricts =
                              ["ตำบลทั้งหมด "] + District_CN.bangBuaThong;
                        } else if (value == 'อ.ไทรน้อย') {
                          itemSubDistricts =
                              ["ตำบลทั้งหมด "] + District_CN.sainoi;
                        } else if (value == 'อ.ปากเกร็ด') {
                          itemSubDistricts =
                              ["ตำบลทั้งหมด "] + District_CN.pakKret;
                        } else {
                          itemSubDistricts = [];
                        }
                        setState(() {
                          itemSubDistricts;
                          selectedValueSubDis = "ตำบลทั้งหมด ";
                          selectedValueDis = value as String;
                        });
                      },
                    ),
                  ),
                  DropdownButton2(
                    hint: Text(
                      '$selectedValueSubDis',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    items: itemSubDistricts
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
                      setState(() {
                        selectedValueSubDis = value as String;
                      });
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: valueman,
                    onChanged: (bool? newValue) {
                      setState(() {
                        valueman = newValue!;
                      });
                    },
                  ),
                  const Text("ร้านตัดผมชาย")
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: valuewoman,
                    onChanged: (bool? newValue) {
                      setState(() {
                        valuewoman = newValue!;
                      });
                    },
                  ),
                  const Text("ร้านเสริมสวย")
                ],
              ),
              ElevatedButton(
                  onPressed: () {
                    computeResultBarber();
                  },
                  child: const Text("ค้นหา")),
            ],
          ),
        ),
      ),
    );
  }

  computeResultBarber() {
    List<BarberModel> listbarber = [];
    List<BarberModel> listbarber2 = [];
    List<BarberModel> listbarber3 = [];
    List<BarberModel> listbarber4 = [];

    // เช็คประเภท ร้าน
    if (valueman == false && valuewoman == false) {
      listbarber = barberModel;
    }
    if (valueman == true) {
      for (var i = 0; i < barberModel.length; i++) {
        if (barberModel[i].typebarber == "man") {
          listbarber.add(barberModel[i]);
        }
      }
    }
    if (valuewoman == true) {
      for (var i = 0; i < barberModel.length; i++) {
        if (barberModel[i].typebarber == "woman") {
          listbarber.add(barberModel[i]);
        }
      }
    }
    for (var i = 0; i < listbarber.length; i++) {
      print("step 1 ${listbarber[i]}");
    }

    // เช็คkey word
    if (searchController.text != "") {
      List<BarberModel> databarber = listbarber;
      for (var i = 0; i < databarber.length; i++) {
        if (databarber[i]
            .shopname
            .toLowerCase()
            .contains(searchController.text.toLowerCase())) {
          setState(() {
            listbarber2.add(databarber[i]);
          });
        }
      }
    } else {
      listbarber2 = listbarber;
    }
    for (var i = 0; i < listbarber2.length; i++) {
      print("step 2 ${listbarber2[i]}");
    }

    // เช็ค อำเภอ ตำบล
    if (selectedValueDis != "อำเภอทั้งหมด ") {
      for (var i = 0; i < listbarber2.length; i++) {
        if (listbarber2[i].districtl == selectedValueDis!.trim()) {
          listbarber3.add(listbarber2[i]);
        }
      }
    } else {
      listbarber3 = listbarber2;
    }
    for (var i = 0; i < listbarber3.length; i++) {
      print("step 3 ${listbarber3[i]}");
    }
    if (selectedValueSubDis != "ตำบลทั้งหมด ") {
      for (var i = 0; i < listbarber3.length; i++) {
        if (listbarber3[i].subDistrict == selectedValueSubDis!.trim()) {
          listbarber4.add(listbarber3[i]);
        }
      }
    } else {
      listbarber4 = listbarber3;
    }
    for (var i = 0; i < listbarber4.length; i++) {
      print("step 4 ${listbarber4[i]}");
    }
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultUser(barberModel: listbarber4, nameUser: nameUser,),
        ),
        );
  }

  searchOperation(String searchText) {
    searchresult.clear();
    if (searchController.text != "") {
      for (var i = 0; i < _list!.length; i++) {
        String data = _list![i];
        if (data.toLowerCase().contains(searchText.toLowerCase())) {
          setState(() {
            searchresult.add(data);
          });
        }
      }
    }
  }
}
