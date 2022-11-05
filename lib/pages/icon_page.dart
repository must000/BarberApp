import 'dart:async';

import 'package:barber/Constant/contants.dart';
import 'package:barber/pages/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class IconAppPage extends StatefulWidget {
  const IconAppPage({Key? key}) : super(key: key);

  @override
  State<IconAppPage> createState() => _IconAppPageState();
}

class _IconAppPageState extends State<IconAppPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    const twentyMillis = Duration(seconds: 3);
    Timer(twentyMillis, () {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => IndexPage(),), (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Contants.myBackgroundColor,
      body: Center(child: Image.asset("images/iconapp.png")),
    );
  }
}
