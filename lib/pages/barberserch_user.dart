import 'package:barber/pages/haircut_user.dart';
import 'package:barber/pages/other_user.dart';
import 'package:barber/pages/reservation_user.dart';
import 'package:flutter/material.dart';

import '../widgets/barbermodel1.dart';

class BarberSerchUser extends StatefulWidget {
  final bool typeBarber;
  const BarberSerchUser({Key? key, required this.typeBarber}) : super(key: key);

  @override
  State<BarberSerchUser> createState() =>
      _BarberSerchUserState(typeBarber: this.typeBarber);
}

class _BarberSerchUserState extends State<BarberSerchUser> {
  bool typeBarber;
  _BarberSerchUserState({required this.typeBarber});
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text(typeBarber == true ? "ร้านตัดผมชาย" : "ร้านเสริมสวย"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              sectionListview(size, "ร้านยอดฮิต"),
              listStoreHistory(size),
              sectionListview(size, "ร้านที่เคยใช้บริการ"),
              listStoreHistory(size),
              sectionListview(size, "ร้านที่ถูกใจ"),
              listStoreLike(size),
              ListView.builder(
                shrinkWrap: true, //    <-- Set this to true
                physics: ScrollPhysics(),
                itemBuilder: (context, index) => Card(
                  child: ListTile(
                    title: Text("ชื่อร้าน"),
                    trailing: IconButton(
                        onPressed: () {}, icon: const Icon(Icons.favorite)),
                    leading: Image.network(
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTmY6B2ye2mMyWxqH4YzDWxE0fpB43lcrBhig&usqp=CAU"),
                  ),
                ),
                itemCount: 10,
              )
            ],
          ),
        ));
  }

  Container sectionListview(double size, String title) {
    return Container(
      child: Text(
        title,
        style: const TextStyle(fontSize: 20),
      ),
      width: size,
      padding: EdgeInsets.symmetric(horizontal: size * 0.1),
    );
  }

  Container listStoreLike(double size) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 140,
      child: Expanded(
        flex: 3,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 20,
            itemBuilder: (context, index) => BarberModel1(
                  size: size,
                  nameBarber: "ร้านที่ถูกใจ",
                )),
      ),
    );
  }

  Container listStoreHistory(double size) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 140,
      child: Expanded(
        flex: 3,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 20,
          itemBuilder: (context, index) => BarberModel1(
            size: size,
            nameBarber: "ชื่อร้าน",
            img:
                "https://images.ctfassets.net/81iqaqpfd8fy/3r4flvP8Z26WmkMwAEWEco/870554ed7577541c5f3bc04942a47b95/78745131.jpg?w=1200&h=1200&fm=jpg&fit=fill",
            score: "4",
          ),
        ),
      ),
    );
  }
}
