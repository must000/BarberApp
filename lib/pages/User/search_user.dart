import 'package:barber/Constant/contants.dart';
import 'package:barber/pages/User/barber_user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:barber/Constant/district_cn.dart';
import 'package:barber/data/barbermodel.dart';

class SearchUser extends StatefulWidget {
  String nameUser;
  SearchUser({
    required this.nameUser,
    Key? key,
  }) : super(key: key);

  @override
  State<SearchUser> createState() => _SearchUserState(nameUser: nameUser);
}

class _SearchUserState extends State<SearchUser> {
  List<BarberModel> barberModel = [];
  String nameUser;
  _SearchUserState({required this.nameUser});
  List<String> itemsDistrict = ["อำเภอทั้งหมด "] + District_CN.district;
  TextEditingController searchController = TextEditingController();
  List<String> itemSubDistricts = [];
  bool valueman = true, valuewoman = true;
  String? selectedValueDis = "อำเภอทั้งหมด ",
      selectedValueSubDis = "ตำบลทั้งหมด ";
  List searchresult = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Contants.myBackgroundColor,
      appBar: AppBar(
        backgroundColor: Contants.myBackgroundColordark,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
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
                  style: Contants().h3OxfordBlue(),
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintStyle: Contants().h3Grey(),
                    hintText: "ค้นหาด้วยชื่อร้าน",
                    labelStyle: Contants().h3OxfordBlue(),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  // onChanged: searchOperation,
                  // onEditingComplete: () {},
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                activeColor: Contants.colorSpringGreen,
                                value: valueman,
                                onChanged: (bool? newValue) {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  setState(() {
                                    valueman = newValue!;
                                  });
                                },
                              ),
                              Text(
                                "ร้านตัดผมชาย",
                                style: Contants().h4white(),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                activeColor: Contants.colorSpringGreen,
                                value: valuewoman,
                                onChanged: (bool? newValue) {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  setState(() {
                                    valuewoman = newValue!;
                                  });
                                },
                              ),
                              Text(
                                "ร้านเสริมสวย",
                                style: Contants().h4white(),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              iconEnabledColor: Contants.colorWhite,
                              hint: Text('$selectedValueDis',
                                  style: Contants().h3white()),
                              items: itemsDistrict
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(item,
                                            style: Contants().h4OxfordBlue()),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                if (value == 'อ.เมืองนนทบุรี ') {
                                  itemSubDistricts = ["ตำบลทั้งหมด "] +
                                      District_CN.mueangNonthaburi;
                                } else if (value == 'อ.บางกรวย') {
                                  itemSubDistricts =
                                      ["ตำบลทั้งหมด "] + District_CN.bangKruai;
                                } else if (value == 'อ.บางใหญ่ ') {
                                  itemSubDistricts =
                                      ["ตำบลทั้งหมด "] + District_CN.bangYai;
                                } else if (value == 'อ.บางบัวทอง') {
                                  itemSubDistricts = ["ตำบลทั้งหมด "] +
                                      District_CN.bangBuaThong;
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
                            iconEnabledColor: Contants.colorWhite,
                            hint: Text('$selectedValueSubDis',
                                style: Contants().h3white()),
                            items: itemSubDistricts
                                .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(item,
                                          style: Contants().h4OxfordBlue()),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              FocusScope.of(context).requestFocus(FocusNode());
                              setState(() {
                                selectedValueSubDis = value as String;
                              });
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: size * 0.55,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          onPrimary: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          searchOperation(searchController.text);
                        },
                        child:
                            Text("ค้นหา ", style: Contants().h1OxfordBlue())),
                  ),
                  SizedBox(
                    width: size * 0.2,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          onPrimary: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          setState(() {
                            selectedValueDis = "อำเภอทั้งหมด ";
                            selectedValueSubDis = "ตำบลทั้งหมด ";
                            valueman = true;
                            valuewoman = true;
                            searchController.text = "";
                          });
                        },
                        child: Text("ล้าง ", style: Contants().h2white())),
                  ),
                ],
              ),
              const Divider(
                height: 10,
                thickness: 2,
                indent: 20,
                endIndent: 20,
                color: Colors.white,
              ),
              barberModel.isEmpty
                  ? Text("ไม่พบร้านทำผมที่อยู่ในเงื่อนไข",style: Contants().h2Red(),)
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          height: 100,
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          child: InkWell(
                            onTap: () {
                              print(barberModel[index].email);
                              FocusScope.of(context).requestFocus(FocusNode());
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BarberUser(
                                        barberModel: barberModel[index],
                                        url: barberModel[index].url,
                                        nameUser: nameUser),
                                  ));
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: Colors.white70, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: Contants.colorBlack,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: barberModel[index].url,
                                        width: size * 0.3,
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                          Icons.error,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        width: size * 0.01,
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            barberModel[index].shopname,
                                            style: Contants().h3white(),
                                          ),
                                          Text(
                                            barberModel[index].shoprecommend,
                                            style: Contants().h4white(),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        barberModel[index].score == 0 ||
                                                barberModel[index].score.isNaN
                                            ? "- "
                                            : "${barberModel[index].score}",
                                        style: const TextStyle(
                                            color: Colors.yellow, fontSize: 12),
                                      ),
                                      const Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: barberModel.length,
                    )
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> searchOperation(String searchText) async {
    List<String> type = ["man", "woman"];
    List<BarberModel> list = [];
    // เช็คประเภท ร้าน
    if (valueman == true && valuewoman == true) {
      type = ["man", "woman"];
    } else if (valueman == true && valuewoman == false) {
      type = ["man"];
    } else if (valuewoman == true && valueman == false) {
      type = ["woman"];
    } else {
      type = ["man", "woman"];
    }
    if (selectedValueDis != "อำเภอทั้งหมด ") {
      String where, key;
      if (selectedValueSubDis != "ตำบลทั้งหมด ") {
        where = "subdistrict";
        key = selectedValueSubDis!;
      } else {
        where = "district";
        key = selectedValueDis!;
      }
      // print("position.${where}");
      var data = await FirebaseFirestore.instance
          .collection('Barber')
          .where("typeBarber", whereIn: type)
          .where("position.$where", isEqualTo: key.trim())
          .orderBy("shopname")
          .limit(50)
          .startAt([searchText])
          .endAt([searchText + "\uf8ff"])
          .get()
          .then((value) {
            var data = value.docs.map((e) => e.data()).toList();
            for (var i = 0; i < data.length; i++) {
              double average;
              if (data[i]["score"] != null) {
                average = data[i]["score"]["num"] / data[i]["score"]["count"];
              } else {
                average = 0;
              }

              list.add(BarberModel(
                  email: data[i]["email"],
                  name: data[i]["name"],
                  lasiName: data[i]["lastname"],
                  phone: data[i]["phone"],
                  typebarber: data[i]["typeBarber"],
                  shopname: data[i]["shopname"],
                  shoprecommend: data[i]["shoprecommend"],
                  dayopen: data[i]["dayopen"],
                  timeopen: data[i]["timeopen"],
                  timeclose: data[i]["timeclose"],
                  lat: data[i]["position"]["lat"],
                  lng: data[i]["position"]["lng"],
                  districtl: data[i]["position"]["district"],
                  subDistrict: data[i]["position"]["subdistrict"],
                  addressdetails: data[i]["position"]["addressdetails"],
                  url: data[i]["url"],
                  score: average,
                  geoHasher: data[i]["position"]["geohash"]));
            }
            setState(() {
              barberModel = list;
            });
          });
    } else {
      print("11");
      var data = await FirebaseFirestore.instance
          .collection('Barber')
          .where("typeBarber", whereIn: type)
          .orderBy("shopname")
          .limit(50)
          .startAt([searchText])
          .endAt([searchText + "\uf8ff"])
          .get()
          .then((value) {
            var data = value.docs.map((e) => e.data()).toList();
            for (var i = 0; i < data.length; i++) {
              double average;
              if (data[i]["score"] != null) {
                average = data[i]["score"]["num"] / data[i]["score"]["count"];
              } else {
                average = 0;
              }
              list.add(BarberModel(
                  email: data[i]["email"],
                  name: data[i]["name"],
                  lasiName: data[i]["lastname"],
                  phone: data[i]["phone"],
                  typebarber: data[i]["typeBarber"],
                  shopname: data[i]["shopname"],
                  shoprecommend: data[i]["shoprecommend"],
                  dayopen: data[i]["dayopen"],
                  timeopen: data[i]["timeopen"],
                  timeclose: data[i]["timeclose"],
                  lat: data[i]["position"]["lat"],
                  lng: data[i]["position"]["lng"],
                  districtl: data[i]["position"]["district"],
                  subDistrict: data[i]["position"]["subdistrict"],
                  addressdetails: data[i]["position"]["addressdetails"],
                  url: data[i]["url"],
                  score: average,
                  geoHasher: data[i]["position"]["geohash"]));
            }
            setState(() {
              barberModel = list;
            });
          });
    }
  }
}
