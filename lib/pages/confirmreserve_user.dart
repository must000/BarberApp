import 'package:flutter/material.dart';

class ConfirmReserveUser extends StatefulWidget {
  const ConfirmReserveUser({Key? key}) : super(key: key);

  @override
  State<ConfirmReserveUser> createState() => _ConfirmReserveUserState();
}

class _ConfirmReserveUserState extends State<ConfirmReserveUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView(
            children: const [Center(child: Text("รายการ")),
            
            ],
          ),
        ));
  }
}
