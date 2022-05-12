import 'package:barber/pages/other_barber.dart';
import 'package:barber/pages/queue_barber.dart';
import 'package:barber/pages/service_barber.dart';
import 'package:barber/pages/store_barber.dart';
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
  bool? isbarber;
  _IndexPageState({this.isbarber});
  @override
  Widget build(BuildContext context) {
    return isbarber == null
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
        : const DefaultTabController(
            length: 4,
            child: Scaffold(
              body: TabBarView(children: [
                QueueBarber(),
                ServiceBarber(),
                StoreBarber(),
                OtherBarber(),
              ]),
              bottomNavigationBar: TabBar(tabs: [
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
