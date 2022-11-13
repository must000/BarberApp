import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:barber/Constant/contants.dart';

class TextFieldModel1 extends StatelessWidget {
  double size;
  TextEditingController controller;
  String title;
  TextFieldModel1({
    Key? key,
    required this.size,
    required this.controller,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
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
}
