import 'package:barber/data/hairdressermodel.dart';
import 'package:barber/main.dart';
import 'package:barber/provider/myproviders.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:barber/Constant/contants.dart';
import 'package:barber/Constant/route_cn.dart';
import 'package:barber/data/barbermodel.dart';
import 'package:barber/data/servicemodel.dart';
import 'package:barber/data/sqlite_model.dart';
import 'package:barber/pages/User/album_barber_user.dart';
import 'package:barber/pages/User/comment_barber_user.dart';
import 'package:barber/pages/User/detail_barber_user.dart';
import 'package:barber/pages/User/haircut_user.dart';
import 'package:barber/pages/User/select_datetime_user.dart';
import 'package:barber/utils/sqlite_helper.dart';
import 'package:provider/provider.dart';

class BarberUser extends StatefulWidget {
  final String nameUser;
  BarberModel barberModel;
  String? url;
  Function? callback;
  BarberUser(
      {Key? key,
      required this.barberModel,
      required this.nameUser,
      this.url,
      this.callback})
      : super(key: key);

  @override
  State<BarberUser> createState() => _BarberUserState(
        barberModel: barberModel,
        nameUser: nameUser,
        url: url,
      );
}

class _BarberUserState extends State<BarberUser> {
  String nameUser;
  BarberModel barberModel;
  String? url;
  List<HairdresserModel> hairdressermodel = [];
  _BarberUserState({
    required this.barberModel,
    required this.nameUser,
    this.url,
  });
  int price = 0, z = 0;
  List<ServiceModel> servicemodel = [];
  bool showlist = false;
  bool like = false;
  List<SQLiteModel> sqliteModels = [];
  Map<String, String> urlImgHairdresser = {};
  bool loadingHairdresser = true;
  int numberUserSelect = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHairdresser();
    processReadSQLite();
  }

  Future<Null> getHairdresser() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await FirebaseFirestore.instance
        .collection('Hairdresser')
        .where("barberState", isEqualTo: barberModel.email)
        .snapshots()
        .listen((event) async {
      var doc = event.docs;
      if (doc.isNotEmpty) {
        List<HairdresserModel> data = [];
        for (var i = 0; i < doc.length; i++) {
          data.add(HairdresserModel(
              email: doc[i].data()["email"],
              idCode: doc[i].data()["idCode"],
              name: doc[i].data()["name"],
              lastname: doc[i].data()["lastname"],
              serviceID: doc[i].data()["serviceID"],
              barberStatus: doc[i].data()["barberState"]));
        }
        Map<String, String>? urlImgFront = {};
        for (var i = 0; i < data.length; i++) {
          Reference ref = FirebaseStorage.instance
              .ref()
              .child("avatar/${doc[i].data()["email"]}");
          var url = await ref.getDownloadURL().then((value) {
            urlImgFront[doc[i].data()["email"]] = value;
            // print(value);
          }).catchError((c) => print(c + "is an error"));
        }
        setState(() {
          hairdressermodel = data;
          urlImgHairdresser = urlImgFront;
          loadingHairdresser = false;
        });
      } else {
        // print("daaaaaa");
      }
    }, onError: (error) => print("Listen failed: $error"));
  }

  Future<Null> processReadSQLite() async {
    if (sqliteModels.isNotEmpty) {
      sqliteModels.clear();
    }
    await SQLiteHelper().readSQLite().then((value) {
      sqliteModels = value;
      for (var i = 0; i < value.length; i++) {
        if (value[i].email == barberModel.email) {
          setState(() {
            like = true;
          });
        }
      }
      // print("sqlite");
      // print(sqliteModels);
    });
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    late final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: Contants.myBackgroundColor,
      appBar: AppBar(
        backgroundColor: Contants.myBackgroundColordark,
        title: Text(barberModel.shopname),
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
                            onPressed: () async {
                              if (like == false) {
                                SQLiteModel sqLiteModel =
                                    SQLiteModel(email: barberModel.email);
                                await SQLiteHelper()
                                    .insertValueToSQlite(sqLiteModel);
                                setState(() {
                                  barberLike.add(barberModel);
                                  urlImgLike.addAll({barberModel.email: url!});
                                  print("Like ======> $barberLike");
                                  like = true;
                                });
                                //รีเฟรช
                                print(barberModel);
                                print(url);
                                streamController2.add(barberModel);
                              } else {
                                await SQLiteHelper()
                                    .deleteSQLiteWhereId(barberModel.email);
                                setState(() {
                                  like = false;
                                  barberLike.remove(barberModel);
                                  urlImgLike.remove(barberModel.email);
                                });
                                streamController2.add(barberModel);
                              }
                            },
                            icon: Icon(
                              Icons.favorite,
                              color: like ? Colors.red : Colors.grey,
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
                                    nameShop: barberModel.shopname,
                                    addressdetails: barberModel.addressdetails,
                                    dayopen: barberModel.dayopen,
                                    lat: barberModel.lat,
                                    lon: barberModel.lng,
                                    phoneNumber: barberModel.phone,
                                    timeclose: barberModel.timeclose,
                                    timeopen: barberModel.timeopen,
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
                                    email: barberModel.email,
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
                child: Text(
                  barberModel.shoprecommend,
                  style: Contants().h3white(),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 15),
              ),
              const SizedBox(
                height: 30,
              ),
              loadingHairdresser
                  ? const SizedBox()
                  : SizedBox(
                      height: 120,
                      child: Expanded(
                        flex: 3,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: hairdressermodel.length,
                          itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              setState(() {
                                numberUserSelect = index;
                              });
                            },
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: urlImgHairdresser[
                                        hairdressermodel[index].email]!,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      width: 80.0,
                                      height: 80.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                    placeholder: (context, url) =>
                                        LoadingAnimationWidget.inkDrop(
                                            color: Colors.black, size: 20),
                                  ),
                                ),
                                Text(
                                  hairdressermodel[index].name,
                                  style: Contants().h4white(),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
              loadingHairdresser ? const SizedBox() : serviceList(),
            ],
          ),
          showlist == false
              ? const SizedBox()
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
                                                          z = z - 1;
                                                          price = price -
                                                              servicemodel[
                                                                      index]
                                                                  .price
                                                                  .toInt();
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
                      builder: (context) => SelectDateTimeUser(
                        dayopen: barberModel.dayopen,
                        timeclose: barberModel.timeclose,
                        timeopen: barberModel.timeopen,
                        servicemodel: servicemodel,
                        email: barberModel.email,
                        nameBarber: barberModel.shopname,
                        nameUser: nameUser,
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

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> serviceList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Service')
          .doc(hairdressermodel[numberUserSelect].serviceID)
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

        return LoadingAnimationWidget.waveDots(color: Colors.blue, size: 200);
      },
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
