import 'package:barber/Constant/route_cn.dart';
import 'package:barber/pages/haircut_user.dart';
import 'package:barber/pages/login.dart';
import 'package:barber/pages/other_user.dart';
import 'package:barber/pages/reservation_user.dart';
import 'package:barber/provider/myproviders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:provider/provider.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 3,
      child: Scaffold(
          body: TabBarView(children: [
            HairCutUser(),
            ReservationUser(),
            OtherUser(),
          ]),bottomNavigationBar: TabBar(tabs: [
            Tab(
              child: Icon(Icons.cut,color: Colors.black,),
            ),
            Tab(
              child: Icon(Icons.format_list_bulleted,color: Colors.black,),
            ),
            Tab(
              child: Icon(Icons.account_box,color: Colors.black,),
            )
          ]),),
    );
  }

  

 
}
