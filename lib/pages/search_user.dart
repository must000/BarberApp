import 'package:barber/Constant/district_cn.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class SearchUser extends StatefulWidget {
  const SearchUser({Key? key}) : super(key: key);

  @override
  State<SearchUser> createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  final List<String> items = District_CN.district;
  bool valueman = false, valuewoman = false;
  String? selectedValue;
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            margin:
                EdgeInsets.only(top: 15, left: size * 0.08, right: size * 0.08),
            child: TextFormField(
              validator: (value) {
                // if (value!.isEmpty) {
                //   return "กรุณากรอกชื่อ";
                // } else {}
              },
              // controller: nameController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Search Engine",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          Row(
            children: [
              DropdownButtonHideUnderline(
                  child: DropdownButton2(
                hint: Text(
                  'Select Item',
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
                  setState(() {
                    selectedValue = value as String;
                  });
                },
              ))
            ],
          ),
          Checkbox(
            value: this.valueman,
            onChanged: (bool? newValue) {
              setState(() {
                valueman = newValue!;
              });
            },
          ),
          Checkbox(
            value: this.valuewoman,
            onChanged: (bool? newValue) {
              setState(() {
                valuewoman = newValue!;
              });
            },
          )
        ],
      ),
    );
  }
}
