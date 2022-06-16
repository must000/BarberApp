import 'dart:async';
import 'dart:collection';

import 'package:barber/pages/other_barber.dart';
import 'package:barber/pages/queue_barber.dart';
import 'package:barber/pages/service_barber.dart';
import 'package:barber/pages/store_barber.dart';
import 'package:barber/utils/show_progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:barber/pages/haircut_user.dart';
import 'package:barber/pages/other_user.dart';
import 'package:barber/pages/reservation_user.dart';

class IndexPage extends StatefulWidget {
  bool? isbarber;
  IndexPage({
    Key? key,
    this.isbarber,
  }) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState(isbarber: isbarber);
}

class _IndexPageState extends State<IndexPage> {
  String? email;
  bool load = true;

  @override
  void initState() {
    super.initState();
    findEmail().then((value) {
      setState(() {
        load = false;
      });
    });
  }

  bool? isbarber;

  Future<Null> findEmail() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        setState(() {
          email = event!.email;
        });
        final data =
            FirebaseFirestore.instance.collection('Barber').doc(event!.email);
        final snapshot = await data.get();
        if (snapshot.exists) {
          setState(() {
            isbarber = true;
            load = false;
          });
        }
      });
    });
  }

  _IndexPageState({this.isbarber});
  @override
  Widget build(BuildContext context) {
    return load == true
        ? const ShowProgress()
        : isbarber == null
            ? const DefaultTabController(
                length: 3,
                child: Scaffold(
                  body: TabBarView(children: [
                    HairCutUser(),
                    ReservationUser(),
                    OtherUser(),
                  ]),
                  bottomNavigationBar: TabBar(tabs: [
                    Tab(
                      child: Icon(
                        Icons.cut,
                        color: Colors.black,
                      ),
                    ),
                    Tab(
                      child: Icon(
                        Icons.format_list_bulleted,
                        color: Colors.black,
                      ),
                    ),
                    Tab(
                      child: Icon(
                        Icons.account_box,
                        color: Colors.black,
                      ),
                    )
                  ]),
                ),
              )
            : DefaultTabController(
                length: 4,
                child: Scaffold(
                  body: TabBarView(children: [
                    const QueueBarber(),
                    ServiceBarber(
                      email: email!,
                    ),
                    StoreBarber(email: email!,),
                    const OtherBarber(),
                  ]),
                  bottomNavigationBar: const TabBar(tabs: [
                    Tab(
                      child: Icon(
                        Icons.table_chart_outlined,
                        color: Colors.black,
                      ),
                    ),
                    Tab(
                      child: Icon(
                        Icons.cut_sharp,
                        color: Colors.black,
                      ),
                    ),
                    Tab(
                      child: Icon(
                        Icons.store,
                        color: Colors.black,
                      ),
                    ),
                    Tab(
                      child: Icon(
                        Icons.account_box,
                        color: Colors.black,
                      ),
                    )
                  ]),
                ));
  }
}
