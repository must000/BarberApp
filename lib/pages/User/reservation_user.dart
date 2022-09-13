import 'package:barber/Constant/contants.dart';
import 'package:barber/pages/User/reservation_detail_user.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';

class ReservationUser extends StatefulWidget {
  const ReservationUser({Key? key}) : super(key: key);

  @override
  State<ReservationUser> createState() => _ReservationUserState();
}

class _ReservationUserState extends State<ReservationUser> {
  int _selectedIndex = 0;
  final ScrollController _homeController = ScrollController();
  Widget _listViewBody() {
    return ListView.separated(
        controller: _homeController,
        itemBuilder: (BuildContext context, int index) {
          return Center(
            child: Text(
              'Item $index',
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(
              thickness: 1,
            ),
        itemCount: 50);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Contants.myBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Center(
            child: Text(
          "การจองของคุณ",
          textAlign: TextAlign.center,
          style: Contants().h1white(),
        )),
        backgroundColor: Contants.myBackgroundColordark,
        bottom: TabBar(
            onTap: (int index) {
              // switch (index) {
              //   case 0:
              //     // only scroll to top when current index is selected.
              //     if (_selectedIndex == index) {
              //       _homeController.animateTo(
              //         0.0,
              //         duration: const Duration(milliseconds: 500),
              //         curve: Curves.easeOut,
              //       );
              //     }
              //     break;
              //   case 1:
              //     showModal(context);
              //     break;
              // }
              setState(
                () {
                  _selectedIndex = index;
                },
              );
            },
            tabs: [
              Tab(
                text: "กำลังดำเนินการ",
              ),
              Tab(
                text: "สำเร็จ",
              ),
              Tab(
                text: "ยกเลิก/ล้มเหลว",
              ),
            ]),
      ),
      body: _listViewBody(),
    );
  }
}

      //  ListView.builder(
      //   itemCount: 4,
      //   itemBuilder: (context, index) => InkWell(
      //     onTap: () => Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => const ReservationDetailUser(),
      //       ),
      //     ),
      //     child: Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 25),
      //       child: Card(
      //         shape: const RoundedRectangleBorder(
      //             borderRadius: BorderRadius.all(Radius.circular(20))),
      //         child: ListTile(
      //           leading: Image.network(
      //             "https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/16062302043/original/DG8pZuOlxkBvfdnIg1j6jv5-Tw54bIb_QA.png?1608144943",
      //             scale: 20,
      //           ),
      //           title: const Text("ชื่อร้าน ราคา"),
      //           subtitle: const Text("เวลา 17-00.19.00"),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),