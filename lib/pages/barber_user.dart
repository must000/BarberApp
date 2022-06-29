import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:barber/Constant/route_cn.dart';
import 'package:barber/pages/album_barber_user.dart';
import 'package:barber/pages/comment_barber_user.dart';
import 'package:barber/pages/confirmreserve_user.dart';
import 'package:barber/pages/detail_barber_user.dart';

class BarberUser extends StatefulWidget {
  final String nameShop, lat,
      lon,
      addressdetails,
      phoneNumber,
      timeopen,
      timeclose;
  Map<String, dynamic> dayopen;
  final String? url, recommend;
  
  BarberUser({
    Key? key,
    required this.dayopen,
    required this.recommend, required this.nameShop, required this.lat, required this.lon, required this.addressdetails, required this.phoneNumber, required this.timeopen, required this.timeclose, this.url,
  }) : super(key: key);

  @override
  State<BarberUser> createState() =>
      _BarberUserState(nameShop: nameShop, url: url, recommend: recommend,lat: lat,lon: lon,addressdetails: addressdetails,phoneNumber: phoneNumber,timeopen: timeopen,timeclose: timeclose,dayopen: dayopen);
}

class _BarberUserState extends State<BarberUser> {
  String nameShop;
  String? url, recommend;
    String lat, lon;
  String addressdetails, phoneNumber;
  Map<String, dynamic> dayopen;
  String timeopen, timeclose;
  _BarberUserState({required this.nameShop, this.url, this.recommend,required this.addressdetails,
      required this.phoneNumber,
      required this.dayopen,
      required this.timeopen,
      required this.timeclose,
      required this.lat,
      required this.lon});
  int x = 0;
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;

    late final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text(nameShop),
        actions: [
          buildUsername_Login(user),
        ],
      ),
      body: ListView(children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                height: size * 0.45,
                width: size * 0.6,
                child: Image.network(
                  url == null
                      ? "https://images.ctfassets.net/81iqaqpfd8fy/3r4flvP8Z26WmkMwAEWEco/870554ed7577541c5f3bc04942a47b95/78745131.jpg?w=1200&h=1200&fm=jpg&fit=fill"
                      : url!,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: size * 0.1,
                      )),
                  Container(
                    width: size * 0.33,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailBarberUser(nameShop: nameShop, addressdetails: addressdetails, dayopen: dayopen, lat: lat, lon: lon, phoneNumber: phoneNumber, timeclose: timeclose, timeopen: timeopen,),
                          ),
                        );
                      },
                      child: const Text("ข้อมูลร้าน"),
                    ),
                  ),
                  Container(
                    width: size * 0.33,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AlbumBarberUser(),
                          ),
                        );
                      },
                      child: const Text("ผลงาน"),
                    ),
                  ),
                  Container(
                    width: size * 0.33,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CommentBarberUser(),
                          ),
                        );
                      },
                      child: const Text("คะแนนและรีวิว"),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        Container(
          child: Text("$recommend"),
          margin: const EdgeInsets.symmetric(horizontal: 15),
        ),
        const SizedBox(
          height: 50,
        ),
        ListView.builder(
          shrinkWrap: true, //    <-- Set this to true
          physics: const ScrollPhysics(),
          itemBuilder: (context, index) => Card(
            child: InkWell(
              onTap: () {
                setState(() {
                  x++;
                });
              },
              child: const ListTile(
                title: Text("ชื่อรายการ"),
                subtitle: Text("รายละเอียด"),
                trailing: Text('30 นาที / 60 บาท'),
              ),
            ),
          ),
          itemCount: 10,
        )
      ]),
      bottomNavigationBar: BottomAppBar(
        color: Colors.redAccent,
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ConfirmReserveUser(),
                ));
          },
          child: Container(
            height: 75,
            child: ListTile(
              title: Text(
                "$x รายการ 100 บาท",
                style: const TextStyle(color: Colors.black),
              ),
              subtitle: const Text("60 นาที"),
            ),
          ),
        ),
      ),
    );
  }

  StreamBuilder<User?> buildUsername_Login(User? user) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          return user?.displayName == null
              ? const Text("")
              : Center(
                  child: Text(
                  user!.displayName!,
                  style: const TextStyle(color: Colors.white),
                ));
        } else if (snapshot.hasError) {
          return Text("error");
        } else {
          return TextButton(
              onPressed: () {
                Navigator.pushNamed(context, Rount_CN.routeLogin);
              },
              child: const Text("Login"));
        }
      },
    );
  }
}
