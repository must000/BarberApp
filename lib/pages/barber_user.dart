import 'package:barber/data/servicemodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:barber/Constant/route_cn.dart';
import 'package:barber/pages/album_barber_user.dart';
import 'package:barber/pages/comment_barber_user.dart';
import 'package:barber/pages/confirmreserve_user.dart';
import 'package:barber/pages/detail_barber_user.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class BarberUser extends StatefulWidget {
  final String nameShop,
      lat,
      email,
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
    required this.recommend,
    required this.email,
    required this.nameShop,
    required this.lat,
    required this.lon,
    required this.addressdetails,
    required this.phoneNumber,
    required this.timeopen,
    required this.timeclose,
    this.url,
  }) : super(key: key);

  @override
  State<BarberUser> createState() => _BarberUserState(
      nameShop: nameShop,
      email: email,
      url: url,
      recommend: recommend,
      lat: lat,
      lon: lon,
      addressdetails: addressdetails,
      phoneNumber: phoneNumber,
      timeopen: timeopen,
      timeclose: timeclose,
      dayopen: dayopen);
}

class _BarberUserState extends State<BarberUser> {
  String nameShop, email;
  String? url, recommend;
  String lat, lon;
  String addressdetails, phoneNumber;
  Map<String, dynamic> dayopen;
  String timeopen, timeclose;
  _BarberUserState(
      {required this.nameShop,
      this.url,
      this.recommend,
      required this.addressdetails,
      required this.phoneNumber,
      required this.dayopen,
      required this.timeopen,
      required this.timeclose,
      required this.lat,
      required this.lon,
      required this.email});
  int price = 0, z = 0;
  List<ServiceModel> servicemodel = [];
  bool showlist = false;
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
      body: Stack(
        children: [
          ListView(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
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
                                  builder: (context) => DetailBarberUser(
                                    nameShop: nameShop,
                                    addressdetails: addressdetails,
                                    dayopen: dayopen,
                                    lat: lat,
                                    lon: lon,
                                    phoneNumber: phoneNumber,
                                    timeclose: timeclose,
                                    timeopen: timeopen,
                                  ),
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
                                  builder: (context) => AlbumBarberUser(
                                    email: email,
                                  ),
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
                                  builder: (context) =>
                                      const CommentBarberUser(),
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
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Service')
                    .doc(email)
                    .collection("service")
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    var data = snapshot.data.docs;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (_, index) {
                        var userData = data[index];
                        return InkWell(
                          child: Card(
                            child: ListTile(
                              title: Text(userData['name']),
                              subtitle: Text(userData['detail']),
                              trailing: Wrap(children: [
                                Text(
                                    "${userData['time'].toString()} นาที / ${userData["price"].toString()} บาท"),
                              ]),
                            ),
                          ),
                          onTap: () {
                            int x = userData['price'].toInt();
                            setState(() {
                              z += 1;
                              price = price + x;
                              servicemodel.add(
                                ServiceModel(
                                    id: userData.id,
                                    name: userData['name'],
                                    detail: userData['detail'],
                                    time: userData['time'],
                                    price: userData['price']),
                              );
                              // print("${price.toString()}");
                            });
                          },
                        );
                      },
                      itemCount: data.length,
                    );
                  }
                  return LoadingAnimationWidget.waveDots(
                      color: Colors.blue, size: 200);
                },
              ),
            ],
          ),
          showlist == false
              ? SizedBox()
              : Positioned(
                  child: servicemodel.isEmpty
                      ? const Text('')
                      : Container(
                          decoration: const BoxDecoration(color: Colors.grey),
                          height: 50 + 75 * servicemodel.length.toDouble(),
                          width: 330,
                          child: Column(
                            children: [
                              Container(
                                decoration:
                                    BoxDecoration(color: Colors.grey[850]),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Text(
                                        "บริการ ( $z )",
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) => Card(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                                "  ${servicemodel[index].name}"),
                                          ),
                                          Expanded(
                                              flex: 1,
                                              child: Row(
                                                children: [
                                                  Text(
                                                      "${servicemodel[index].price.toString()} บาท"),
                                                  IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                           price = price - servicemodel[index].price.toInt();
                                                          servicemodel.remove(
                                                              servicemodel[
                                                                  index]);
                                                                 
                                                        });
                                                      },
                                                      icon: const Icon(
                                                        Icons.delete,
                                                        size: 20,
                                                        color: Colors.red,
                                                      ))
                                                ],
                                              )),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                                "  ${servicemodel[index].detail}"),
                                          ),
                                          Expanded(
                                              flex: 1,
                                              child: Text(
                                                  "${servicemodel[index].time.toString()} นาที"))
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                itemCount: servicemodel.length,
                              ),
                            ],
                          ),
                        ),
                  bottom: 4,
                  left: 20,
                )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(255, 85, 85, 85),
        child: Container(
          height: 55,
          child: ListTile(
            title: Row(
              children: [
                Text(
                  "ยอดรวม ${price.toString()}",
                  style: const TextStyle(color: Colors.black),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        showlist = !showlist;
                      });
                    },
                    icon: const Padding(
                      padding: EdgeInsets.only(bottom: 30),
                      child: Icon(
                        Icons.keyboard_double_arrow_up,
                        color: Colors.white,
                      ),
                    ))
              ],
            ),
            trailing: ElevatedButton(
              child: const Text("ดำเนินการต่อ"),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ))),
              onPressed: () {
                if (servicemodel.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConfirmReserveUser(
                       dayopen: dayopen,
                       timeclose: timeclose,timeopen: timeopen,
                        servicemodel: servicemodel,
                      ),
                    ),
                  );
                }
              },
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
          return const Text("error");
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
