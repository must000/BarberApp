import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:barber/Constant/district_cn.dart';
import 'package:barber/data/barbermodel.dart';

class SearchUser extends StatefulWidget {
  List<BarberModel> barberModel;
  SearchUser({
    Key? key,
    required this.barberModel,
  }) : super(key: key);

  @override
  State<SearchUser> createState() => _SearchUserState(barberModel: barberModel);
}

class _SearchUserState extends State<SearchUser> {
  List<BarberModel> barberModel;
  _SearchUserState({required this.barberModel});
  final List<String> itemsDistrict = District_CN.district;
  TextEditingController searchController = TextEditingController();
  List<String> itemSubDistricts = [];
  bool valueman = false, valuewoman = false;
  String? selectedValueDis = "อำเภอ", selectedValueSubDis = "ตำบล";
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
      _list!.add(barberModel[i].name);
    }
    print(_list);
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
                ),
              ),
              searchresult.length != 0
                  ? ListView.builder(
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
                            height: 50,
                            width: size * 0.7,
                            decoration: BoxDecoration(border: Border.all()),
                            child: Text(listData.toString()),
                          ),
                        );
                      },
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
                          itemSubDistricts = District_CN.mueangNonthaburi;
                        } else if (value == 'บางกรวย') {
                          itemSubDistricts = District_CN.bangKruai;
                        } else if (value == 'บางใหญ่ ') {
                          itemSubDistricts = District_CN.bangYai;
                        } else if (value == 'บางบัวทอง') {
                          itemSubDistricts = District_CN.bangBuaThong;
                        } else if (value == 'ไทรน้อย') {
                          itemSubDistricts = District_CN.sainoi;
                        } else if (value == 'ปากเกร็ด') {
                          itemSubDistricts = District_CN.pakKret;
                        } else {
                          itemSubDistricts = [];
                        }
                        setState(() {
                          itemSubDistricts;
                          selectedValueSubDis = "ตำบล";
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
                  const Text("ร้านตัดหญิง")
                ],
              ),
              ElevatedButton(
                  onPressed: () {
                    print(
                        "$valueman $valuewoman $selectedValueDis $selectedValueSubDis ${searchController.text}");
                    computeResultBarber();
                  },
                  child: const Text("ค้นหา"))
            ],
          ),
        ),
      ),
    );
  }

  computeResultBarber() {
    List<BarberModel> listbarber = [];
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
