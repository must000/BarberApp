import 'package:flutter/material.dart';

import 'package:barber/data/servicemodel.dart';

class ConfirmReserveUser extends StatefulWidget {
  List<ServiceModel> servicemodel;
  ConfirmReserveUser({
    Key? key,
    required this.servicemodel,
  }) : super(key: key);

  @override
  State<ConfirmReserveUser> createState() => _ConfirmReserveUserState(servicemodel:servicemodel);
}



class _ConfirmReserveUserState extends State<ConfirmReserveUser> {
  List<ServiceModel> servicemodel;
_ConfirmReserveUserState({required this.servicemodel});
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
