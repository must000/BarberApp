import 'package:flutter/material.dart';

class HairCutUser extends StatefulWidget {
  const HairCutUser({ Key? key }) : super(key: key);

  @override
  State<HairCutUser> createState() => _HairCutUserState();
}

class _HairCutUserState extends State<HairCutUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("cut")),
    );
  }
}